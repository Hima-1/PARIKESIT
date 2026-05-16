<?php

namespace App\Services;

use App\Models\Aspek;
use App\Models\Domain;
use App\Models\Formulir;
use App\Models\Indikator;
use App\Models\Penilaian;
use App\Models\User;
use Illuminate\Support\Collection;

class AssessmentCalculationService
{
    private const LAYERS = ['opd', 'walidata', 'admin'];

    private PenilaianSelectionService $penilaianSelectionService;

    public function __construct(?PenilaianSelectionService $penilaianSelectionService = null)
    {
        $this->penilaianSelectionService = $penilaianSelectionService ?? new PenilaianSelectionService;
    }

    /**
     * Calculate score for a specific layer (opd, walidata, or admin)
     */
    public function calculateScore(Formulir $formulir, User $user, string $layer = 'opd'): ?float
    {
        $scores = $this->calculateFormulirScores($formulir, $user);

        return $scores[$layer] ?? null;
    }

    /**
     * Calculate the weighted score for a specific aspect.
     *
     * The aspect score uses the same indicator weighting formula as the domain score.
     */
    public function calculateAspectScore(Formulir $formulir, Aspek $aspek, User $user, string $layer = 'opd'): ?float
    {
        $snapshot = $this->calculateLayerSnapshotFromIndicators(
            $aspek->indikator,
            $formulir,
            $user->id,
        );

        return $snapshot[$layer] ?? null;
    }

    /**
     * Calculate the weighted score for a specific domain.
     */
    public function calculateDomainScore(Formulir $formulir, Domain $domain, User $user, string $layer = 'opd'): ?float
    {
        $snapshot = $this->calculateLayerSnapshotFromIndicators(
            $domain->aspek->flatMap(fn (Aspek $aspek) => $aspek->indikator),
            $formulir,
            $user->id,
        );

        return $snapshot[$layer] ?? null;
    }

    /**
     * Return the three role scores for a specific aspect.
     *
     * @return array{opd:?float,walidata:?float,admin:?float}
     */
    public function getAspectScores(Formulir $formulir, Aspek $aspek, User $user): array
    {
        return $this->calculateLayerSnapshotFromIndicators(
            $aspek->indikator,
            $formulir,
            $user->id,
        );
    }

    /**
     * Return the three role scores for a specific domain.
     *
     * @return array{opd:?float,walidata:?float,admin:?float}
     */
    public function getDomainScores(Formulir $formulir, Domain $domain, User $user): array
    {
        return $this->calculateLayerSnapshotFromIndicators(
            $domain->aspek->flatMap(fn (Aspek $aspek) => $aspek->indikator),
            $formulir,
            $user->id,
        );
    }

    /**
     * Return the three role scores for an entire formulir.
     *
     * @return array{opd:?float,walidata:?float,admin:?float}
     */
    public function calculateFormulirScores(Formulir $formulir, User $user): array
    {
        $this->loadAssessmentTree($formulir, $user);

        return $this->calculateFormulirScoresFromLoadedTree($formulir, $user);
    }

    /**
     * Calculate the three role scores for several users without reloading the tree per user.
     *
     * @param  Collection<int, User>  $users
     * @return array<int, array{opd:?float,walidata:?float,admin:?float}>
     */
    public function calculateScoresForUsers(Formulir $formulir, Collection $users): array
    {
        if ($users->isEmpty()) {
            return [];
        }

        $this->loadAssessmentTreeForUsers($formulir, $users);

        return $users
            ->mapWithKeys(fn (User $user) => [
                $user->id => $this->calculateFormulirScoresFromLoadedTree($formulir, $user),
            ])
            ->all();
    }

    private function calculateFormulirScoresFromLoadedTree(Formulir $formulir, User $user): array
    {
        return $this->calculateFormulirScoresFromLoadedTreeForUserId($formulir, $user->id);
    }

    /**
     * Calculate the three role scores from an already loaded assessment tree.
     *
     * @return array{opd:?float,walidata:?float,admin:?float}
     */
    public function calculateLoadedFormulirScores(Formulir $formulir, User $user): array
    {
        return $this->calculateFormulirScoresFromLoadedTree($formulir, $user);
    }

    /**
     * Calculate aggregate role scores from an already loaded tree without narrowing to one OPD.
     *
     * @return array{opd:?float,walidata:?float,admin:?float}
     */
    public function calculateLoadedAggregateScores(Formulir $formulir): array
    {
        return $this->calculateFormulirScoresFromLoadedTreeForUserId($formulir, null);
    }

    /**
     * @return array{opd:?float,walidata:?float,admin:?float}
     */
    private function calculateFormulirScoresFromLoadedTreeForUserId(Formulir $formulir, ?int $userId): array
    {

        $domainSnapshots = [];
        foreach ($formulir->domains as $domain) {
            $domainSnapshots[$domain->id] = [
                'scores' => $this->calculateLayerSnapshotFromIndicators(
                    $domain->aspek->flatMap(fn (Aspek $aspek) => $aspek->indikator),
                    $formulir,
                    $userId,
                ),
                'weight' => (float) ($domain->bobot_domain ?? 1),
            ];
        }

        return $this->collapseDomainSnapshots($domainSnapshots);
    }

    /**
     * Decorate a formulir tree with score snapshots for the supplied user.
     */
    public function applyAssessmentScores(Formulir $formulir, User $user): Formulir
    {
        $this->loadAssessmentTree($formulir, $user);

        $formulir->setAttribute('scores', $this->calculateFormulirScores($formulir, $user));

        foreach ($formulir->domains as $domain) {
            $domain->setAttribute('scores', $this->getDomainScores($formulir, $domain, $user));

            foreach ($domain->aspek as $aspek) {
                $aspek->setAttribute('scores', $this->getAspectScores($formulir, $aspek, $user));

                foreach ($aspek->indikator as $indikator) {
                    $indikator->setAttribute(
                        'scores',
                        $this->indicatorToScores($indikator, $formulir, $user),
                    );
                }
            }
        }

        return $formulir;
    }

    /**
     * Get comparative summary per aspect for a specific user and formulir.
     *
     * @return array<int, array<string, mixed>>
     */
    public function getAspectComparisons(Formulir $formulir, User $user): array
    {
        $this->loadAssessmentTree($formulir, $user);

        return $formulir->domains->flatMap(function (Domain $domain) use ($formulir, $user) {
            return $domain->aspek->map(function (Aspek $aspek) use ($formulir, $user, $domain) {
                return [
                    'domain_id' => $domain->id,
                    'aspek_id' => $aspek->id,
                    'nama_domain' => $domain->nama_domain,
                    'nama_aspek' => $aspek->nama_aspek,
                    'opd_score' => $this->calculateAspectScore($formulir, $aspek, $user, 'opd'),
                    'walidata_score' => $this->calculateAspectScore($formulir, $aspek, $user, 'walidata'),
                    'admin_score' => $this->calculateAspectScore($formulir, $aspek, $user, 'admin'),
                ];
            });
        })->values()->all();
    }

    /**
     * Get statistics for a specific user and formulir
     */
    public function getStats(Formulir $formulir, User $user): array
    {
        $formulir->load(['domains.aspek.indikator.penilaian' => function ($query) use ($user, $formulir) {
            $query->where('user_id', $user->id)->where('formulir_id', $formulir->id);
        }]);

        return $this->getStatsFromLoadedTree($formulir, $user);
    }

    /**
     * @param  Collection<int, User>  $users
     * @return array<int, array<string, mixed>>
     */
    public function getStatsForUsers(Formulir $formulir, Collection $users): array
    {
        if ($users->isEmpty()) {
            return [];
        }

        $this->loadAssessmentTreeForUsers($formulir, $users);

        return $users
            ->mapWithKeys(fn (User $user) => [
                $user->id => $this->getStatsFromLoadedTree($formulir, $user),
            ])
            ->all();
    }

    private function getStatsFromLoadedTree(Formulir $formulir, User $user): array
    {
        return $this->getStatsFromLoadedTreeForUserId($formulir, $user->id);
    }

    /**
     * Return stats from an already loaded tree.
     *
     * @return array<string, mixed>
     */
    public function getLoadedStats(Formulir $formulir, User $user): array
    {
        return $this->getStatsFromLoadedTree($formulir, $user);
    }

    /**
     * Return dashboard progress payloads from an already loaded tree.
     *
     * @return array{
     *   progress_per_indikator: array{total:int,terisi:int,persentase:float},
     *   progress_koreksi_walidata: array{total:int,sudah_dikoreksi:int,persentase:float},
     *   progress_evaluasi_admin: array{total:int,sudah_dievaluasi:int,persentase:float}
     * }
     */
    public function getLoadedDashboardProgress(Formulir $formulir, User $user): array
    {
        $stats = $this->getStatsFromLoadedTree($formulir, $user);
        $totalIndicators = (int) $stats['total_indikator'];
        $opdFilled = (int) $stats['opd_progress']['count'];
        $walidataCorrected = (int) $stats['walidata_progress']['count'];
        $adminEvaluated = (int) $stats['admin_progress']['count'];

        return [
            'progress_per_indikator' => [
                'total' => $totalIndicators,
                'terisi' => $opdFilled,
                'persentase' => $totalIndicators > 0 ? round(($opdFilled / $totalIndicators) * 100, 2) : 0,
            ],
            'progress_koreksi_walidata' => [
                'total' => $opdFilled,
                'sudah_dikoreksi' => $walidataCorrected,
                'persentase' => $opdFilled > 0 ? round(($walidataCorrected / $opdFilled) * 100, 2) : 0,
            ],
            'progress_evaluasi_admin' => [
                'total' => $walidataCorrected,
                'sudah_dievaluasi' => $adminEvaluated,
                'persentase' => $walidataCorrected > 0 ? round(($adminEvaluated / $walidataCorrected) * 100, 2) : 0,
            ],
        ];
    }

    /**
     * @return array<string, mixed>
     */
    private function getStatsFromLoadedTreeForUserId(Formulir $formulir, ?int $userId): array
    {

        $totalIndikator = 0;
        $terisiOPD = 0;
        $terkoreksiWalidata = 0;
        $terevaluasiAdmin = 0;

        foreach ($formulir->domains as $domain) {
            foreach ($domain->aspek as $aspek) {
                foreach ($aspek->indikator as $indikator) {
                    $totalIndikator++;

                    if ($this->getIndicatorLayerValue($indikator, $formulir, $userId, 'opd') !== null) {
                        $terisiOPD++;
                    }

                    if ($this->getIndicatorLayerValue($indikator, $formulir, $userId, 'walidata') !== null) {
                        $terkoreksiWalidata++;
                    }

                    if ($this->getIndicatorLayerValue($indikator, $formulir, $userId, 'admin') !== null) {
                        $terevaluasiAdmin++;
                    }
                }
            }
        }

        return [
            'total_indikator' => $totalIndikator,
            'opd_progress' => [
                'count' => $terisiOPD,
                'percentage' => $totalIndikator > 0 ? round(($terisiOPD / $totalIndikator) * 100, 2) : 0,
            ],
            'walidata_progress' => [
                'count' => $terkoreksiWalidata,
                'percentage' => $totalIndikator > 0 ? round(($terkoreksiWalidata / $totalIndikator) * 100, 2) : 0,
            ],
            'admin_progress' => [
                'count' => $terevaluasiAdmin,
                'percentage' => $totalIndikator > 0 ? round(($terevaluasiAdmin / $totalIndikator) * 100, 2) : 0,
            ],
        ];
    }

    /**
     * Get comparative summary per domain for a specific user and formulir.
     *
     * @return array<int, array<string, mixed>>
     */
    public function getDomainComparisons(Formulir $formulir, User $user): array
    {
        $this->loadAssessmentTree($formulir, $user);

        return $formulir->domains->map(function (Domain $domain) use ($formulir, $user) {
            return [
                'domain_id' => $domain->id,
                'nama_domain' => $domain->nama_domain,
                'opd_score' => $this->calculateDomainScore($formulir, $domain, $user, 'opd'),
                'walidata_score' => $this->calculateDomainScore($formulir, $domain, $user, 'walidata'),
                'admin_score' => $this->calculateDomainScore($formulir, $domain, $user, 'admin'),
            ];
        })->values()->all();
    }

    /**
     * Get comparative summary per OPD for a specific formulir.
     *
     * @return array<int, array<string, mixed>>
     */
    public function getOpdComparisonSummary(Formulir $formulir): array
    {
        $opds = User::where('role', 'opd')
            ->whereHas('penilaians', function ($query) use ($formulir) {
                $query->where('formulir_id', $formulir->id);
            })
            ->orderBy('name')
            ->get();

        $scoresByUser = $this->calculateScoresForUsers($formulir, $opds);

        return $opds->map(function (User $user) use ($scoresByUser) {
            $scores = $scoresByUser[$user->id] ?? [];

            return [
                'opd_id' => $user->id,
                'nama_opd' => $user->name,
                'skor_mandiri' => ($scores['opd'] ?? null) ?? 0.0,
                'skor_walidata' => ($scores['walidata'] ?? null) ?? 0.0,
                'skor_bps' => ($scores['admin'] ?? null) ?? 0.0,
            ];
        })->values()->all();
    }

    private function loadAssessmentTree(Formulir $formulir, User $user): void
    {
        $formulir->load([
            'domains.aspek.indikator.penilaian' => function ($query) use ($user, $formulir) {
                $query->where('user_id', $user->id)->where('formulir_id', $formulir->id);
            },
        ]);
    }

    /**
     * @param  Collection<int, User>  $users
     */
    private function loadAssessmentTreeForUsers(Formulir $formulir, Collection $users): void
    {
        $userIds = $users->pluck('id')->all();

        $formulir->load([
            'domains.aspek.indikator.penilaian' => function ($query) use ($userIds, $formulir) {
                $query->whereIn('user_id', $userIds)
                    ->where('formulir_id', $formulir->id);
            },
        ]);
    }

    /**
     * @param  iterable<Indikator>  $indikators
     * @return array{opd:?float,walidata:?float,admin:?float}
     */
    private function calculateLayerSnapshotFromIndicators(iterable $indikators, Formulir $formulir, ?int $userId): array
    {
        $layers = [
            'opd' => ['weighted' => 0.0, 'weight' => 0.0],
            'walidata' => ['weighted' => 0.0, 'weight' => 0.0],
            'admin' => ['weighted' => 0.0, 'weight' => 0.0],
        ];

        foreach ($indikators as $indikator) {
            $weight = (float) ($indikator->bobot_indikator ?? 1);

            foreach (self::LAYERS as $layer) {
                $value = $this->getIndicatorLayerValue($indikator, $formulir, $userId, $layer);
                if ($value === null) {
                    continue;
                }

                $layers[$layer]['weighted'] += $value * $weight;
                $layers[$layer]['weight'] += $weight;
            }
        }

        return [
            'opd' => $this->finalizeLayerSnapshot($layers['opd']),
            'walidata' => $this->finalizeLayerSnapshot($layers['walidata']),
            'admin' => $this->finalizeLayerSnapshot($layers['admin']),
        ];
    }

    /**
     * @param  array{weighted:float,weight:float}  $layer
     */
    private function finalizeLayerSnapshot(array $layer): ?float
    {
        if ($layer['weight'] <= 0) {
            return null;
        }

        return round($layer['weighted'] / $layer['weight'], 2);
    }

    /**
     * @param  array<int, array{scores: array{opd:?float,walidata:?float,admin:?float}, weight: float}>  $domainSnapshots
     * @return array{opd:?float,walidata:?float,admin:?float}
     */
    private function collapseDomainSnapshots(array $domainSnapshots): array
    {
        $layers = [
            'opd' => ['weighted' => 0.0, 'weight' => 0.0],
            'walidata' => ['weighted' => 0.0, 'weight' => 0.0],
            'admin' => ['weighted' => 0.0, 'weight' => 0.0],
        ];

        foreach ($domainSnapshots as $domainSnapshot) {
            foreach (self::LAYERS as $layer) {
                $value = $domainSnapshot['scores'][$layer] ?? null;
                if ($value === null) {
                    continue;
                }

                $layers[$layer]['weighted'] += $value * $domainSnapshot['weight'];
                $layers[$layer]['weight'] += $domainSnapshot['weight'];
            }
        }

        return [
            'opd' => $this->finalizeLayerSnapshot($layers['opd']),
            'walidata' => $this->finalizeLayerSnapshot($layers['walidata']),
            'admin' => $this->finalizeLayerSnapshot($layers['admin']),
        ];
    }

    private function resolvePenilaianForLayer(
        Indikator $indikator,
        Formulir $formulir,
        ?int $userId,
        string $layer,
    ): ?Penilaian {
        $field = $this->getPrimaryFieldForLayer($layer);

        $penilaian = $this->penilaianSelectionService->resolveForIndicator(
            $indikator,
            $formulir,
            $userId,
            $field,
        );

        if ($layer === 'admin' && $this->getValueFromPenilaian($penilaian, $layer) === null) {
            return $this->penilaianSelectionService->resolveForIndicator(
                $indikator,
                $formulir,
                $userId,
                'evaluasi',
            );
        }

        return $penilaian;
    }

    private function indicatorToScores(Indikator $indikator, Formulir $formulir, User $user): ?array
    {
        $scores = [
            'opd' => $this->getIndicatorLayerValue($indikator, $formulir, $user->id, 'opd'),
            'walidata' => $this->getIndicatorLayerValue($indikator, $formulir, $user->id, 'walidata'),
            'admin' => $this->getIndicatorLayerValue($indikator, $formulir, $user->id, 'admin'),
        ];

        if (
            $scores['opd'] === null &&
            $scores['walidata'] === null &&
            $scores['admin'] === null
        ) {
            return null;
        }

        return $scores;
    }

    private function getIndicatorLayerValue(
        Indikator $indikator,
        Formulir $formulir,
        ?int $userId,
        string $layer,
    ): ?float {
        $penilaian = $this->resolvePenilaianForLayer($indikator, $formulir, $userId, $layer);

        return $this->getValueFromPenilaian($penilaian, $layer);
    }

    private function getPrimaryFieldForLayer(string $layer): string
    {
        return match ($layer) {
            'walidata' => 'nilai_diupdate',
            'admin' => 'nilai_koreksi',
            default => 'nilai',
        };
    }

    private function getValueFromPenilaian(?Penilaian $penilaian, string $layer): ?float
    {
        if (! $penilaian) {
            return null;
        }

        if ($layer === 'admin') {
            return $this->adminScoreValue($penilaian);
        }

        return match ($layer) {
            'opd' => $penilaian->nilai !== null ? (float) $penilaian->nilai : null,
            'walidata' => $penilaian->nilai_diupdate !== null ? (float) $penilaian->nilai_diupdate : null,
            default => $penilaian->nilai !== null ? (float) $penilaian->nilai : null,
        };
    }

    private function adminScoreValue(Penilaian $penilaian): ?float
    {
        if (is_numeric($penilaian->nilai_koreksi)) {
            return (float) $penilaian->nilai_koreksi;
        }

        return is_numeric($penilaian->evaluasi)
            ? (float) $penilaian->evaluasi
            : null;
    }
}
