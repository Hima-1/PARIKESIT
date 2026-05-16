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

    public function __construct(?PenilaianSelectionService $penilaianSelectionService = null)
    {
        $this->penilaianSelectionService = $penilaianSelectionService ?? new PenilaianSelectionService;
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
            $totalIndikator = 0;
            $indikatorTerisi = 0;

            foreach ($formulir->domains as $domain) {
                foreach ($domain->aspek as $aspek) {
                    foreach ($aspek->indikator as $indikator) {
                        $totalIndikator++;
                        $penilaian = $this->penilaianSelectionService->resolveFilledFromCollection(
                            $indikator->penilaian,
                            $formulir->id,
                            $user->id,
                            'nilai',
                        );

                        if ($penilaian && $penilaian->nilai !== null) {
                            $indikatorTerisi++;
                        }
                    }
                }
            }

            $progressData[] = [
                'id' => $formulir->id,
                'nama' => $formulir->nama_formulir,
                'tanggal' => $formulir->tanggal_dibuat,
                'progress_per_indikator' => [
                    'total' => $totalIndikator,
                    'terisi' => $indikatorTerisi,
                    'persentase' => $totalIndikator > 0 ? round(($indikatorTerisi / $totalIndikator) * 100, 2) : 0,
                ],
                'hasil_penilaian_akhir' => $this->calculateRataRataDomain($formulir, $user, 'nilai'),
                'progress_koreksi_walidata' => $this->calculateProgressKoreksi($formulir, $user),
                'progress_evaluasi_admin' => $this->calculateProgressEvaluasi($formulir, $user),
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
        $progressData = [];

        foreach ($formulirs as $formulir) {
            $statistikOpd = $this->getStatistikOPD($formulir);
            $statistikWalidata = $this->getStatistikWalidata($formulir);
            $progressData[] = [
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

        return $progressData;
    }

    // --- Private Calculation Helpers (Mirrored from Controller) ---

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
                        $field,
                    );
                    if ($penilaian && $penilaian->$field !== null) {
                        $bobot = $indikator->bobot_indikator ?? 1;
                        $domainNilai[] = $penilaian->$field * $bobot;
                        $totalBobot += $bobot;
                    }
                }
            }
            if (count($domainNilai) > 0 && $totalBobot > 0) {
                $domainAverages[] = [
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

    private function calculateRataRataDomainKoreksi($formulir)
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
                        null,
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
                $domainAverages[] = [
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

    private function calculateRataRataDomainEvaluasi($formulir)
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
                        null,
                        'evaluasi',
                    );
                    if ($penilaian && $penilaian->evaluasi !== null) {
                        $nilaiEvaluasi = is_numeric($penilaian->evaluasi) ? (float) $penilaian->evaluasi : null;
                        if ($nilaiEvaluasi !== null) {
                            $bobot = $indikator->bobot_indikator ?? 1;
                            $domainNilai[] = $nilaiEvaluasi * $bobot;
                            $totalBobot += $bobot;
                        }
                    }
                }
            }
            if (count($domainNilai) > 0 && $totalBobot > 0) {
                $domainAverages[] = [
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

    private function calculateProgressKoreksi($formulir, $user)
    {
        $totalIndikator = 0;
        $sudahDikoreksi = 0;

        foreach ($formulir->domains as $domain) {
            foreach ($domain->aspek as $aspek) {
                foreach ($aspek->indikator as $indikator) {
                    $penilaian = $this->penilaianSelectionService->resolveFromCollection(
                        $indikator->penilaian,
                        $formulir->id,
                        null,
                        'nilai_diupdate',
                    );

                    if ($penilaian && $penilaian->nilai !== null) {
                        $totalIndikator++;

                        if ($penilaian->nilai_diupdate !== null) {
                            $sudahDikoreksi++;
                        }
                    }
                }
            }
        }

        return [
            'total' => $totalIndikator,
            'sudah_dikoreksi' => $sudahDikoreksi,
            'persentase' => $totalIndikator > 0 ? round(($sudahDikoreksi / $totalIndikator) * 100, 2) : 0,
        ];
    }

    private function calculateProgressEvaluasi($formulir, $user)
    {
        $totalIndikator = 0;
        $sudahDievaluasi = 0;

        foreach ($formulir->domains as $domain) {
            foreach ($domain->aspek as $aspek) {
                foreach ($aspek->indikator as $indikator) {
                    $penilaian = $this->penilaianSelectionService->resolveFromCollection(
                        $indikator->penilaian,
                        $formulir->id,
                        null,
                        'evaluasi',
                    );

                    if ($penilaian && $penilaian->nilai_koreksi !== null) {
                        $totalIndikator++;

                        if ($penilaian->evaluasi !== null && $penilaian->evaluasi !== '') {
                            $sudahDievaluasi++;
                        }
                    }
                }
            }
        }

        return [
            'total' => $totalIndikator,
            'sudah_dievaluasi' => $sudahDievaluasi,
            'persentase' => $totalIndikator > 0 ? round(($sudahDievaluasi / $totalIndikator) * 100, 2) : 0,
        ];
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
