<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreDokumentasiRequest;
use App\Http\Requests\UpdateDokumentasiRequest;
use App\Models\DokumentasiKegiatan;
use App\Services\ActivityService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;

class DokumentasiKegiatanController extends Controller
{
    public function __construct(
        private readonly ActivityService $activityService,
    ) {}

    public function index(Request $request)
    {
        if ($response = $this->ensureCanRead()) {
            return $response;
        }

        $sortBy = $request->get('sort', 'created_at');
        $sortDirection = $request->get('direction', 'desc');
        $perPage = $request->get('per_page', 10);

        $query = DokumentasiKegiatan::query()
            ->with('profile:id,name')
            ->orderBy($sortBy, $sortDirection);

        if ($request->has('search')) {
            $query->where('judul_dokumentasi', 'like', '%'.$request->search.'%');
        }

        return response()->json(
            $query->paginate($perPage)->through(
                fn (DokumentasiKegiatan $dokumentasi) => $this->serializeDokumentasi($dokumentasi)
            )
        );
    }

    public function store(StoreDokumentasiRequest $request)
    {
        $slug = Str::slug($request->judul_dokumentasi.'-'.time());
        $basePath = 'file-dokumentasi';

        $fileData = $this->activityService->handleFileUploads($request, $basePath, $slug);

        $dokumentasi = DokumentasiKegiatan::create([
            'created_by_id' => Auth::id(),
            'judul_dokumentasi' => $request->judul_dokumentasi,
            'directory_dokumentasi' => $slug,
            'bukti_dukung_undangan_dokumentasi' => $fileData['bukti_dukung_undangan_dokumentasi'],
            'daftar_hadir_dokumentasi' => $fileData['daftar_hadir_dokumentasi'],
            'materi_dokumentasi' => $fileData['materi_dokumentasi'],
            'notula_dokumentasi' => $fileData['notula_dokumentasi'],
        ]);

        $this->activityService->handleMediaUploads($dokumentasi, $request, $basePath, $slug, 'file_dokumentasi');

        return response()->json([
            'message' => 'Dokumentasi berhasil dibuat',
            'data' => $this->serializeDokumentasi($dokumentasi->load(['file_dokumentasi', 'profile:id,name'])),
        ], 201);
    }

    public function show(DokumentasiKegiatan $dokumentasi)
    {
        if ($response = $this->ensureCanRead()) {
            return $response;
        }

        return response()->json(
            $this->serializeDokumentasi($dokumentasi->load(['file_dokumentasi', 'profile:id,name']))
        );
    }

    public function update(UpdateDokumentasiRequest $request, DokumentasiKegiatan $dokumentasi)
    {
        if ($dokumentasi->created_by_id !== Auth::id() && Auth::user()->role !== 'admin') {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $slug = $dokumentasi->directory_dokumentasi;
        $basePath = 'file-dokumentasi';

        $fileData = $this->activityService->handleFileUploads($request, $basePath, $slug, [
            'bukti_dukung_undangan' => $dokumentasi->bukti_dukung_undangan_dokumentasi,
            'daftar_hadir' => $dokumentasi->daftar_hadir_dokumentasi,
            'materi' => $dokumentasi->materi_dokumentasi,
            'notula' => $dokumentasi->notula_dokumentasi,
        ]);

        $dokumentasi->update([
            'judul_dokumentasi' => $request->judul_dokumentasi,
            'bukti_dukung_undangan_dokumentasi' => $fileData['bukti_dukung_undangan_dokumentasi'],
            'daftar_hadir_dokumentasi' => $fileData['daftar_hadir_dokumentasi'],
            'materi_dokumentasi' => $fileData['materi_dokumentasi'],
            'notula_dokumentasi' => $fileData['notula_dokumentasi'],
        ]);

        $this->activityService->handleMediaUploads($dokumentasi, $request, $basePath, $slug, 'file_dokumentasi');

        return response()->json([
            'message' => 'Dokumentasi berhasil diperbarui',
            'data' => $this->serializeDokumentasi($dokumentasi->load(['file_dokumentasi', 'profile:id,name'])),
        ]);
    }

    private function serializeDokumentasi(DokumentasiKegiatan $dokumentasi): array
    {
        $payload = [
            'id' => $dokumentasi->id,
            'created_by_id' => $dokumentasi->created_by_id,
            'creator_name' => $dokumentasi->profile?->name ?? 'Pengguna',
            'directory_dokumentasi' => $dokumentasi->directory_dokumentasi,
            'judul_dokumentasi' => $dokumentasi->judul_dokumentasi,
            'bukti_dukung_undangan_dokumentasi' => $dokumentasi->bukti_dukung_undangan_dokumentasi,
            'daftar_hadir_dokumentasi' => $dokumentasi->daftar_hadir_dokumentasi,
            'materi_dokumentasi' => $dokumentasi->materi_dokumentasi,
            'notula_dokumentasi' => $dokumentasi->notula_dokumentasi,
            'created_at' => $dokumentasi->created_at,
            'updated_at' => $dokumentasi->updated_at,
        ];

        if ($dokumentasi->relationLoaded('file_dokumentasi')) {
            $payload['file_dokumentasi'] = $dokumentasi->file_dokumentasi->values()->toArray();
        }

        return $payload;
    }

    public function destroy(DokumentasiKegiatan $dokumentasi)
    {
        if ($dokumentasi->created_by_id !== Auth::id() && Auth::user()->role !== 'admin') {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $dokumentasi->delete();

        return response()->json(['message' => 'Dokumentasi berhasil dihapus']);
    }

    public function download(DokumentasiKegiatan $dokumentasi)
    {
        if ($response = $this->ensureCanRead()) {
            return $response;
        }

        \Log::info('Dokumentasi download requested', [
            'dokumentasi_id' => $dokumentasi->id,
            'user_id' => Auth::id(),
            'role' => Auth::user()?->role,
        ]);

        $zipInfo = $this->activityService->generateZip($dokumentasi->loadMissing('file_dokumentasi'), $dokumentasi->judul_dokumentasi, 'dokumentasi');

        if ($zipInfo) {
            $response = response()->download($zipInfo['path'], $zipInfo['name']);
            if (! app()->environment('testing')) {
                $response->deleteFileAfterSend(true);
            }

            return $response;
        }

        return response()->json(['message' => 'Gagal membuat file zip'], 500);
    }

    public function downloadBatch(Request $request)
    {
        if ($response = $this->ensureCanRead()) {
            return $response;
        }

        $ids = $request->get('ids', []);
        if (empty($ids)) {
            return response()->json(['message' => 'ID dokumentasi tidak boleh kosong'], 400);
        }

        $activities = DokumentasiKegiatan::whereIn('id', $ids)->with('file_dokumentasi')->get();
        $zipInfo = $this->activityService->generateBatchZip($activities, 'dokumentasi');

        if ($zipInfo) {
            $response = response()->download($zipInfo['path'], $zipInfo['name']);
            if (! app()->environment('testing')) {
                $response->deleteFileAfterSend(true);
            }

            return $response;
        }

        return response()->json(['message' => 'Gagal membuat file zip'], 500);
    }

    private function ensureCanRead()
    {
        if (! in_array(Auth::user()?->role, ['admin', 'opd', 'walidata'], true)) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        return null;
    }
}
