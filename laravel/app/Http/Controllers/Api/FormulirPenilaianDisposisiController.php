<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\PublicAssessmentOpdResource;
use App\Http\Resources\PublicCompletedAssessmentResource;
use App\Http\Resources\PublicPenilaianIndicatorResource;
use App\Models\Formulir;
use App\Models\Penilaian;
use App\Models\User;
use App\Services\AssessmentCalculationService;
use App\Services\OpdAssessmentAccessService;
use App\Services\PenilaianSelectionService;
use App\Support\InputSanitizer;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class FormulirPenilaianDisposisiController extends Controller
{
    public function __construct(
        private readonly AssessmentCalculationService $calculationService,
        private readonly OpdAssessmentAccessService $opdAssessmentAccessService,
        private readonly PenilaianSelectionService $penilaianSelectionService,
    ) {}

    private function abortIfTemplate(Formulir $formulir): void
    {
        if (! $formulir->isOperational()) {
            abort(404);
        }
    }

    /**
     * Display a listing of completed assessments available for review.
     */
    public function tersedia(Request $request)
    {
        $user = Auth::user();
        $canAccessFullOverview = $this->opdAssessmentAccessService
            ->canAccessFullDisposisiOverview($user);

        $sortBy = $this->sanitizeSortBy($request->get('sort'));
        $sortDirection = $this->sanitizeSortDirection($request->get('direction'));
        $perPage = $this->resolvePerPage($request->get('per_page'));
        $search = InputSanitizer::safeSearch($request->get('search'));

        $query = Formulir::operational()
            ->with('creator')
            ->withCount([
                'penilaians as participating_opd_count' => function ($penilaianQuery) {
                    $penilaianQuery
                        ->select(DB::raw('count(distinct user_id)'))
                        ->whereHas('user', function ($userQuery) {
                            $userQuery->where('role', 'opd');
                        });
                },
            ]);

        if ($canAccessFullOverview) {
            $query->with(['domains.aspek.indikator.penilaian.user']);
            $this->applyHasOpdParticipantFilter($query);
        } elseif ($user->role === 'opd') {
            $query->where(function ($formulirQuery) use ($user) {
                $formulirQuery
                    ->where('created_by_id', $user->id)
                    ->orWhereHas('penilaians', function ($penilaianQuery) use ($user) {
                        $penilaianQuery->where('user_id', $user->id);
                    });
            });
        } else {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        if ($search !== '') {
            $query->where('nama_formulir', 'like', "%{$search}%");
        }

        $penilaianSelesai = $query->orderBy($sortBy, $sortDirection)->paginate($perPage);

        if ($canAccessFullOverview) {
            $penilaianSelesai->getCollection()->transform(function (Formulir $formulir) {
                $formulir->setAttribute(
                    'review_progress',
                    $this->buildWalidataReviewProgress($formulir),
                );

                return $formulir;
            });
        }

        return response()->json($penilaianSelesai);
    }

    /**
     * Display a public listing of completed assessments.
     */
    public function publicTersedia(Request $request)
    {
        $sortBy = $this->sanitizeSortBy($request->get('sort'));
        $sortDirection = $this->sanitizeSortDirection($request->get('direction'));
        $perPage = $this->resolvePerPage($request->get('per_page'));
        $search = InputSanitizer::safeSearch($request->get('search'));

        $query = Formulir::operational()->withCount('domains');
        $this->applyHasOpdParticipantFilter($query);

        if ($search !== '') {
            $query->where('nama_formulir', 'like', "%{$search}%");
        }

        $penilaianSelesai = $query->orderBy($sortBy, $sortDirection)->paginate($perPage);

        return PublicCompletedAssessmentResource::collection($penilaianSelesai);
    }

    /**
     * Store a correction (koreksi) for an indicator assessment (Walidata role).
     */
    public function storeKoreksi(Request $request)
    {
        $request->merge([
            'catatan_koreksi' => InputSanitizer::nullablePlainText($request->input('catatan_koreksi'), 2000),
        ]);

        $request->validate([
            'penilaian_id' => 'required|exists:penilaians,id',
            'nilai' => 'required|numeric|min:0|max:5',
            'catatan_koreksi' => 'nullable|string|max:2000',
        ]);

        $penilaian = Penilaian::find($request->penilaian_id);

        if (Auth::user()->role !== 'walidata') {
            return response()->json(['message' => 'Hanya Walidata yang dapat melakukan koreksi'], 403);
        }

        if ($penilaian->evaluasi) {
            return response()->json(['message' => 'Evaluasi sudah terisi dan tidak dapat diubah'], 422);
        }

        $penilaian->update([
            'nilai_diupdate' => $request->nilai,
            'catatan_koreksi' => $request->catatan_koreksi,
            'diupdate_by' => Auth::id(),
            'tanggal_diperbarui' => now(),
        ]);

        return response()->json([
            'message' => 'Berhasil mengoreksi penilaian',
            'data' => $penilaian,
        ]);
    }

    /**
     * Store an evaluation for an indicator assessment (Admin role).
     */
    public function updateEvaluasi(Request $request)
    {
        $request->merge([
            'evaluasi' => InputSanitizer::nullablePlainText($request->input('evaluasi'), 2000),
        ]);

        $request->validate([
            'penilaian_id' => 'required|exists:penilaians,id',
            'nilai_evaluasi' => 'required|numeric|min:0|max:5',
            'evaluasi' => 'nullable|string|max:2000',
        ]);

        $penilaian = Penilaian::find($request->penilaian_id);

        if (Auth::user()->role !== 'admin') {
            return response()->json(['message' => 'Hanya Admin yang dapat melakukan evaluasi'], 403);
        }

        if ($penilaian->nilai_diupdate === null) {
            return response()->json(['message' => 'Walidata belum mengisi penilaian. Anda tidak dapat melakukan evaluasi.'], 422);
        }

        $penilaian->update([
            'nilai_koreksi' => $request->nilai_evaluasi,
            'dikoreksi_by' => Auth::id(),
            'evaluasi' => $request->evaluasi,
            'tanggal_dikoreksi' => now(),
        ]);

        return response()->json([
            'message' => 'Berhasil melakukan evaluasi penilaian',
            'data' => $penilaian,
        ]);
    }

    /**
     * Get list of participating OPDs for a specific formulir.
     */
    public function getOpds(Request $request, Formulir $formulir)
    {
        $this->abortIfTemplate($formulir);

        if (! $this->opdAssessmentAccessService->canAccessFullDisposisiOverview(Auth::user())) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $perPage = $this->resolvePerPage($request->get('per_page'));
        $opds = $this->participatingOpdQuery($formulir)
            ->orderBy('name')
            ->paginate($perPage);

        $statsByUser = $this->calculationService->getStatsForUsers(
            $formulir,
            $opds->getCollection(),
        );

        $opds->getCollection()->transform(
            fn (User $user) => $this->buildAuthenticatedOpdPayload(
                $formulir,
                $user,
                $statsByUser[$user->id] ?? null,
            ),
        );

        return response()->json($opds);
    }

    /**
     * Display a public list of OPDs and final scores for a formulir.
     */
    public function publicOpds(Request $request, Formulir $formulir)
    {
        $this->abortIfTemplate($formulir);

        $perPage = $this->resolvePerPage($request->get('per_page'));
        $opds = $this->participatingOpdQuery($formulir)
            ->orderBy('name')
            ->paginate($perPage);

        $scoresByUser = $this->calculationService->calculateScoresForUsers(
            $formulir,
            $opds->getCollection(),
        );

        $opds->getCollection()->transform(
            fn (User $user) => $this->buildPublicOpdScorePayload(
                $formulir,
                $user,
                $scoresByUser[$user->id] ?? null,
            ),
        );

        return PublicAssessmentOpdResource::collection($opds);
    }

    /**
     * Display a public read-only detail payload for one OPD in a formulir.
     */
    public function publicOpdDetail(Formulir $formulir, User $user)
    {
        $this->abortIfTemplate($formulir);

        abort_unless($user->role === 'opd', 404);

        $hasParticipantAssessment = $user->penilaians()
            ->where('formulir_id', $formulir->id)
            ->exists();

        abort_unless($hasParticipantAssessment, 404);

        $formulir->load(['domains.aspek.indikator.penilaian' => function ($query) use ($user, $formulir) {
            $query->where('user_id', $user->id)
                ->where('formulir_id', $formulir->id);
        }]);

        $this->calculationService->applyAssessmentScores($formulir, $user);

        return response()->json([
            'data' => $this->buildPublicOpdDetailPayload($formulir, $user),
        ]);
    }

    /**
     * Get comparative summary for all participating OPDs in a formulir.
     */
    public function getSummary(Formulir $formulir)
    {
        $this->abortIfTemplate($formulir);

        if (! $this->opdAssessmentAccessService->canAccessFullDisposisiOverview(Auth::user())) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        return response()->json(
            $this->calculationService->getOpdComparisonSummary($formulir)
        );
    }

    /**
     * Get comparative statistics for an OPD assessment (for Mobile Charts).
     */
    public function getOpdStats(Formulir $formulir, User $user)
    {
        $this->abortIfTemplate($formulir);

        if (! $this->opdAssessmentAccessService->canAccessOpdAssessmentDetail(Auth::user(), $formulir, $user)) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $opdScore = $this->calculationService->calculateScore($formulir, $user, 'opd');
        $walidataScore = $this->calculationService->calculateScore($formulir, $user, 'walidata');
        $adminScore = $this->calculationService->calculateScore($formulir, $user, 'admin');

        $stats = $this->calculationService->getStats($formulir, $user);

        return response()->json([
            'formulir' => $formulir->nama_formulir,
            'opd' => $user->name,
            'comparison' => [
                'opd_score' => $opdScore,
                'walidata_score' => $walidataScore,
                'admin_score' => $adminScore,
            ],
            'progress' => $stats,
        ]);
    }

    /**
     * Get comparative summary per domain for a specific OPD assessment.
     */
    public function getOpdDomainStats(Formulir $formulir, User $user)
    {
        $this->abortIfTemplate($formulir);

        if (! $this->opdAssessmentAccessService->canAccessOpdAssessmentDetail(Auth::user(), $formulir, $user)) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        return response()->json(
            $this->calculationService->getDomainComparisons($formulir, $user)
        );
    }

    /**
     * @return array{
     *   total_indicators:int,
     *   corrected_count:int,
     *   percentage:float,
     *   final_correction_score:?float,
     *   pending_indicator_preview:array<int, array{
     *     id:int,
     *     nama:string,
     *     domain:string,
     *     aspek:string,
     *     user_id:int,
     *     user_name:string
     *   }>
     * }
     */
    private function buildWalidataReviewProgress(Formulir $formulir): array
    {
        $totalIndicators = 0;
        $correctedCount = 0;
        $pendingIndicatorPreview = [];
        $domainSnapshots = [];

        foreach ($formulir->domains as $domain) {
            $domainWeightedScore = 0.0;
            $domainWeightTotal = 0.0;

            foreach ($domain->aspek as $aspek) {
                foreach ($aspek->indikator as $indikator) {
                    $totalIndicators++;

                    $penilaian = $this->penilaianSelectionService->resolveFromCollection(
                        $indikator->penilaian,
                        $formulir->id,
                        null,
                        'nilai_diupdate',
                    );

                    if (! $penilaian || $penilaian->nilai === null) {
                        continue;
                    }

                    if ($penilaian->nilai_diupdate !== null) {
                        $correctedCount++;
                        $indicatorWeight = (float) ($indikator->bobot_indikator ?? 1);
                        $domainWeightedScore += (float) $penilaian->nilai_diupdate * $indicatorWeight;
                        $domainWeightTotal += $indicatorWeight;

                        continue;
                    }

                    if (count($pendingIndicatorPreview) < 3) {
                        $pendingIndicatorPreview[] = [
                            'id' => (int) $indikator->id,
                            'nama' => (string) $indikator->nama_indikator,
                            'domain' => (string) $domain->nama_domain,
                            'aspek' => (string) $aspek->nama_aspek,
                            'user_id' => (int) $penilaian->user_id,
                            'user_name' => (string) ($penilaian->user->name ?? 'N/A'),
                        ];
                    }
                }
            }

            if ($domainWeightTotal > 0) {
                $domainSnapshots[] = [
                    'score' => round($domainWeightedScore / $domainWeightTotal, 2),
                    'weight' => (float) ($domain->bobot_domain ?? 1),
                ];
            }
        }

        $totalWeightedScore = 0.0;
        $totalDomainWeight = 0.0;

        foreach ($domainSnapshots as $snapshot) {
            $totalWeightedScore += $snapshot['score'] * $snapshot['weight'];
            $totalDomainWeight += $snapshot['weight'];
        }

        return [
            'total_indicators' => $totalIndicators,
            'corrected_count' => $correctedCount,
            'percentage' => $totalIndicators > 0
                ? round(($correctedCount / $totalIndicators) * 100, 2)
                : 0,
            'final_correction_score' => $totalDomainWeight > 0
                ? round($totalWeightedScore / $totalDomainWeight, 2)
                : null,
            'pending_indicator_preview' => $pendingIndicatorPreview,
        ];
    }

    private function sanitizeSortBy(?string $sortBy): string
    {
        return InputSanitizer::sortBy($sortBy, ['created_at', 'nama_formulir'], 'created_at');
    }

    private function sanitizeSortDirection(?string $direction): string
    {
        return InputSanitizer::sortDirection($direction);
    }

    private function resolvePerPage(mixed $perPage): int
    {
        return InputSanitizer::safeIntRange($perPage, 10, 1, 50);
    }

    private function applyHasOpdParticipantFilter(Builder $query): void
    {
        $query->whereHas('penilaians.user', function ($penilaianQuery) {
            $penilaianQuery->where('role', 'opd');
        });
    }

    /**
     * @return Builder<User>
     */
    private function participatingOpdQuery(Formulir $formulir): Builder
    {
        return User::query()
            ->where('role', 'opd')
            ->whereHas('penilaians', function ($query) use ($formulir) {
                $query->where('formulir_id', $formulir->id);
            });
    }

    /**
     * @return array{
     *   id:int,
     *   name:string,
     *   role:string,
     *   nomor_telepon:?string,
     *   stats:array<string,mixed>
     * }
     */
    private function buildAuthenticatedOpdPayload(Formulir $formulir, User $user, ?array $stats = null): array
    {
        return [
            'id' => $user->id,
            'name' => $user->name,
            'role' => $user->role,
            'nomor_telepon' => $user->nomor_telepon,
            'stats' => $stats ?? $this->calculationService->getStats($formulir, $user),
        ];
    }

    /**
     * @return array{
     *   id:int,
     *   name:string,
     *   email:?string,
     *   opd_score:?float,
     *   walidata_score:?float,
     *   admin_score:?float
     * }>
     */
    private function buildPublicOpdScorePayload(Formulir $formulir, User $user, ?array $scores = null): array
    {
        $scores ??= $this->calculationService->calculateFormulirScores($formulir, $user);

        return [
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'opd_score' => $scores['opd'] ?? null,
            'walidata_score' => $scores['walidata'] ?? null,
            'admin_score' => $scores['admin'] ?? null,
        ];
    }

    /**
     * @return array<string, mixed>
     */
    private function buildPublicOpdDetailPayload(Formulir $formulir, User $user): array
    {
        return [
            'id' => $formulir->id,
            'nama_formulir' => $formulir->nama_formulir,
            'created_at' => $formulir->created_at,
            'updated_at' => $formulir->updated_at,
            'opd_id' => $user->id,
            'opd_name' => $user->name,
            'scores' => $formulir->getAttribute('scores'),
            'domains' => $formulir->domains->map(function ($domain) use ($formulir, $user) {
                return [
                    'id' => $domain->id,
                    'nama_domain' => $domain->nama_domain,
                    'updated_at' => $domain->updated_at,
                    'scores' => $domain->getAttribute('scores'),
                    'aspek' => $domain->aspek->map(function ($aspek) use ($formulir, $user) {
                        return [
                            'id' => $aspek->id,
                            'nama_aspek' => $aspek->nama_aspek,
                            'scores' => $aspek->getAttribute('scores'),
                            'indikator' => $aspek->indikator->map(function ($indikator) use ($formulir, $user) {
                                $penilaian = $this->penilaianSelectionService->resolveFilledFromCollection(
                                    $indikator->penilaian,
                                    $formulir->id,
                                    $user->id,
                                    'nilai',
                                );

                                return [
                                    'id' => $indikator->id,
                                    'kode_indikator' => $indikator->kode_indikator,
                                    'nama_indikator' => $indikator->nama_indikator,
                                    'bobot_indikator' => $indikator->bobot_indikator,
                                    'level_1_kriteria' => $indikator->level_1_kriteria,
                                    'level_2_kriteria' => $indikator->level_2_kriteria,
                                    'level_3_kriteria' => $indikator->level_3_kriteria,
                                    'level_4_kriteria' => $indikator->level_4_kriteria,
                                    'level_5_kriteria' => $indikator->level_5_kriteria,
                                    'level_1_kriteria_10101' => $indikator->level_1_kriteria_10101,
                                    'level_2_kriteria_10101' => $indikator->level_2_kriteria_10101,
                                    'level_3_kriteria_10101' => $indikator->level_3_kriteria_10101,
                                    'level_4_kriteria_10101' => $indikator->level_4_kriteria_10101,
                                    'level_5_kriteria_10101' => $indikator->level_5_kriteria_10101,
                                    'level_1_kriteria_10201' => $indikator->level_1_kriteria_10201,
                                    'level_2_kriteria_10201' => $indikator->level_2_kriteria_10201,
                                    'level_3_kriteria_10201' => $indikator->level_3_kriteria_10201,
                                    'level_4_kriteria_10201' => $indikator->level_4_kriteria_10201,
                                    'level_5_kriteria_10201' => $indikator->level_5_kriteria_10201,
                                    'scores' => $indikator->getAttribute('scores'),
                                    'penilaian' => $penilaian
                                        ? PublicPenilaianIndicatorResource::make($penilaian)->resolve()
                                        : null,
                                ];
                            })->values(),
                        ];
                    })->values(),
                ];
            })->values(),
        ];
    }
}
