<?php

namespace App\Http\Controllers;

use App\Models\DokumentasiKegiatan;
use App\Services\ActivityService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;

class DokumentasiKegiatanController extends Controller
{
    public function __construct(
        protected ActivityService $activityService
    ) {}

    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = DokumentasiKegiatan::with('file_dokumentasi')->latest();

        // Jika ada parameter pencarian
        if ($request->has('search')) {
            $search = $request->input('search');
            $query->where('judul_dokumentasi', 'like', '%'.$search.'%');
        }

        // Filter berdasarkan tanggal
        if ($request->has('start_date') && $request->has('end_date')) {
            $startDate = $request->input('start_date');
            $endDate = $request->input('end_date');

            $query->whereBetween('created_at', [$startDate, $endDate]);
        }

        $dokumentasis = $query->paginate(10)->withQueryString();

        return view('dashboard.dokumentasi.dokumentasi-index', compact('dokumentasis'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view('dashboard.dokumentasi.dokumentasi-create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'judul_dokumentasi' => 'required',
            'bukti_dukung_undangan' => 'required|mimes:pdf|max:5120',
            'daftar_hadir' => 'required|mimes:pdf|max:5120',
            'materi' => 'required|mimes:pdf|max:5120',
            'notula' => 'required|mimes:pdf|max:5120',
            'files' => 'nullable|array',
            'files.*' => 'required|mimes:jpeg,png,jpg,gif,mp4,mp3,avi,flv|max:5120',
        ], [
            'judul_dokumentasi.required' => 'Nama Dokumentasi harus diisi',
            'bukti_dukung_undangan.required' => 'Bukti Dukung harus diisi',
            'bukti_dukung_undangan.mimes' => 'Bukti Dukung harus PDF',
            'bukti_dukung_undangan.max' => 'Bukti Dukung maximal 5mb',
            'daftar_hadir.required' => 'Daftar Hadir harus diisi',
            'daftar_hadir.mimes' => 'Daftar Hadir harus PDF',
            'daftar_hadir.max' => 'Daftar Hadir maximal 5mb',
            'materi.required' => 'Materi harus diisi',
            'materi.mimes' => 'Materi harus PDF',
            'materi.max' => 'Materi maximal 5mb',
            'notula.required' => 'Notula harus diisi',
            'notula.mimes' => 'Notula harus PDF',
            'notula.max' => 'Notula maximal 5mb',
            'files.*.required' => 'File harus diisi',
            'files.*.mimes' => 'File harus berupa gambar atau video',
            'files.*.max' => 'File maximal 5mb',
        ]);

        $slug = $this->uniqueActivityDirectory($request->judul_dokumentasi);
        $basePath = 'file-dokumentasi';
        $fileData = $this->activityService->handleFileUploads($request, $basePath, $slug);

        $kegiatan = DokumentasiKegiatan::create([
            'created_by_id' => Auth::user()->id,
            'judul_dokumentasi' => $request->judul_dokumentasi,
            'directory_dokumentasi' => $slug,
            'bukti_dukung_undangan_dokumentasi' => $fileData['bukti_dukung_undangan_dokumentasi'],
            'daftar_hadir_dokumentasi' => $fileData['daftar_hadir_dokumentasi'],
            'materi_dokumentasi' => $fileData['materi_dokumentasi'],
            'notula_dokumentasi' => $fileData['notula_dokumentasi'],
        ]);

        $this->activityService->handleMediaUploads($kegiatan, $request, $basePath, $slug, 'file_dokumentasi');

        return redirect()->route('dokumentasi.index')->with('success', 'Dokumentasi berhasil dibuat');
    }

    /**
     * Display the specified resource.
     */
    public function show(DokumentasiKegiatan $dokumentasiKegiatan)
    {
        $dokumentasiKegiatan->load('file_dokumentasi');

        return view('dashboard.dokumentasi.dokumentasi-show', compact('dokumentasiKegiatan'));
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(DokumentasiKegiatan $dokumentasiKegiatan)
    {
        $this->authorizeOwnership($dokumentasiKegiatan);
        $dokumentasiKegiatan->load('file_dokumentasi');

        return view('dashboard.dokumentasi.dokumentasi-edit', compact('dokumentasiKegiatan'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, DokumentasiKegiatan $dokumentasiKegiatan)
    {
        $this->authorizeOwnership($dokumentasiKegiatan);

        $request->validate([
            'judul_dokumentasi' => 'required',
            'bukti_dukung_undangan' => 'mimes:pdf|max:5120',
            'daftar_hadir' => 'mimes:pdf|max:5120',
            'materi' => 'mimes:pdf|max:5120',
            'notula' => 'mimes:pdf|max:5120',
        ], [
            'judul_dokumentasi.required' => 'Nama Dokumentasi harus diisi',
            'bukti_dukung_undangan.required' => 'Bukti Dukung harus diisi',
            'bukti_dukung_undangan.mimes' => 'Bukti Dukung harus PDF',
            'bukti_dukung_undangan.max' => 'Bukti Dukung maximal 5mb',
            'daftar_hadir.required' => 'Daftar Hadir harus diisi',
            'daftar_hadir.mimes' => 'Daftar Hadir harus PDF',
            'daftar_hadir.max' => 'Daftar Hadir maximal 5mb',
            'materi.required' => 'Materi harus diisi',
            'materi.mimes' => 'Materi harus PDF',
            'materi.max' => 'Materi maximal 5mb',
            'notula.required' => 'Notula harus diisi',
            'notula.mimes' => 'Notula harus PDF',
            'notula.max' => 'Notula maximal 5mb',

        ]);

        $slug = $dokumentasiKegiatan->directory_dokumentasi;
        $basePath = 'file-dokumentasi';
        $fileData = $this->activityService->handleFileUploads($request, $basePath, $slug, [
            'bukti_dukung_undangan' => $dokumentasiKegiatan->bukti_dukung_undangan_dokumentasi,
            'daftar_hadir' => $dokumentasiKegiatan->daftar_hadir_dokumentasi,
            'materi' => $dokumentasiKegiatan->materi_dokumentasi,
            'notula' => $dokumentasiKegiatan->notula_dokumentasi,
        ]);

        $dokumentasiKegiatan->update([
            'judul_dokumentasi' => $request->judul_dokumentasi,
            'bukti_dukung_undangan_dokumentasi' => $fileData['bukti_dukung_undangan_dokumentasi'],
            'daftar_hadir_dokumentasi' => $fileData['daftar_hadir_dokumentasi'],
            'materi_dokumentasi' => $fileData['materi_dokumentasi'],
            'notula_dokumentasi' => $fileData['notula_dokumentasi'],
        ]);

        $this->activityService->handleMediaUploads($dokumentasiKegiatan, $request, $basePath, $slug, 'file_dokumentasi');

        return redirect()->route('dokumentasi.show', $dokumentasiKegiatan->id)
            ->with('success', 'Dokumentasi berhasil diupdate');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(DokumentasiKegiatan $dokumentasiKegiatan)
    {
        $this->authorizeOwnership($dokumentasiKegiatan);
        $dokumentasiKegiatan->delete();

        return redirect()->route('dokumentasi.index')->with('success', 'Dokumentasi berhasil dihapus');
    }

    public function downloadAll(DokumentasiKegiatan $dokumentasiKegiatan)
    {
        $zipInfo = $this->activityService->generateZip(
            $dokumentasiKegiatan->loadMissing('file_dokumentasi'),
            $dokumentasiKegiatan->judul_dokumentasi,
            'dokumentasi'
        );

        if ($zipInfo) {
            return response()->download($zipInfo['path'], $zipInfo['name'])->deleteFileAfterSend(true);
        }

        return redirect()->back()->with('error', 'Gagal membuat file zip');
    }

    public function downloadMultiple(Request $request)
    {
        $selectedDokumentasiIds = $request->input('selected_dokumentasi', []);

        if (empty($selectedDokumentasiIds)) {
            return redirect()->back()->with('error', 'Tidak ada dokumentasi yang dipilih');
        }

        $dokumentasis = DokumentasiKegiatan::whereIn('id', $selectedDokumentasiIds)
            ->with('file_dokumentasi')
            ->get();

        $zipInfo = $this->activityService->generateBatchZip($dokumentasis, 'dokumentasi');

        if ($zipInfo) {
            return response()->download($zipInfo['path'], $zipInfo['name'])->deleteFileAfterSend(true);
        }

        return redirect()->back()->with('error', 'Gagal membuat file zip');
    }

    public function downloadPage()
    {
        $user = Auth::user();

        if ($user->role !== 'admin') {
            $dokumentasis = DokumentasiKegiatan::whereHas('file_dokumentasi')
                ->where('created_by_id', $user->id)
                ->with('file_dokumentasi')
                ->latest()
                ->get();
        } else {
            $dokumentasis = DokumentasiKegiatan::whereHas('file_dokumentasi')
                ->with('file_dokumentasi')
                ->latest()
                ->get();
        }

        return view('dashboard.dokumentasi.download', compact('dokumentasis'));
    }

    private function authorizeOwnership(DokumentasiKegiatan $dokumentasiKegiatan): void
    {
        abort_unless(
            Auth::user()?->role === 'admin' || $dokumentasiKegiatan->created_by_id === Auth::id(),
            403
        );
    }

    private function uniqueActivityDirectory(string $title): string
    {
        $base = Str::slug($title);

        return ($base !== '' ? $base : 'activity').'-'.Str::ulid();
    }
}
