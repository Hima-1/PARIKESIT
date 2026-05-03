<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\FileDokumentasi;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class FileDokumentasiController extends Controller
{
    /**
     * Remove the specified file from storage.
     */
    public function destroy(FileDokumentasi $fileDok)
    {
        if (!$fileDok->dokumentasi) {
            return response()->json(['message' => 'File dokumentasi tidak valid'], 400);
        }

        if (Auth::user()->role !== 'admin' && $fileDok->dokumentasi->created_by_id !== Auth::id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $disk = Storage::disk('public');
        $fileExisted = $disk->exists($fileDok->nama_file);

        if ($fileExisted) {
            $disk->delete($fileDok->nama_file);
        }

        $fileDok->delete();

        return response()->json([
            'message' => $fileExisted
                ? 'File berhasil dihapus'
                : 'Data file dihapus dari database (file fisik tidak ditemukan di storage)'
        ]);
    }
}
