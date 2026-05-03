<?php

namespace App\Http\Controllers;

use App\Http\Requests\StorePenilaianRequest;
use App\Models\Aspek;
use App\Models\Domain;
use App\Models\Formulir;
use App\Models\Indikator;
use App\Models\Penilaian;
use App\Services\PenilaianSelectionService;
use App\Services\PenilaianService;
use Illuminate\Database\Eloquent\Collection as EloquentCollection;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class PenilaianController extends Controller
{
    public function __construct(
        private readonly PenilaianSelectionService $penilaianSelectionService,
        private readonly PenilaianService $penilaianService,
    ) {}

    public function index()
    {
        $data['title'] = 'Dashboard';

        // Ambil formulir yang indikatornya semua sudah dinilai, hanya untuk OPD yang sedang login
        // Menampilkan semua formulir yang dibuat (biasanya oleh Admin) agar bisa dinilai oleh OPD
        $data['kegiatanPenilaian'] = Formulir::operational()
            ->with('domains.aspek.indikator.penilaian')
            ->whereDoesntHave('domains.aspek.indikator.penilaian', function ($query) {
                $query->whereNull('nilai');
            })
            ->latest()
            ->get();

        foreach ($data['kegiatanPenilaian'] as $formulir) {
            $totalIndikator = 0;
            $terisi = 0;
            foreach ($formulir->domains as $domain) {
                foreach ($domain->aspek as $aspek) {
                    $totalIndikator += $aspek->indikator->count();
                    foreach ($aspek->indikator as $indikator) {
                        // Filter berdasarkan user & formulir yang sedang di-loop
                        if ($indikator->penilaian->where('user_id', Auth::user()->id)->where('formulir_id', $formulir->id)->isNotEmpty()) {
                            $terisi++;
                        }
                    }
                }
            }

            // Tambahkan data ke instance Formulir
            $formulir->total_indikator = $totalIndikator;
            $formulir->indikator_terisi = $terisi;
            $formulir->persentase = $totalIndikator > 0 ? round(($terisi / $totalIndikator) * 100, 2) : 0;
        }

        // Tambahkan pengecekan untuk kegiatan penilaian kosong
        if ($data['kegiatanPenilaian']->isEmpty()) {
            // Cek apakah ada formulir sama sekali
            $formulirBelumDinilai = Formulir::operational()->exists();

            if (! $formulirBelumDinilai) {
                // Kirim pesan jika tidak ada formulir sama sekali
                return view('dashboard.penilaian.penilaian-index', array_merge($data, [
                    'pesan_info' => 'Silahkan buat kegiatan terlebih dahulu!',
                ]));
            }
        }

        return view('dashboard.penilaian.penilaian-index', $data);
    }

    public function penilaianTersedia(Formulir $formulir)
    {
        // Pastikan yang mengakses adalah pembuat formulir atau admin
        if (Auth::user()->role !== 'admin' && $formulir->created_by_id !== Auth::id()) {
            abort(403, 'Anda tidak memiliki akses ke formulir ini');
        }

        $totalIndikator = 0;
        $terisi = 0;

        // Array untuk menyimpan hasil persentase per domain
        $dataPersentasePerDomain = [];

        $formulir->load('domains.aspek.indikator.penilaian');

        foreach ($formulir->domains as $domain) {

            // Perhitungan Indeks Domain menggunakan Weighted Average
            // Rumus: Indeks Domain_k = (Σ_{i=1}^{I} Bobot Indikator_{ik} × Nilai Indikator_{ik}) / (Σ_{i=1}^{I} Bobot Indikator_{ik})
            // Catatan: Perhitungan langsung dari Indikator ke Domain (skip Aspek)
            $domainNilai = [];
            $totalBobot = 0;

            foreach ($domain->aspek as $aspek) {
                foreach ($aspek->indikator as $indikator) {
                    $totalIndikator++;

                    // Hitung hanya penilaian untuk formulir & user saat ini
                    if (
                        $this->penilaianSelectionService->resolveFilledFromCollection(
                            $indikator->penilaian,
                            $formulir->id,
                            Auth::id(),
                            'nilai',
                        ) !== null
                    ) {
                        $terisi++;
                    }

                    // Ambil penilaian untuk indikator ini
                    $penilaian = $this->penilaianSelectionService->resolveFromCollection(
                        $indikator->penilaian,
                        $formulir->id,
                        Auth::id(),
                        'nilai',
                    );

                    if ($penilaian && $penilaian->nilai !== null) {
                        $bobot = $indikator->bobot_indikator ?? 1;
                        $domainNilai[] = $penilaian->nilai * $bobot;
                        $totalBobot += $bobot;
                    }
                }
            }

            // Hitung rata-rata tertimbang untuk domain
            // Gunakan round() untuk konsistensi dengan DashboardController
            $nilaiDomain = ($totalBobot > 0) ? round(array_sum($domainNilai) / $totalBobot, 2) : 0;

            // Simpan data persentase domain berdasarkan ID domain
            $dataPersentasePerDomain[$domain->id] = [
                'nama' => $domain->nama_domain,
                'persentase_domain' => $nilaiDomain, // Gunakan nilai langsung, bukan number_format
                'jumlah_aspek' => $domain->aspek->count(),
            ];
        }

        $persentase = $totalIndikator > 0 ? round(($terisi / $totalIndikator) * 100, 2) : 0;

        return view('dashboard.penilaian.penilaian', compact(
            'formulir',
            'persentase',
            'totalIndikator',
            'terisi',
            'dataPersentasePerDomain'
        ));
    }

    public function domainPenilaian(Formulir $formulir)
    {
        if (Auth::user()->role !== 'admin' && $formulir->created_by_id !== Auth::id()) {
            abort(403, 'Anda tidak memiliki akses ke formulir ini');
        }

        $formulir->load('domains.aspek.indikator');

        return view('dashboard.penilaian.domain-penilaian', compact('formulir'));
    }

    public function isiDomain(Formulir $formulir, $nama_domain)
    {
        // Pastikan yang mengakses adalah pembuat formulir atau admin
        if (Auth::user()->role !== 'admin' && $formulir->created_by_id !== Auth::id()) {
            abort(403, 'Anda tidak memiliki akses ke formulir ini');
        }

        $formulir->load('domains.aspek.indikator.penilaian');

        $domain = $this->resolveDomainForFormulir($formulir, $nama_domain);

        $this->penilaianSelectionService->annotateDomainIndicators($domain, $formulir, Auth::id(), 'nilai', 'penilaian_aktif');

        return view('dashboard.penilaian.isi-domain-aspek-penilaian', compact(['formulir', 'domain']));
    }

    public function penilaianAspek(Formulir $formulir, $nama_domain, $aspek, $req_indikator)
    {
        if (Auth::user()->role !== 'admin' && $formulir->created_by_id !== Auth::id()) {
            abort(403, 'Anda tidak memiliki akses ke formulir ini');
        }

        $formulir->load('domains.aspek.indikator.penilaian');

        $domain = $this->resolveDomainForFormulir($formulir, $nama_domain);
        $aspek = $this->resolveAspekForDomain($domain, $aspek);
        $indikator = $this->resolveIndikatorForAspek($aspek, $req_indikator);

        $dinilai = $this->penilaianSelectionService->resolveFilledFromCollection(
            $indikator->penilaian,
            $formulir->id,
            Auth::id(),
            'nilai',
        );
        [$prev_indikator, $next_indikator] = $this->resolveAdjacentIndicators($aspek, $indikator);

        return view('dashboard.penilaian.sesi-penilaian', compact('formulir', 'domain', 'aspek', 'indikator', 'dinilai', 'next_indikator', 'prev_indikator'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StorePenilaianRequest $request, Formulir $formulir, $nama_domain, $aspek, $indikator)
    {
        $domain = $this->resolveDomainForFormulir($formulir, $nama_domain);
        $resolvedAspek = $this->resolveAspekForDomain($domain, $aspek);
        $resolvedIndikator = $this->resolveIndikatorForAspek($resolvedAspek, $indikator);

        $existingPenilaian = $this->penilaianSelectionService->resolveForIndicator(
            $resolvedIndikator,
            $formulir,
            Auth::id(),
            'nilai',
        );

        $validated = $request->validated();
        if ($existingPenilaian instanceof Penilaian) {
            $validated['existing_bukti_dukung'] = json_encode($existingPenilaian->normalizedBuktiDukung());
        }

        $this->penilaianService->storePenilaian(
            $formulir,
            $resolvedIndikator,
            $validated,
            $request->file('bukti_dukung'),
        );

        // if ($penilaian) {
        //     FormulirPenilaianDisposisi::create([
        //         'formulir_id' => $formulir->id,
        //         'indikator_id' => $indikator,
        //         'assigned_profile_id' => Auth::user()->id,
        //         'status' => 'sent',
        //         'is_completed' => false,

        //     ]);
        // }

        return redirect()->back()->with('success', 'Penilaian berhasil disimpan');
    }

    public function update(Request $request, Formulir $formulir, $nama_domain, $aspek, $indikator, Penilaian $penilaian)
    {
        if (Auth::user()->role !== 'walidata') {
            return redirect()->back()->with('error', 'Anda tidak memiliki izin untuk melakukan koreksi');
        }

        $validated = $request->validate([
            'nilai_update' => 'required|numeric|min:1|max:5',
            'koreksi' => 'nullable|string',
            'catatan_koreksi' => 'nullable|string',
        ], [
            'nilai_update.required' => 'Tingkat kematangan harus diisi',
            'nilai_update.numeric' => 'Tingkat kematangan harus berupa angka',
            'nilai_update.min' => 'Tingkat kematangan minimal 1',
            'nilai_update.max' => 'Tingkat kematangan maksimal 5',
        ]);

        $formulir->load('domains.aspek.indikator');

        $domain = $this->resolveDomainForFormulir($formulir, $nama_domain);
        $resolvedAspek = $this->resolveAspekForDomain($domain, $aspek);
        $resolvedIndikator = $this->resolveIndikatorForAspek($resolvedAspek, $indikator);

        if ((int) $penilaian->formulir_id !== (int) $formulir->id || (int) $penilaian->indikator_id !== (int) $resolvedIndikator->id) {
            abort(404);
        }

        $penilaian->update([
            'nilai_diupdate' => $validated['nilai_update'],
            'catatan_koreksi' => $validated['catatan_koreksi'] ?? $validated['koreksi'] ?? null,
            'diupdate_by' => Auth::id(),
            'tanggal_diperbarui' => now(),
        ]);

        return redirect()->back()->with('success', 'Berhasil mengoreksi penilaian');
    }

    // public function prev_indikator(Formulir $formulir, $nama_domain, $aspek, $indikator)
    // {
    //     $domain = Domain::where('nama_domain', $nama_domain)->first();
    //     $aspek = Aspek::where('domain_id', $domain->id)->where('nama_aspek', $aspek)->first();
    //     $indikator = Indikator::where('aspek_id', $aspek->id)->where('nama_indikator', $indikator)->first();
    //     return redirect()->route('formulir.penilaianAspek', [$formulir, $domain, $aspek]);
    // }

    private function resolveDomainForFormulir(Formulir $formulir, string $domainName): Domain
    {
        $domain = $formulir->domains
            ->first(fn (Domain $item) => $this->namesMatch($item->nama_domain, $domainName));

        if (! $domain instanceof Domain) {
            abort(404);
        }

        $domain->loadMissing('aspek.indikator.penilaian');

        return $domain;
    }

    private function resolveAspekForDomain(Domain $domain, string $aspekName): Aspek
    {
        $domain->loadMissing('aspek.indikator.penilaian');

        $aspek = $domain->aspek
            ->first(fn (Aspek $item) => $this->namesMatch($item->nama_aspek, $aspekName));

        if (! $aspek instanceof Aspek) {
            abort(404);
        }

        $aspek->loadMissing('indikator.penilaian');

        return $aspek;
    }

    private function resolveIndikatorForAspek(Aspek $aspek, string $indikatorName): Indikator
    {
        $aspek->loadMissing('indikator.penilaian');

        $indikator = $aspek->indikator
            ->first(fn (Indikator $item) => $this->namesMatch($item->nama_indikator, $indikatorName));

        if (! $indikator instanceof Indikator) {
            abort(404);
        }

        $indikator->loadMissing('penilaian');

        return $indikator;
    }

    /**
     * @return array{0: ?Indikator, 1: ?Indikator}
     */
    private function resolveAdjacentIndicators(Aspek $aspek, Indikator $current): array
    {
        /** @var EloquentCollection<int, Indikator> $sortedIndicators */
        $sortedIndicators = $aspek->indikator
            ->sortBy(fn (Indikator $indikator) => $indikator->id)
            ->values();

        $currentIndex = $sortedIndicators->search(
            fn (Indikator $indikator) => (int) $indikator->id === (int) $current->id,
        );

        if (! is_int($currentIndex)) {
            return [null, null];
        }

        /** @var ?Indikator $prev */
        $prev = $sortedIndicators->get($currentIndex - 1);
        /** @var ?Indikator $next */
        $next = $sortedIndicators->get($currentIndex + 1);

        return [$prev, $next];
    }

    private function namesMatch(?string $left, string $right): bool
    {
        return mb_strtolower(trim((string) $left)) === mb_strtolower(trim($right));
    }
}
