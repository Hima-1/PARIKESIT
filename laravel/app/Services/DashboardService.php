<?php

namespace App\Services;

use App\Models\Formulir;
use App\Models\User;
use App\Support\InputSanitizer;
use Illuminate\Http\Request;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\Auth;

class DashboardService
{
    private PenilaianSelectionService $penilaianSelectionService;

    private AssessmentCalculationService $calculationService;

    public function __construct(
        ?PenilaianSelectionService $penilaianSelectionService = null,
        ?AssessmentCalculationService $calculationService = null,
    ) {
        $this->penilaianSelectionService = $penilaianSelectionService ?? new PenilaianSelectionService;
        $this->calculationService = $calculationService ?? new AssessmentCalculationService($this->penilaianSelectionService);
    }

    /**
     * Get aggregate statistics for dashboard
     */
    public function getStats()
    {
        $allFormulirs = Formulir::operational()
            ->with(['domains.aspek.indikator.penilaian.user'])
            ->get();
        $adminProgress = $this->getAdminProgress();

        $evaluationScores = collect($adminProgress)
            ->pluck('nilai_evaluasi_akhir')
            ->filter(fn ($value) => $value !== null)
            ->map(fn ($value) => (float) $value)
            ->values();

        $progressDistribution = [
            'belum_mulai' => 0,
            'berjalan' => 0,
            'selesai' => 0,
        ];

        foreach ($allFormulirs as $formulir) {
            $opdStats = $this->getStatistikOPD($formulir);
            $filled = (int) ($opdStats['terisi'] ?? 0);
            $total = (int) ($opdStats['total_indikator'] ?? 0);

            if ($filled === 0) {
                $progressDistribution['belum_mulai']++;
            } elseif ($total > 0 && $filled >= $total) {
                $progressDistribution['selesai']++;
            } else {
                $progressDistribution['berjalan']++;
            }
        }

        return [
            'jumlahKegiatanPenilaian' => $allFormulirs->count(),
            'jumlahPenilaianSelesai' => $progressDistribution['selesai'],
            'jumlahPenilaianProgres' => $progressDistribution['berjalan'],
            'userTerdaftar' => User::count(),
            'average_score' => $evaluationScores->isEmpty()
                ? 0
                : round($evaluationScores->avg(), 2),
            'progress_distribution' => $progressDistribution,
            'progress_assessments' => $adminProgress,
        ];
    }

    /**
     * Get progress data based on user role
     */
    public function getProgressData($user = null)
    {
        $user = $user ?: Auth::user();

        if (! $user) {
            return [];
        }

        return match ($user->role) {
            'opd' => $this->getOPDProgress($user),
            'walidata' => $this->getWalidataProgress(),
            'admin' => $this->getAdminProgress(),
            default => [],
        };
    }

    public function getAssessmentProgressPage(Request $request, $user = null): array
    {
        $user = $user ?: Auth::user();

        if ($user && $user->role === 'admin') {
            return $this->getAdminAssessmentProgressPage($request);
        }

        $progressData = collect($this->getProgressData($user));

        $search = InputSanitizer::plainText($request->get('search', ''), 100);
        if ($search !== '') {
            $searchLower = mb_strtolower($search);
            $progressData = $progressData->filter(function (array $item) use ($searchLower) {
                return str_contains(
                    mb_strtolower((string) ($item['nama'] ?? '')),
                    $searchLower,
                );
            })->values();
        }

        $sortBy = InputSanitizer::sortBy($request->get('sort_by'), ['nama', 'progress_opd', 'progress_walidata', 'tanggal'], 'tanggal');
        $sortDirection = InputSanitizer::sortDirection($request->get('sort_direction'));

        $sortResolver = match ($sortBy) {
            'nama' => fn (array $item) => mb_strtolower((string) ($item['nama'] ?? '')),
            'progress_opd' => fn (array $item) => (int) ($item['opd_filled_count'] ?? 0),
            'progress_walidata' => fn (array $item) => (int) ($item['walidata_corrected_count'] ?? 0),
            'tanggal' => fn (array $item) => (string) ($item['tanggal'] ?? ''),
            default => fn (array $item) => (string) ($item['tanggal'] ?? ''),
        };

        $sorted = $progressData->sortBy($sortResolver, SORT_NATURAL, $sortDirection === 'desc')->values();

        $perPage = InputSanitizer::safeIntRange($request->get('per_page'), 10, 1, 50);
        $page = InputSanitizer::safeIntRange($request->get('page'), 1, 1, PHP_INT_MAX);
        $total = $sorted->count();

        $items = $sorted->forPage($page, $perPage)->values();
        $paginator = new LengthAwarePaginator(
            $items,
            $total,
            $perPage,
            $page,
        );

        return [
            'data' => $items->all(),
            'meta' => [
                'current_page' => $paginator->currentPage(),
                'last_page' => $paginator->lastPage(),
                'per_page' => $paginator->perPage(),
                'total' => $paginator->total(),
            ],
        ];
    }

    /**
     * Get progress data for OPD
     */
    public function getOPDProgress($user)
    {
        $formulirs = Formulir::whereHas('penilaians', function ($query) use ($user) {
            $query->where('user_id', $user->id);
        })
            ->operational()
            ->with(['domains.aspek.indikator.penilaian' => function ($query) use ($user) {
                $query->where('user_id', $user->id);
            }])
            ->latest()
            ->get();

        $progressData = [];

        foreach ($formulirs as $formulir) {
            $dashboardProgress = $this->calculationService->getLoadedDashboardProgress($formulir, $user);
            $scores = $this->calculationService->calculateLoadedFormulirScores($formulir, $user);

            $progressData[] = [
                'id' => $formulir->id,
                'nama' => $formulir->nama_formulir,
                'tanggal' => $formulir->tanggal_dibuat,
                'progress_per_indikator' => $dashboardProgress['progress_per_indikator'],
                'hasil_penilaian_akhir' => $scores['opd'],
                'progress_koreksi_walidata' => $dashboardProgress['progress_koreksi_walidata'],
                'progress_evaluasi_admin' => $dashboardProgress['progress_evaluasi_admin'],
            ];
        }

        return $progressData;
    }

    /**
     * Get progress data for Walidata
     */
    public function getWalidataProgress()
    {
        $formulirs = Formulir::operational()
            ->with(['domains.aspek.indikator.penilaian.user'])
            ->latest()
            ->get();
        $progressData = [];

        foreach ($formulirs as $formulir) {
            $progressData[] = [
                'id' => $formulir->id,
                'nama' => $formulir->nama_formulir,
                'tanggal' => $formulir->tanggal_dibuat,
                'nilai_koreksi_akhir' => $this->calculateRataRataDomainKoreksi($formulir),
                'indikator_belum_dikoreksi' => $this->getIndikatorBelumDikoreksi($formulir),
                'statistik_walidata' => $this->getStatistikWalidata($formulir),
            ];
        }

        return $progressData;
    }

    /**
     * Get progress data for Admin
     */
    public function getAdminProgress()
    {
        $formulirs = Formulir::operational()
            ->with(['domains.aspek.indikator.penilaian.user'])
            ->latest()
            ->get();

        return $formulirs
            ->map(fn (Formulir $formulir) => $this->buildAdminProgressItem($formulir))
            ->all();
    }

    private function getAdminAssessmentProgressPage(Request $request): array
    {
        $search = InputSanitizer::plainText($request->get('search', ''), 100);
        $sortBy = InputSanitizer::sortBy($request->get('sort_by'), ['nama', 'progress_opd', 'progress_walidata', 'tanggal'], 'tanggal');
        $sortDirection = InputSanitizer::sortDirection($request->get('sort_direction'));
        $perPage = InputSanitizer::safeIntRange($request->get('per_page'), 10, 1, 50);

        $query = $this->adminProgressSummaryQuery();

        if ($search !== '') {
            $query->where('nama_formulir', 'like', "%{$search}%");
        }

        $sortColumn = match ($sortBy) {
            'nama' => 'nama_formulir',
            'progress_opd' => 'opd_filled_count',
            'progress_walidata' => 'walidata_corrected_count',
            default => 'tanggal_dibuat',
        };

        $paginator = $query
            ->orderBy($sortColumn, $sortDirection)
            ->orderBy('id', $sortDirection)
            ->paginate($perPage);

        $loadedFormulirs = Formulir::query()
            ->whereKey($paginator->getCollection()->pluck('id'))
            ->with(['domains.aspek.indikator.penilaian.user'])
            ->get()
            ->keyBy('id');

        $items = $paginator->getCollection()
            ->map(function (Formulir $summary) use ($loadedFormulirs) {
                $formulir = $loadedFormulirs->get($summary->id, $summary);

                foreach (['total_indicators', 'opd_filled_count', 'walidata_corrected_count'] as $attribute) {
                    $formulir->setAttribute($attribute, (int) $summary->getAttribute($attribute));
                }

                return $this->buildAdminProgressItem($formulir);
            })
            ->values();

        return [
            'data' => $items->all(),
            'meta' => [
                'current_page' => $paginator->currentPage(),
                'last_page' => $paginator->lastPage(),
                'per_page' => $paginator->perPage(),
                'total' => $paginator->total(),
            ],
        ];
    }

    private function adminProgressSummaryQuery()
    {
        return Formulir::query()
            ->operational()
            ->select('formulirs.*')
            ->selectSub(function ($query) {
                $query->from('formulir_domains')
                    ->join('domains', 'domains.id', '=', 'formulir_domains.domain_id')
                    ->join('aspeks', 'aspeks.domain_id', '=', 'domains.id')
                    ->join('indikators', 'indikators.aspek_id', '=', 'aspeks.id')
                    ->whereColumn('formulir_domains.formulir_id', 'formulirs.id')
                    ->whereNull('formulir_domains.deleted_at')
                    ->whereNull('domains.deleted_at')
                    ->whereNull('aspeks.deleted_at')
                    ->whereNull('indikators.deleted_at')
                    ->selectRaw('COUNT(DISTINCT indikators.id)');
            }, 'total_indicators')
            ->selectSub(function ($query) {
                $query->from('penilaians')
                    ->join('users', 'users.id', '=', 'penilaians.user_id')
                    ->whereColumn('penilaians.formulir_id', 'formulirs.id')
                    ->where('users.role', 'opd')
                    ->whereNull('users.deleted_at')
                    ->whereNotNull('penilaians.nilai')
                    ->selectRaw('COUNT(DISTINCT penilaians.indikator_id)');
            }, 'opd_filled_count')
            ->selectSub(function ($query) {
                $query->from('penilaians')
                    ->whereColumn('penilaians.formulir_id', 'formulirs.id')
                    ->whereNotNull('penilaians.nilai_diupdate')
                    ->selectRaw('COUNT(DISTINCT penilaians.indikator_id)');
            }, 'walidata_corrected_count');
    }

    private function buildAdminProgressItem(Formulir $formulir): array
    {
        $statistikOpd = $this->getStatistikOPD($formulir);
        $statistikWalidata = $this->getStatistikWalidata($formulir);

        $totalIndicators = $formulir->getAttribute('total_indicators');
        if ($totalIndicators !== null) {
            $statistikOpd = $this->statistikPayload((int) $totalIndicators, (int) $formulir->getAttribute('opd_filled_count'));
            $statistikWalidata = $this->statistikPayload((int) $totalIndicators, (int) $formulir->getAttribute('walidata_corrected_count'), 'terkoreksi');
        }

        return [
            'id' => $formulir->id,
            'nama' => $formulir->nama_formulir,
            'tanggal' => $formulir->tanggal_dibuat,
            'nilai_evaluasi_akhir' => $this->calculateRataRataDomainEvaluasi($formulir),
            'indikator_belum_dievaluasi' => $this->getIndikatorBelumDievaluasi($formulir),
            'statistik_opd' => $statistikOpd,
            'statistik_walidata' => $statistikWalidata,
            'opd_filled_count' => $statistikOpd['terisi'],
            'opd_total_count' => $statistikOpd['total_indikator'],
            'walidata_corrected_count' => $statistikWalidata['terkoreksi'],
            'walidata_total_count' => $statistikWalidata['total_indikator'],
        ];
    }

    private function statistikPayload(int $total, int $count, string $countKey = 'terisi'): array
    {
        return [
            'total_indikator' => $total,
            $countKey => $count,
            'persentase' => $total > 0 ? round(($count / $total) * 100, 2) : 0,
        ];
    }

    // --- Private Calculation Helpers (Mirrored from Controller) ---

    private function calculateRataRataDomainKoreksi($formulir)
    {
        return $this->calculationService->calculateLoadedAggregateScores($formulir)['walidata'];
    }

    private function calculateRataRataDomainEvaluasi($formulir)
    {
        return $this->calculationService->calculateLoadedAggregateScores($formulir)['admin'];
    }

    private function getIndikatorBelumDikoreksi($formulir)
    {
        return $formulir->domains->flatMap(function ($domain) use ($formulir) {
            return $domain->aspek->flatMap(function ($aspek) use ($domain, $formulir) {
                return $aspek->indikator->map(function ($indikator) use ($domain, $aspek, $formulir) {
                    $penilaian = $this->penilaianSelectionService->resolveFromCollection(
                        $indikator->penilaian,
                        $formulir->id,
                        null,
                        'nilai_diupdate',
                    );
                    if ($penilaian && $penilaian->nilai !== null && $penilaian->nilai_diupdate === null) {
                        return [
                            'id' => $indikator->id,
                            'nama' => $indikator->nama_indikator,
                            'domain' => $domain->nama_domain,
                            'aspek' => $aspek->nama_aspek,
                            'user_id' => $penilaian->user_id,
                            'user_name' => $penilaian->user->name ?? 'N/A',
                        ];
                    }

                    return null;
                })->filter();
            });
        })->values()->all();
    }

    private function getIndikatorBelumDievaluasi($formulir)
    {
        return $formulir->domains->flatMap(function ($domain) use ($formulir) {
            return $domain->aspek->flatMap(function ($aspek) use ($domain, $formulir) {
                return $aspek->indikator->map(function ($indikator) use ($domain, $aspek, $formulir) {
                    $penilaian = $this->penilaianSelectionService->resolveFromCollection(
                        $indikator->penilaian,
                        $formulir->id,
                        null,
                        'evaluasi',
                    );
                    if ($penilaian && $penilaian->nilai_koreksi !== null && ($penilaian->evaluasi === null || $penilaian->evaluasi === '')) {
                        return [
                            'id' => $indikator->id,
                            'nama' => $indikator->nama_indikator,
                            'domain' => $domain->nama_domain,
                            'aspek' => $aspek->nama_aspek,
                            'user_id' => $penilaian->user_id,
                            'user_name' => $penilaian->user->name ?? 'N/A',
                            'nilai_koreksi' => $penilaian->nilai_koreksi,
                            'catatan_koreksi' => $penilaian->catatan_koreksi,
                        ];
                    }

                    return null;
                })->filter();
            });
        })->values()->all();
    }

    private function getStatistikOPD($formulir)
    {
        $indikators = $formulir->domains->flatMap->aspek->flatMap->indikator;
        $totalIndikator = $indikators->count();

        $terisi = $indikators->filter(function ($indikator) use ($formulir) {
            return $indikator->penilaian
                ->where('formulir_id', $formulir->id)
                ->whereNotNull('nilai')
                ->filter(fn ($p) => $p->user && $p->user->role === 'opd')
                ->isNotEmpty();
        })->count();

        return [
            'total_indikator' => $totalIndikator,
            'terisi' => $terisi,
            'persentase' => $totalIndikator > 0 ? round(($terisi / $totalIndikator) * 100, 2) : 0,
        ];
    }

    private function getStatistikWalidata($formulir)
    {
        $indikators = $formulir->domains->flatMap->aspek->flatMap->indikator;
        $totalIndikator = $indikators->count();

        $terkoreksi = $indikators->filter(function ($indikator) use ($formulir) {
            return $this->penilaianSelectionService->resolveFilledFromCollection(
                $indikator->penilaian,
                $formulir->id,
                null,
                'nilai_diupdate',
            ) !== null;
        })->count();

        return [
            'total_indikator' => $totalIndikator,
            'terkoreksi' => $terkoreksi,
            'persentase' => $totalIndikator > 0 ? round(($terkoreksi / $totalIndikator) * 100, 2) : 0,
        ];
    }
}
