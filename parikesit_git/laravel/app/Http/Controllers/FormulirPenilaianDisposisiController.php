<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Aspek;
use App\Models\Domain;
use App\Models\Formulir;
use App\Models\Indikator;
use App\Models\Penilaian;
use App\Services\AssessmentCalculationService;
use App\Services\PenilaianSelectionService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use App\Models\FormulirPenilaianDisposisi;

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
                ->get();
        }
        // Jika role adalah OPD, tampilkan hanya formulir yang dibuat atau dinilai oleh OPD tersebut
        else if ($user->role === 'opd') {
            $penilaianSelesai = Formulir::operational()->with('creator')->whereHas('penilaians', function ($query) use ($user) {
                $query->where('user_id', $user->id)
                      ->orWhere('created_by_id', $user->id);
            })->get();

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
                })->get()->map(function ($opd) use ($formulir) {
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
                })->get()->map(function ($opd) use ($formulir) {
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

        // Debug logging
        Log::info('Koreksi Isi Domain Debug', [
            'opd_name' => $opd->name,
            'opd_id' => $opd->id,
            'formulir_name' => $formulir->nama_formulir,
            'formulir_id' => $formulir->id,
            'domain_name' => $domain->nama_domain,
            'domain_id' => $domain->id
        ]);

        // Debug logging tambahan untuk penilaian Walidata
        Log::info('Penilaian Walidata Debug', [
            'opd_name' => $opd->name,
            'opd_id' => $opd->id,
            'formulir_name' => $formulir->nama_formulir,
            'formulir_id' => $formulir->id,
            'domain_name' => $domain->nama_domain,
            'domain_id' => $domain->id,
            'penilaian_walidata' => Penilaian::where('user_id', $opd->id)
                ->where('formulir_id', $formulir->id)
                ->whereHas('user', function($query) {
                    $query->where('role', 'walidata');
                })
                ->get()->toArray()
        ]);

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

        // Tambahkan logging untuk detail penilaian
        Log::info('Koreksi Penilaian Detail', [
            'opd_name' => $opd->name,
            'formulir_name' => $formulir->nama_formulir,
            'domain_name' => $domain->nama_domain,
            'aspek_name' => $aspek->nama_aspek,
            'indikator_name' => $indikator->nama_indikator,
            'nilai_diinput' => $nilai_diinput ? $nilai_diinput->toArray() : null,
            'nilai_dikoreksi' => $nilai_dikoreksi ? $nilai_dikoreksi->toArray() : null,
            'nilai_dievaluasi' => $nilai_dievaluasi ? $nilai_dievaluasi->toArray() : null,
            'current_user_role' => Auth::user()->role
        ]);

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

        \Log::error('Store Koreksi Request', [
            'all_data' => $request->all(),
            'user_role' => Auth::user()->role,
            'user_id' => Auth::id()
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

        // Debug logging yang lebih komprehensif
        \Log::error('Store Koreksi Debug - Detailed', [
            'request_data' => $request->all(),
            'penilaian_id' => $request->penilaian_id,
            'penilaian_details' => $penilaian ? $penilaian->toArray() : null,
            'pengoreksi_id' => $pengoreksi,
            'pengoreksi_role' => $pengoreksiUser->role,
            'pengoreksi_name' => $pengoreksiUser->name,
            'request_nilai' => $validated['nilai'],
            'current_user_role' => Auth::user()->role
        ]);

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

        // Log hasil update
        \Log::info('Store Koreksi Update Result', [
            'penilaian_id' => $penilaian->id,
            'updated_penilaian' => $penilaian->fresh()->toArray()
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
        // Hitung nilai dari OPD (penilaian mandiri)
        $nilaiOPD = $this->calculateRataRataDomain($formulir, $user, 'nilai');
        
        // Hitung nilai dari Walidata (koreksi)
        $nilaiWalidata = $this->calculateRataRataDomainKoreksiPerUser($formulir, $user);
        
        // Hitung nilai dari Admin (evaluasi)
        $nilaiBPS = $this->calculateRataRataDomainEvaluasiPerUser($formulir, $user);

        // Hitung statistik indikator untuk status
        $totalIndikator = 0;
        $terisiOPD = 0;
        $terkoreksiWalidata = 0;
        $terevaluasiAdmin = 0;

        foreach ($formulir->domains as $domain) {
            foreach ($domain->aspek as $aspek) {
                foreach ($aspek->indikator as $indikator) {
                    $totalIndikator++;
                    $penilaian = $this->penilaianSelectionService->resolveFromCollection(
                        $indikator->penilaian,
                        $formulir->id,
                        $user->id,
                        'nilai',
                    );
                    
                    if ($penilaian && $penilaian->nilai !== null) {
                        $terisiOPD++;
                    }
                    if ($penilaian && $penilaian->nilai_diupdate !== null) {
                        $terkoreksiWalidata++;
                    }
                    if ($penilaian && $penilaian->evaluasi !== null) {
                        $terevaluasiAdmin++;
                    }
                }
            }
        }

        return [
            'nama' => $formulir->nama_formulir,
            'tanggal' => $formulir->tanggal_dibuat,
            'total_indikator' => $totalIndikator,
            'opd_result' => [
                'user_id' => $user->id,
                'user_name' => $user->name,
                'nilai' => $nilaiOPD,
                'terisi' => $terisiOPD,
            ],
            'walidata_result' => [
                'user_id' => $user->id,
                'user_name' => $user->name,
                'nilai' => $nilaiWalidata,
                'terkoreksi' => $terkoreksiWalidata,
            ],
            'bps_result' => [
                'user_id' => $user->id,
                'user_name' => $user->name,
                'nilai' => $nilaiBPS,
                'terevaluasi' => $terevaluasiAdmin,
            ],
        ];
    }

    /**
     * Get perbandingan hasil akhir untuk semua OPD (untuk Walidata dan Admin)
     */
    private function getPerbandinganHasilForAllOPD($formulir)
    {
        // Ambil semua user OPD yang memiliki penilaian di formulir ini
        $opdUsers = User::where('role', 'opd')
            ->whereHas('penilaians', function($query) use ($formulir) {
                $query->where('formulir_id', $formulir->id);
            })
            ->get();

        $results = [];

        foreach ($opdUsers as $opdUser) {
            // Hitung nilai dari OPD (penilaian mandiri)
            $nilaiOPD = $this->calculateRataRataDomain($formulir, $opdUser, 'nilai');
            
            // Hitung nilai dari Walidata (koreksi)
            $nilaiWalidata = $this->calculateRataRataDomainKoreksiPerUser($formulir, $opdUser);
            
            // Hitung nilai dari Admin (evaluasi)
            $nilaiBPS = $this->calculateRataRataDomainEvaluasiPerUser($formulir, $opdUser);

            $results[] = [
                'user_id' => $opdUser->id,
                'user_name' => $opdUser->name,
                'opd_result' => [
                    'nilai' => $nilaiOPD,
                ],
                'walidata_result' => [
                    'nilai' => $nilaiWalidata,
                ],
                'bps_result' => [
                    'nilai' => $nilaiBPS,
                ],
            ];
        }

        return [
            'nama' => $formulir->nama_formulir,
            'tanggal' => $formulir->tanggal_dibuat,
            'results' => $results,
        ];
    }

    /**
     * Calculate average value from domains (for OPD initial assessment)
     */
    private function calculateRataRataDomain($formulir, $user, $field = 'nilai')
    {
        $domainAverages = [];
        
        foreach ($formulir->domains as $domain) {
            $domainNilai = [];
            $totalBobot = 0;

            foreach ($domain->aspek as $aspek) {
                foreach ($aspek->indikator as $indikator) {
                    $penilaian = $this->penilaianSelectionService->resolveFromCollection(
                        $indikator->penilaian,
                        $formulir->id,
                        $user->id,
                        'nilai',
                    );
                    
                    if ($penilaian && $penilaian->$field !== null) {
                        $bobot = $indikator->bobot_indikator ?? 1;
                        $domainNilai[] = $penilaian->$field * $bobot;
                        $totalBobot += $bobot;
                    }
                }
            }

            if (count($domainNilai) > 0 && $totalBobot > 0) {
                $domainAverages[$domain->nama_domain] = [
                    'nilai' => round(array_sum($domainNilai) / $totalBobot, 2),
                    'bobot' => $domain->bobot_domain ?? 1,
                ];
            }
        }

        // Hitung Indeks Pembangunan Statistik (rata-rata tertimbang domain)
        $totalNilai = 0;
        $totalBobot = 0;
        foreach ($domainAverages as $domain) {
            $totalNilai += $domain['nilai'] * $domain['bobot'];
            $totalBobot += $domain['bobot'];
        }

        return $totalBobot > 0 ? round($totalNilai / $totalBobot, 2) : null;
    }

    /**
     * Calculate average correction value per user (for comparison)
     */
    private function calculateRataRataDomainKoreksiPerUser($formulir, $user)
    {
        $domainAverages = [];
        
        foreach ($formulir->domains as $domain) {
            $domainNilai = [];
            $totalBobot = 0;

            foreach ($domain->aspek as $aspek) {
                foreach ($aspek->indikator as $indikator) {
                    $penilaian = $this->penilaianSelectionService->resolveFromCollection(
                        $indikator->penilaian,
                        $formulir->id,
                        $user->id,
                        'nilai_diupdate',
                    );
                    
                    if ($penilaian && $penilaian->nilai_diupdate !== null) {
                        $bobot = $indikator->bobot_indikator ?? 1;
                        $domainNilai[] = $penilaian->nilai_diupdate * $bobot;
                        $totalBobot += $bobot;
                    }
                }
            }

            if (count($domainNilai) > 0 && $totalBobot > 0) {
                $domainAverages[$domain->nama_domain] = [
                    'nilai' => round(array_sum($domainNilai) / $totalBobot, 2),
                    'bobot' => $domain->bobot_domain ?? 1,
                ];
            }
        }

        $totalNilai = 0;
        $totalBobot = 0;
        foreach ($domainAverages as $domain) {
            $totalNilai += $domain['nilai'] * $domain['bobot'];
            $totalBobot += $domain['bobot'];
        }

        return $totalBobot > 0 ? round($totalNilai / $totalBobot, 2) : null;
    }

    /**
     * Calculate average evaluation value per user (for comparison)
     */
    private function calculateRataRataDomainEvaluasiPerUser($formulir, $user)
    {
        $domainAverages = [];
        
        foreach ($formulir->domains as $domain) {
            $domainNilai = [];
            $totalBobot = 0;

            foreach ($domain->aspek as $aspek) {
                foreach ($aspek->indikator as $indikator) {
                    $penilaian = $this->penilaianSelectionService->resolveFromCollection(
                        $indikator->penilaian,
                        $formulir->id,
                        $user->id,
                        'evaluasi',
                    );
                    
                    if ($penilaian && $penilaian->evaluasi !== null) {
                        $nilaiEvaluasi = is_numeric($penilaian->evaluasi) ? (float)$penilaian->evaluasi : null;
                        
                        if ($nilaiEvaluasi !== null) {
                            $bobot = $indikator->bobot_indikator ?? 1;
                            $domainNilai[] = $nilaiEvaluasi * $bobot;
                            $totalBobot += $bobot;
                        }
                    }
                }
            }

            if (count($domainNilai) > 0 && $totalBobot > 0) {
                $domainAverages[$domain->nama_domain] = [
                    'nilai' => round(array_sum($domainNilai) / $totalBobot, 2),
                    'bobot' => $domain->bobot_domain ?? 1,
                ];
            }
        }

        $totalNilai = 0;
        $totalBobot = 0;
        foreach ($domainAverages as $domain) {
            $totalNilai += $domain['nilai'] * $domain['bobot'];
            $totalBobot += $domain['bobot'];
        }

        return $totalBobot > 0 ? round($totalNilai / $totalBobot, 2) : null;
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
