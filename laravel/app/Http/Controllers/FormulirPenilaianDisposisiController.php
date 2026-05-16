<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Aspek;
use App\Models\Domain;
use App\Models\Formulir;
use App\Models\FormulirPenilaianDisposisi;
use App\Models\Indikator;
use App\Models\Penilaian;
use App\Services\AssessmentCalculationService;
use App\Services\PenilaianSelectionService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class FormulirPenilaianDisposisiController extends Controller
{
    protected AssessmentCalculationService $calculationService;

    public function __construct(
        AssessmentCalculationService $calculationService,
        private readonly PenilaianSelectionService $penilaianSelectionService,
    ) {
        $this->calculationService = $calculationService;
    }

    /**
     * Display a listing of the resource.
     */
    public function tersedia()
    {
        // Cek role pengguna yang sedang login
        $user = Auth::user();

        // Jika role adalah walidata atau admin, tampilkan semua formulir yang sudah dinilai
        if ($user->role === 'walidata' || $user->role === 'admin') {
            $penilaianSelesai = Formulir::operational()
                ->with('creator')
                ->whereHas('penilaians.user', function ($query) {
                    $query->where('role', 'opd');
                })
                ->paginate(10)
                ->withQueryString();
        }
        // Jika role adalah OPD, tampilkan hanya formulir yang dibuat atau dinilai oleh OPD tersebut
        else if ($user->role === 'opd') {
            $penilaianSelesai = Formulir::operational()->with('creator')->whereHas('penilaians', function ($query) use ($user) {
                $query->where('user_id', $user->id)
                      ->orWhere('created_by_id', $user->id);
            })->paginate(10)->withQueryString();

            // Jika tidak ada kegiatan penilaian, kembalikan dengan pesan
            if ($penilaianSelesai->isEmpty()) {
                return redirect()->back()->with('error', 'Silahkan buat kegiatan terlebih dahulu!');
            }
        }
        // Untuk role lain, kembalikan collection kosong
        else {
            $penilaianSelesai = collect();
        }

        $countMaxPeserta = User::whereRole('opd')->count();
        $progresPenialian = '';

        return view('dashboard.disposisi.disposisi-index', compact('penilaianSelesai', 'countMaxPeserta'));
    }


    public function detail($formulir)
    {
        $formulir = Formulir::operational()->whereNamaFormulir($formulir)->first();
        abort_if(!$formulir, 404, 'Formulir tidak ditemukan');
        $formulir->load('domains.aspek.indikator.penilaian.user');

        // Cek role pengguna yang sedang login
        $user = Auth::user();

        // Jika role adalah walidata atau admin, tampilkan semua OPD yang menilai
        if ($user->role === 'walidata' || $user->role === 'admin') {
            $opdsMenilai = User::with('penilaians.formulir.formulir_domains.domain.aspek.indikator')
                ->where('role', 'opd')
                ->whereHas('penilaians', function ($query) use ($formulir) {
                    $query->where('formulir_id', $formulir->id);
                })->paginate(10)->withQueryString()->through(function ($opd) use ($formulir) {
                    return [
                        'opd' => $opd,
                        'domains' => $opd->penilaians->where('formulir_id', $formulir->id)->map(function ($penilaian) {
                            return $penilaian->formulir->formulir_domains->map(function ($fd) {
                                return $fd->domain;
                            });
                        })->flatten()->unique()
                    ];
                });
            // Untuk walidata dan admin, ambil perbandingan hasil semua OPD
            $perbandinganHasil = $this->getPerbandinganHasilForAllOPD($formulir);
        }
        // Jika role adalah OPD, tampilkan hanya data untuk OPD tersebut
        else if ($user->role === 'opd') {
            // Pastikan formulir ada
            if (!$formulir) {
                abort(404, 'Formulir tidak ditemukan');
            }
            
            // Pastikan OPD hanya melihat formulir yang dibuat atau dinilai oleh mereka
            $hasPenilaian = $formulir->penilaians()->where('user_id', $user->id)->exists();
            $isCreator = $formulir->created_by_id == $user->id;
            
            if (!$hasPenilaian && !$isCreator) {
                abort(403, 'Anda tidak memiliki akses ke formulir ini');
            }

            $opdsMenilai = User::with('penilaians.formulir.formulir_domains.domain.aspek.indikator')
                ->whereHas('penilaians', function ($query) use ($formulir, $user) {
                    $query->where('formulir_id', $formulir->id)
                          ->where('user_id', $user->id);
                })->paginate(10)->withQueryString()->through(function ($opd) use ($formulir) {
                    return [
                        'opd' => $opd,
                        'domains' => $opd->penilaians->where('formulir_id', $formulir->id)->map(function ($penilaian) {
                            return $penilaian->formulir->formulir_domains->map(function ($fd) {
                                return $fd->domain;
                            });
                        })->flatten()->unique()
                    ];
                });

            // Ambil perbandingan hasil akhir hanya untuk OPD yang sedang login
            $perbandinganHasil = $this->getPerbandinganHasilForOPD($formulir, $user);
        }
        // Untuk role lain, kembalikan collection kosong
        else {
            $opdsMenilai = collect();
            $perbandinganHasil = [];
        }

        return view('dashboard.disposisi.disposisi-detail', compact('formulir', 'opdsMenilai', 'perbandinganHasil'));
    }


    public function koreksiIsiDomain($opd, $formulir, $domain)
    {
        $role = Auth::user()->role;
        if (!in_array($role, ['opd', 'walidata', 'admin'], true)) {
            abort(403, 'Anda tidak memiliki izin untuk mengakses halaman ini.');
        }

        $opd = $this->resolveUserRouteParam($opd);
        $formulir = $this->resolveFormulirRouteParam($formulir);

        if (!$opd) {
            abort(404, 'OPD tidak ditemukan.');
        }

        if (!$formulir) {
            abort(404, 'Formulir tidak ditemukan.');
        }

        $this->authorizeReviewAccess($role, $opd, $formulir);

        $domain = $this->resolveDomainForFormulir($formulir, $domain);

        if (!$domain) {
            abort(404, 'Domain tidak ditemukan.');
        }

        $formulir->load('domains.aspek.indikator.penilaian');
        $aspectScores = collect($this->calculationService->getAspectComparisons($formulir, $opd))
            ->keyBy('aspek_id')
            ->all();

        return view(
            'dashboard.disposisi.koreksi-detail-isi-domain',
            compact('formulir', 'domain', 'opd', 'aspectScores')
        );
    }


    public function koreksi($opd, $formulir, $domain, $aspek, $indikator)
    {
        $role = Auth::user()->role;
        if (!in_array($role, ['opd', 'walidata', 'admin'], true)) {
            abort(403, 'Anda tidak memiliki izin untuk mengakses halaman ini.');
        }

        $opd = $this->resolveUserRouteParam($opd);
        $formulir = $this->resolveFormulirRouteParam($formulir);

        if (!$opd) {
            abort(404, 'OPD tidak ditemukan.');
        }

        if (!$formulir) {
            abort(404, 'Formulir tidak ditemukan.');
        }

        $this->authorizeReviewAccess($role, $opd, $formulir);

        $domain = $this->resolveDomainForFormulir($formulir, $domain);

        $aspek = $this->resolveAspekRouteParam($domain, $aspek);

        if (!$aspek) {
            abort(404, 'Aspek tidak ditemukan.');
        }

        $indikator = $this->resolveIndikatorRouteParam($aspek, $indikator);

        if (!$indikator) {
            abort(404, 'Indikator tidak ditemukan.');
        }

        $nilai_diinput = $this->penilaianSelectionService->resolveForIndicator($indikator, $formulir, $opd->id, 'nilai');
        $nilai_dikoreksi = $this->penilaianSelectionService->resolveForIndicator($indikator, $formulir, $opd->id, 'nilai_diupdate');
        $nilai_dievaluasi = $this->penilaianSelectionService->resolveForIndicator($indikator, $formulir, $opd->id, 'nilai_koreksi');

        return view('dashboard.disposisi.koreksi-penilaian', compact(
            'opd',
            'formulir',
            'domain',
            'aspek',
            'indikator',
            'nilai_diinput',
            'nilai_dikoreksi',
            'nilai_dievaluasi'
        ));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function storeKoreksi(Request $request)
    {
        $validated = $request->validate([
            'penilaian_id' => 'required|exists:penilaians,id',
            'nilai' => 'required|numeric|min:0|max:5',
            'catatan_koreksi' => 'nullable|string',
        ]);

        $penilaian = Penilaian::findOrFail($validated['penilaian_id']);
        $pengoreksi = Auth::user()->id;
        $pengoreksiUser = User::find($pengoreksi);

        // Validasi: Pastikan evaluasi belum terisi
        if ($penilaian->evaluasi) {
            \Log::warning('Attempt to update existing evaluation', [
                'penilaian_id' => $penilaian->id,
                'existing_evaluasi' => $penilaian->evaluasi
            ]);
            return redirect()->back()->with('error', 'Evaluasi sudah terisi dan tidak dapat diubah');
        }

        // Pastikan hanya Walidata yang bisa update
        if ($pengoreksiUser->role !== 'walidata') {
            \Log::warning('Unauthorized update attempt', [
                'user_id' => $pengoreksi,
                'user_role' => $pengoreksiUser->role
            ]);
            return redirect()->back()->with('error', 'Anda tidak memiliki izin untuk melakukan koreksi');
        }

        // Walidata tidak perlu upload bukti dukung, bukti dukung tetap milik OPD
        $penilaian->update([
            'nilai_diupdate' => $validated['nilai'],
            'catatan_koreksi' => $validated['catatan_koreksi'] ?? null, // Penjelasan koreksi walidata
            'diupdate_by' => $pengoreksi,
            'tanggal_diperbarui' => now(),
            // bukti_dukung tidak diupdate, tetap gunakan bukti dukung dari OPD
        ]);

        return redirect()->back()->with('success', 'Berhasil mengoreksi penilaian');
    }



    public function updateEvaluasi(Request $request)
    {
        $validated = $request->validate([
            'penilaian_id' => 'required|exists:penilaians,id',
            'nilai_evaluasi' => 'required|numeric|min:0|max:5',
            'evaluasi' => 'nullable|string',
        ]);

        $penilaian = Penilaian::findOrFail($validated['penilaian_id']);
        $pengoreksi = Auth::user()->id;

        // Pastikan hanya Admin yang bisa menyimpan evaluasi
        if (Auth::user()->role !== 'admin') {
            return redirect()->back()->with('error', 'Anda tidak memiliki izin untuk melakukan evaluasi');
        }

        // Pastikan Walidata sudah mengisi nilai_diupdate sebelum admin bisa menilai
        if ($penilaian->nilai_diupdate === null) {
            return redirect()->back()->with('error', 'Walidata belum mengisi penilaian. Anda tidak dapat melakukan evaluasi.');
        }

        // Admin tidak perlu upload bukti dukung, bukti dukung tetap milik OPD
        $penilaian->update([
            'nilai_koreksi' => $validated['nilai_evaluasi'],
            'dikoreksi_by' => $pengoreksi,
            'evaluasi' => $validated['evaluasi'] ?? null,
            'tanggal_dikoreksi' => now(),
            // bukti_dukung tidak diupdate, tetap gunakan bukti dukung dari OPD
        ]);

        return redirect()->back()->with('success', 'Berhasil melakukan evaluasi penilaian');
    }


    public function show(FormulirPenilaianDisposisi $formulirPenilaianDisposisi)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(FormulirPenilaianDisposisi $formulirPenilaianDisposisi)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, FormulirPenilaianDisposisi $formulirPenilaianDisposisi)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(FormulirPenilaianDisposisi $formulirPenilaianDisposisi)
    {
        //
    }

    /**
     * Get perbandingan hasil akhir untuk OPD yang sedang login
     */
    private function getPerbandinganHasilForOPD($formulir, $user)
    {
        $scores = $this->calculationService->calculateFormulirScores($formulir, $user);
        $stats = $this->calculationService->getStats($formulir, $user);

        return [
            'nama' => $formulir->nama_formulir,
            'tanggal' => $formulir->tanggal_dibuat,
            'total_indikator' => $stats['total_indikator'],
            'opd_result' => [
                'user_id' => $user->id,
                'user_name' => $user->name,
                'nilai' => $scores['opd'],
                'terisi' => $stats['opd_progress']['count'],
            ],
            'walidata_result' => [
                'user_id' => $user->id,
                'user_name' => $user->name,
                'nilai' => $scores['walidata'],
                'terkoreksi' => $stats['walidata_progress']['count'],
            ],
            'bps_result' => [
                'user_id' => $user->id,
                'user_name' => $user->name,
                'nilai' => $scores['admin'],
                'terevaluasi' => $stats['admin_progress']['count'],
            ],
        ];
    }

    /**
     * Get perbandingan hasil akhir untuk semua OPD (untuk Walidata dan Admin)
     */
    private function getPerbandinganHasilForAllOPD($formulir)
    {
        $results = [];

        foreach ($this->calculationService->getOpdComparisonSummary($formulir) as $summary) {
            $results[] = [
                'user_id' => $summary['opd_id'],
                'user_name' => $summary['nama_opd'],
                'opd_result' => [
                    'nilai' => $summary['skor_mandiri'],
                ],
                'walidata_result' => [
                    'nilai' => $summary['skor_walidata'],
                ],
                'bps_result' => [
                    'nilai' => $summary['skor_bps'],
                ],
            ];
        }

        return [
            'nama' => $formulir->nama_formulir,
            'tanggal' => $formulir->tanggal_dibuat,
            'results' => $results,
        ];
    }
    private function normalizeRouteParam(string $value): string
    {
        $decoded = rawurldecode($value);
        $trimmed = preg_replace('/\s+/u', ' ', trim($decoded)) ?? trim($decoded);

        return mb_strtolower($trimmed);
    }

    private function resolveUserRouteParam(string $value): ?User
    {
        if (is_numeric($value)) {
            $user = User::find((int) $value);
            if ($user) {
                return $user;
            }
        }

        $normalized = $this->normalizeRouteParam($value);

        return User::query()
            ->whereRaw('LOWER(TRIM(name)) = ?', [$normalized])
            ->first();
    }

    private function resolveFormulirRouteParam(string $value): ?Formulir
    {
        if (is_numeric($value)) {
            $formulir = Formulir::find((int) $value);
            if ($formulir) {
                return $formulir;
            }
        }

        $normalized = $this->normalizeRouteParam($value);

        return Formulir::query()
            ->whereRaw('LOWER(TRIM(nama_formulir)) = ?', [$normalized])
            ->first();
    }

    private function resolveDomainRouteParam(string $value): ?Domain
    {
        if (is_numeric($value)) {
            $domain = Domain::find((int) $value);
            if ($domain) {
                return $domain;
            }
        }

        $normalized = $this->normalizeRouteParam($value);

        return Domain::query()
            ->whereRaw('LOWER(TRIM(nama_domain)) = ?', [$normalized])
            ->first();
    }

    private function resolveDomainForFormulir(Formulir $formulir, string $value): ?Domain
    {
        if (is_numeric($value)) {
            return $formulir->domains()->whereKey((int) $value)->first();
        }

        $normalized = $this->normalizeRouteParam($value);

        return $formulir->domains()
            ->whereRaw('LOWER(TRIM(nama_domain)) = ?', [$normalized])
            ->first();
    }

    private function resolveAspekRouteParam(Domain $domain, string $value): ?Aspek
    {
        if (is_numeric($value)) {
            $aspek = $domain->aspek()->whereKey((int) $value)->first();
            if ($aspek) {
                return $aspek;
            }
        }

        $normalized = $this->normalizeRouteParam($value);

        return $domain->aspek()
            ->whereRaw('LOWER(TRIM(nama_aspek)) = ?', [$normalized])
            ->first();
    }

    private function resolveIndikatorRouteParam(Aspek $aspek, string $value): ?Indikator
    {
        if (is_numeric($value)) {
            $indikator = $aspek->indikator()->whereKey((int) $value)->first();
            if ($indikator) {
                return $indikator;
            }
        }

        $normalized = $this->normalizeRouteParam($value);

        return $aspek->indikator()
            ->whereRaw('LOWER(TRIM(nama_indikator)) = ?', [$normalized])
            ->first();
    }

    private function authorizeReviewAccess(string $role, User $opd, Formulir $formulir): void
    {
        if (in_array($role, ['walidata', 'admin'], true)) {
            return;
        }

        if (Auth::id() !== $opd->id) {
            abort(403, 'Anda tidak dapat membuka data OPD lain.');
        }

        $hasPenilaian = $formulir->penilaians()
            ->where('user_id', $opd->id)
            ->exists();
        $isCreator = (int) $formulir->created_by_id === (int) $opd->id;

        if (!$hasPenilaian && !$isCreator) {
            abort(403, 'Anda tidak memiliki akses ke formulir ini.');
        }
    }
}
