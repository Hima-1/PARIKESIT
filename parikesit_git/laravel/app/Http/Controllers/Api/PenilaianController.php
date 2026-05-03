<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StorePenilaianRequest;
use App\Http\Resources\PenilaianIndicatorResource;
use App\Http\Resources\PenilaianResource;
use App\Models\Formulir;
use App\Models\Indikator;
use App\Models\Penilaian;
use App\Models\User;
use App\Services\AssessmentCalculationService;
use App\Services\OpdAssessmentAccessService;
use App\Services\PenilaianService;
use App\Services\PenilaianSelectionService;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class PenilaianController extends Controller
{
    use ApiResponse;

    protected $penilaianService;
    protected $calculationService;

    public function __construct(
        PenilaianService $penilaianService,
        AssessmentCalculationService $calculationService,
        private readonly OpdAssessmentAccessService $opdAssessmentAccessService,
        private readonly PenilaianSelectionService $penilaianSelectionService,
    ) {
        $this->penilaianService = $penilaianService;
        $this->calculationService = $calculationService;
    }

    /**
     * Get indicators for a specific formulir.
     * Response menyertakan metadata formulir sehingga Flutter cukup memanggil
     * satu endpoint ini (tidak perlu request terpisah ke GET /formulir/{id}).
     */
    public function getIndicators(Request $request, Formulir $formulir)
    {
        $authUser = Auth::user();
        $userId = (int) $request->query('user_id', $authUser->id);
        $targetUser = User::findOrFail($userId);

        if (!$this->opdAssessmentAccessService->canAccessOpdAssessmentDetail($authUser, $formulir, $targetUser)) {
            return $this->errorResponse('Unauthorized', 403);
        }

        // Optimize eager loading: load nested relations and strictly constrain assessments by user and formulir
        $formulir->load(['domains.aspek.indikator.penilaian' => function ($query) use ($userId, $formulir) {
            $query->where('user_id', $userId)
                  ->where('formulir_id', $formulir->id);
        }]);

        $this->calculationService->applyAssessmentScores($formulir, $targetUser);

        // Bangun domain tree dengan hanya field yang relevan untuk Flutter
        $domains = $formulir->domains->map(function ($domain) use ($formulir, $targetUser) {
            return [
                'id'         => $domain->id,
                'nama_domain' => $domain->nama_domain,
                'scores'      => $domain->scores ?? null,
                'aspek'      => $domain->aspek->map(function ($aspek) use ($formulir, $targetUser) {
                    return [
                        'id'         => $aspek->id,
                        'nama_aspek' => $aspek->nama_aspek,
                        'scores'     => $aspek->scores ?? null,
                        'indikator'  => $aspek->indikator->map(function ($indikator) use ($formulir, $targetUser) {
                            // Only expose filled assessments to Flutter.
                            $penilaian = $this->penilaianSelectionService->resolveFilledFromCollection(
                                $indikator->penilaian,
                                $formulir->id,
                                $targetUser->id,
                                'nilai',
                            );

                            return [
                                'id'             => $indikator->id,
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
                                'scores'         => $indikator->scores ?? null,
                                'penilaian'      => $penilaian
                                    ? PenilaianIndicatorResource::make($penilaian)->resolve()
                                    : null,
                            ];
                        }),
                    ];
                }),
            ];
        });

        return $this->successResponse([
            'id'            => $formulir->id,
            'nama_formulir' => $formulir->nama_formulir,
            'created_at'    => $formulir->created_at,
            'updated_at'    => $formulir->updated_at,
            'scores'        => $formulir->scores ?? null,
            'domains'       => $domains,
        ]);
    }

    /**
     * Store a assessment (penilaian).
     */
    public function store(StorePenilaianRequest $request, Formulir $formulir, Indikator $indikator)
    {
        // Validate that the indicator belongs to this formulir
        $isValidIndicator = Indikator::where('id', $indikator->id)
            ->whereHas('aspek.domain.formulirs', function ($query) use ($formulir) {
                $query->where('formulir_id', $formulir->id);
            })->exists();

        if (!$isValidIndicator) {
            return $this->errorResponse('Indikator tidak valid untuk formulir ini.', 422);
        }

        $penilaian = $this->penilaianService->storePenilaian(
            $formulir, 
            $indikator, 
            $request->validated(), 
            $request->file('bukti_dukung')
        );

        return $this->successResponse(new PenilaianResource($penilaian), 'Penilaian berhasil disimpan', 201);
    }
}
