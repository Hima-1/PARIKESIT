<?php

namespace App\Http\Controllers;

use App\Models\Domain;
use App\Models\Formulir;
use App\Models\FormulirDomain;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class DomainController extends Controller
{
    protected function ensureOpdOwnerAccess(Formulir $formulir): void
    {
        abort_unless(auth()->user()?->role === 'opd', 403);
        abort_unless($formulir->created_by_id === auth()->id(), 403);
    }

    /**
     * Display a listing of the resource.
     */
    public function index(Formulir $formulir)
    {
        //
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create(Formulir $formulir)
    {
        $this->ensureOpdOwnerAccess($formulir);
        return view('dashboard.domain.domain-create',compact('formulir'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Formulir $formulir, Request $request)
    {
        $this->ensureOpdOwnerAccess($formulir);

        $validated = $request->validate([
            'nama_domain' => 'required|string|max:255',
            'nama_aspek' => 'required|array|min:1',
            'nama_aspek.*' => 'required|string|max:255',
        ],[
            'nama_domain.required' => 'Nama domain harus diisi',
            'nama_domain.string' => 'Nama domain harus berupa string',
            'nama_domain.max' => 'Nama domain maksimal 255 karakter',
            'nama_aspek.required' => 'Aspek harus diisi',
            'nama_aspek.array' => 'Aspek harus berupa array',
            'nama_aspek.min' => 'Minimal 1 aspek',
            'nama_aspek.*.required' => 'Aspek harus diisi',
            'nama_aspek.*.string' => 'Aspek harus berupa string',
            'nama_aspek.*.max' => 'Aspek maksimal 255 karakter',
        ]);

        $namaDomain = trim($validated['nama_domain']);

        if ($this->formulirHasDomainNamed($formulir, $namaDomain)) {
            throw ValidationException::withMessages([
                'nama_domain' => 'Domain dengan nama yang sama sudah ada pada formulir ini.',
            ]);
        }

        DB::transaction(function () use ($formulir, $validated, $namaDomain) {
            if ($this->formulirHasDomainNamed($formulir, $namaDomain)) {
                throw ValidationException::withMessages([
                    'nama_domain' => 'Domain dengan nama yang sama sudah ada pada formulir ini.',
                ]);
            }

            $domain = Domain::create([
                'nama_domain' => $namaDomain,
            ]);

            FormulirDomain::create([
                'formulir_id' => $formulir->id,
                'domain_id' => $domain->id,
            ]);

            foreach ($validated['nama_aspek'] as $aspek) {
                $domain->aspek()->create([
                    'domain_id' => $domain->id,
                    'nama_aspek' => trim($aspek),
                ]);
            }
        });


        return redirect()->route('formulir.show', ['formulir' => $formulir->id])
            ->with('success', 'Domain berhasil ditambahkan');

    }

    protected function formulirHasDomainNamed(Formulir $formulir, string $namaDomain): bool
    {
        return FormulirDomain::query()
            ->where('formulir_id', $formulir->id)
            ->whereNull('deleted_at')
            ->whereHas('domain', function ($query) use ($namaDomain) {
                $query->whereNull('deleted_at')
                    ->whereRaw('LOWER(nama_domain) = ?', [mb_strtolower($namaDomain)]);
            })
            ->exists();
    }

    /**
     * Display the specified resource.
     */
    public function show(Formulir $formulir,Domain $domain)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Formulir $formulir,Domain $domain)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Formulir $formulir,Request $request, Domain $domain)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Formulir $formulir,Domain $domain)
    {
        //
    }
}
