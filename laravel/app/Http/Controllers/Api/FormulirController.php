<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreFormulirDomainRequest;
use App\Http\Requests\StoreFormulirRequest;
use App\Http\Requests\UpdateFormulirRequest;
use App\Http\Resources\FormulirResource;
use App\Http\Resources\FormulirSummaryResource;
use App\Models\Formulir;
use App\Services\AssessmentCalculationService;
use App\Services\FormulirService;
use App\Services\FormulirSetupService;
use App\Support\InputSanitizer;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class FormulirController extends Controller
{
    use ApiResponse;

    protected $setupService;

    protected $formulirService;

    protected $calculationService;

    public function __construct(
        FormulirSetupService $setupService,
        FormulirService $formulirService,
        AssessmentCalculationService $calculationService
    ) {
        $this->setupService = $setupService;
        $this->formulirService = $formulirService;
        $this->calculationService = $calculationService;
    }

    private function prepareFormulirResponse(Formulir $formulir): Formulir
    {
        $user = Auth::user();

        $formulir->load(['domains.aspek.indikator.penilaian', 'creator']);

        if ($user && $user->role === 'opd') {
            return $this->calculationService->applyAssessmentScores($formulir, $user);
        }

        return $formulir;
    }

    private function abortIfTemplate(Formulir $formulir): void
    {
        if (! $formulir->isOperational()) {
            abort(404);
        }
    }

    public function index(Request $request)
    {
        $user = Auth::user();

        $sortBy = InputSanitizer::sortBy($request->get('sort'), ['created_at', 'nama_formulir'], 'created_at');
        $sortDirection = InputSanitizer::sortDirection($request->get('direction'));
        $perPage = InputSanitizer::safeIntRange($request->get('per_page'), 15, 1, 50);
        $search = InputSanitizer::safeSearch($request->get('search'));

        $query = Formulir::operational()->with(['creator']);

        if ($user->role === 'opd') {
            $query->where('created_by_id', $user->id);
        } elseif ($user->role !== 'admin') {
            $query->where('created_by_id', $user->id);
        }

        if ($search !== '') {
            $query->where('nama_formulir', 'like', "%{$search}%");
        }

        $formulirs = $query->orderBy($sortBy, $sortDirection)->paginate($perPage);

        return FormulirSummaryResource::collection($formulirs);
    }

    public function store(StoreFormulirRequest $request)
    {
        $formulir = $this->formulirService->createFormulir($request->validated());

        return $this->successResponse(
            new FormulirResource($this->prepareFormulirResponse($formulir)),
            'Formulir berhasil dibuat',
            201
        );
    }

    public function update(UpdateFormulirRequest $request, Formulir $formulir)
    {
        $this->abortIfTemplate($formulir);

        if (Auth::user()->role !== 'opd' || $formulir->created_by_id !== Auth::id()) {
            return $this->errorResponse('Unauthorized', 403);
        }

        $updatedFormulir = $this->formulirService->updateFormulir(
            $formulir,
            $request->validated()
        );

        return $this->successResponse(
            new FormulirResource($this->prepareFormulirResponse($updatedFormulir)),
            'Formulir berhasil diperbarui'
        );
    }

    public function show(Formulir $formulir)
    {
        $this->abortIfTemplate($formulir);

        $role = Auth::user()->role;

        if ($role === 'admin' || $role === 'walidata') {
            return $this->successResponse(new FormulirResource($formulir->load(['domains.aspek.indikator.penilaian', 'creator'])));
        }

        if ($role === 'opd' && $formulir->created_by_id === Auth::id()) {
            return $this->successResponse(new FormulirResource($this->prepareFormulirResponse($formulir)));
        }

        if ($formulir->created_by_id !== Auth::id()) {
            return $this->errorResponse('Unauthorized', 403);
        }

        return $this->successResponse(new FormulirResource($formulir->load(['domains.aspek.indikator.penilaian', 'creator'])));
    }

    public function setDefaultChildren(Formulir $formulir)
    {
        $this->abortIfTemplate($formulir);

        if (Auth::user()->role !== 'admin' && $formulir->created_by_id !== Auth::id()) {
            return $this->errorResponse('Unauthorized', 403);
        }

        $this->setupService->setup($formulir);

        return $this->successResponse(
            new FormulirResource($this->prepareFormulirResponse($formulir)),
            'Default children set successfully'
        );
    }

    public function storeDomain(StoreFormulirDomainRequest $request, Formulir $formulir)
    {
        $this->abortIfTemplate($formulir);

        $domain = $this->formulirService->storeDomain($formulir, $request->validated());

        return $this->successResponse(
            [
                'id' => $domain->id,
                'nama_domain' => $domain->nama_domain,
                'aspek' => $domain->aspek->map(fn ($aspek) => [
                    'id' => $aspek->id,
                    'nama_aspek' => $aspek->nama_aspek,
                ])->values(),
            ],
            'Domain berhasil ditambahkan',
            201
        );
    }

    public function destroy(Formulir $formulir)
    {
        $this->abortIfTemplate($formulir);

        if (Auth::user()->role !== 'opd' || $formulir->created_by_id !== Auth::id()) {
            return $this->errorResponse('Unauthorized', 403);
        }

        $this->formulirService->deleteFormulir($formulir);

        return $this->successResponse(null, 'Formulir berhasil dihapus');
    }
}
