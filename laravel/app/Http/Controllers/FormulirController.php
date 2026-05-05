<?php

namespace App\Http\Controllers;

use App\Models\Formulir;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Services\FormulirSetupService;
use App\Services\FormulirService;

class FormulirController extends Controller
{
    protected $setupService;
    protected $formulirService;

    public function __construct(FormulirSetupService $setupService, FormulirService $formulirService) {
        $this->setupService = $setupService;
        $this->formulirService = $formulirService;
    }

    protected function ensureOpdAccess(): void
    {
        abort_unless(auth()->user()?->role === 'opd', 403);
    }

    public function index()
    {
        $this->ensureOpdAccess();

        $user = auth()->user();

        $formulirs = Formulir::where('created_by_id', $user->id)
            ->with('domains')
            ->latest()
            ->paginate(15)
            ->withQueryString();

        return view('dashboard.formulir.form-index', compact('formulirs'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        $this->ensureOpdAccess();
        return view('dashboard.formulir.form-create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $this->ensureOpdAccess();

        $request->validate([
            'nama_formulir' => 'required',
        ], [
            'nama_formulir.required' => 'Nama formulir harus diisi',
        ]);


        $this->formulirService->createFormulir([
            'nama_formulir' => $request->nama_formulir,
        ]);

        return redirect()->route('formulir.index')->with('success', 'Formulir berhasil ditambahkan');
    }


    public function show(Formulir $formulir)
    {
        $this->ensureOpdAccess();
        abort_unless($formulir->created_by_id === Auth::id(), 403);

        $formulir->load('domains.aspek.indikator');
        return view('dashboard.formulir.form-show', compact('formulir'));
    }


    public function edit(Formulir $formulir)
    {
        $this->ensureOpdAccess();
        abort_unless($formulir->created_by_id === Auth::id(), 403);

        return view('dashboard.formulir.form-edit', compact('formulir'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Formulir $formulir)
    {
        $this->ensureOpdAccess();
        abort_unless($formulir->created_by_id === Auth::id(), 403);

        $request->validate([
            'nama_formulir' => 'required',
        ], [
            'nama_formulir.required' => 'Nama formulir harus diisi',
        ]);


        $formulir->update([
            'nama_formulir' => $request->nama_formulir,
            'created_by_id' => Auth::id() // Tambahkan created_by_id
        ]);

        return redirect()->back()->with('success', 'Formulir berhasil Diperbarui');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Formulir $formulir)
    {
        $this->ensureOpdAccess();
        abort_unless($formulir->created_by_id === Auth::id(), 403);

        try {
            // Log informasi sebelum penghapusan
            \Log::info('Menghapus Formulir', [
                'formulir_id' => $formulir->id,
                'nama_formulir' => $formulir->nama_formulir,
                'domains_count' => $formulir->domains()->count(),
                'penilaians_count' => $formulir->penilaians()->count(),
                'formulir_domains_count' => $formulir->formulir_domains()->count()
            ]);

            // Hapus relasi terkait terlebih dahulu
            $formulir->domains()->detach(); // Lepaskan hubungan domain
            $formulir->penilaians()->delete(); // Hapus penilaian terkait
            $formulir->formulir_domains()->delete(); // Hapus formulir domain terkait

            // Kemudian hapus formulir
            $formulir->delete();

            return redirect()->route('formulir.index')->with('success', 'Formulir berhasil dihapus');
        } catch (\Exception $e) {
            // Log error jika terjadi masalah
            \Log::error('Gagal menghapus Formulir', [
                'formulir_id' => $formulir->id,
                'error_message' => $e->getMessage(),
                'error_trace' => $e->getTraceAsString()
            ]);

            return redirect()->back()->with('error', 'Gagal menghapus formulir: ' . $e->getMessage());
        }
    }


    public function setDefaultChildren($id)
    {
        $this->ensureOpdAccess();

        $formulir = Formulir::find($id);
        abort_unless($formulir && $formulir->created_by_id === Auth::id(), 403);
        $this->setupService->setup($formulir);

        return redirect()->route('formulir.index')->with('success', 'Data Domain telah ditambahkan ke dalam formulir');
    }
}
