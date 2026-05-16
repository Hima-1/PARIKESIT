<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StorePembinaanRequest;
use App\Http\Requests\UpdatePembinaanRequest;
use App\Models\Pembinaan;
use App\Services\ActivityService;
use App\Support\InputSanitizer;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;

class PembinaanController extends Controller
{
    protected $activityService;

    public function __construct(ActivityService $activityService)
    {
        $this->activityService = $activityService;
    }

    public function index(Request $request)
    {
        if ($response = $this->ensureAdminCanRead()) {
            return $response;
        }

        $sortBy = InputSanitizer::sortBy($request->get('sort'), ['created_at', 'judul_pembinaan'], 'created_at');
        $sortDirection = InputSanitizer::sortDirection($request->get('direction'));
        $perPage = InputSanitizer::safeIntRange($request->get('per_page'), 10, 1, 50);
        $search = InputSanitizer::safeSearch($request->get('search'));

        $query = Pembinaan::query()
            ->with('profile:id,name')
            ->orderBy($sortBy, $sortDirection);

        if ($search !== '') {
            $query->where('judul_pembinaan', 'like', "%{$search}%");
        }

        return response()->json(
            $query->paginate($perPage)->through(
                fn (Pembinaan $pembinaan) => $this->serializePembinaan($pembinaan)
            )
        );
    }

    public function store(StorePembinaanRequest $request)
    {
        $validated = $request->validated();
        $slug = $this->uniqueActivityDirectory($validated['judul_pembinaan']);
        $basePath = 'file-pembinaan';

        $fileData = $this->activityService->handleFileUploads($request, $basePath, $slug);

        $pembinaan = Pembinaan::create([
            'created_by_id' => Auth::id(),
            'judul_pembinaan' => $validated['judul_pembinaan'],
            'directory_pembinaan' => $slug,
            'bukti_dukung_undangan_pembinaan' => $fileData['bukti_dukung_undangan_pembinaan'],
            'daftar_hadir_pembinaan' => $fileData['daftar_hadir_pembinaan'],
            'materi_pembinaan' => $fileData['materi_pembinaan'],
            'notula_pembinaan' => $fileData['notula_pembinaan'],
        ]);

        $this->activityService->handleMediaUploads($pembinaan, $request, $basePath, $slug, 'file_pembinaan');

        return response()->json([
            'message' => 'Pembinaan berhasil ditambahkan',
            'data' => $this->serializePembinaan($pembinaan->load(['file_pembinaan', 'profile:id,name'])),
        ], 201);
    }

    private function logDataTypes($data, $prefix = '')
    {
        foreach ($data as $key => $value) {
            $type = gettype($value);
            if ($type === 'array' || $type === 'object') {
                $this->logDataTypes((array) $value, $prefix.$key.'.');
            } elseif ($type === 'resource') {
                \Log::error("Resource found at {$prefix}{$key}");
            }
        }
    }

    public function show(Pembinaan $pembinaan)
    {
        if ($response = $this->ensureAdminCanRead()) {
            return $response;
        }

        return response()->json(
            $this->serializePembinaan($pembinaan->load(['file_pembinaan', 'profile:id,name']))
        );
    }

    public function update(UpdatePembinaanRequest $request, Pembinaan $pembinaan)
    {
        $validated = $request->validated();

        if ($pembinaan->created_by_id !== Auth::id() && Auth::user()->role !== 'admin') {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $slug = $pembinaan->directory_pembinaan;
        $basePath = 'file-pembinaan';

        $fileData = $this->activityService->handleFileUploads($request, $basePath, $slug, [
            'bukti_dukung_undangan' => $pembinaan->bukti_dukung_undangan_pembinaan,
            'daftar_hadir' => $pembinaan->daftar_hadir_pembinaan,
            'materi' => $pembinaan->materi_pembinaan,
            'notula' => $pembinaan->notula_pembinaan,
        ]);

        $pembinaan->update([
            'judul_pembinaan' => $validated['judul_pembinaan'],
            'bukti_dukung_undangan_pembinaan' => $fileData['bukti_dukung_undangan_pembinaan'],
            'daftar_hadir_pembinaan' => $fileData['daftar_hadir_pembinaan'],
            'materi_pembinaan' => $fileData['materi_pembinaan'],
            'notula_pembinaan' => $fileData['notula_pembinaan'],
        ]);

        $this->activityService->handleMediaUploads($pembinaan, $request, $basePath, $slug, 'file_pembinaan');

        return response()->json([
            'message' => 'Pembinaan berhasil diperbarui',
            'data' => $this->serializePembinaan($pembinaan->load(['file_pembinaan', 'profile:id,name'])),
        ]);
    }

    private function serializePembinaan(Pembinaan $pembinaan): array
    {
        $payload = [
            'id' => $pembinaan->id,
            'created_by_id' => $pembinaan->created_by_id,
            'creator_name' => $pembinaan->profile?->name ?? 'Pengguna',
            'directory_pembinaan' => $pembinaan->directory_pembinaan,
            'judul_pembinaan' => $pembinaan->judul_pembinaan,
            'bukti_dukung_undangan_pembinaan' => $pembinaan->bukti_dukung_undangan_pembinaan,
            'daftar_hadir_pembinaan' => $pembinaan->daftar_hadir_pembinaan,
            'materi_pembinaan' => $pembinaan->materi_pembinaan,
            'notula_pembinaan' => $pembinaan->notula_pembinaan,
            'created_at' => $pembinaan->created_at,
            'updated_at' => $pembinaan->updated_at,
        ];

        if ($pembinaan->relationLoaded('file_pembinaan')) {
            $payload['file_pembinaan'] = $pembinaan->file_pembinaan->values()->toArray();
        }

        return $payload;
    }

    public function destroy(Pembinaan $pembinaan)
    {
        if ($pembinaan->created_by_id !== Auth::id() && Auth::user()->role !== 'admin') {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $pembinaan->delete();

        return response()->json(['message' => 'Pembinaan berhasil dihapus']);
    }

    public function download(Pembinaan $pembinaan)
    {
        if ($response = $this->ensureAdminCanRead()) {
            return $response;
        }

        \Log::info('Pembinaan download requested', [
            'pembinaan_id' => $pembinaan->id,
            'user_id' => Auth::id(),
            'role' => Auth::user()?->role,
        ]);

        $zipInfo = $this->activityService->generateZip($pembinaan->loadMissing('file_pembinaan'), $pembinaan->judul_pembinaan, 'pembinaan');

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
        if ($response = $this->ensureAdminCanRead()) {
            return $response;
        }

        $ids = InputSanitizer::intArray($request->get('ids', []));
        if (empty($ids)) {
            return response()->json(['message' => 'ID pembinaan tidak boleh kosong'], 400);
        }

        $activities = Pembinaan::whereIn('id', $ids)->with('file_pembinaan')->get();
        $zipInfo = $this->activityService->generateBatchZip($activities, 'pembinaan');

        if ($zipInfo) {
            $response = response()->download($zipInfo['path'], $zipInfo['name']);
            if (! app()->environment('testing')) {
                $response->deleteFileAfterSend(true);
            }

            return $response;
        }

        return response()->json(['message' => 'Gagal membuat file zip'], 500);
    }

    private function ensureAdminCanRead()
    {
        if (Auth::user()?->role !== 'admin') {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        return null;
    }

    private function uniqueActivityDirectory(string $title): string
    {
        $base = Str::slug($title);

        return ($base !== '' ? $base : 'activity').'-'.Str::ulid();
    }
}
