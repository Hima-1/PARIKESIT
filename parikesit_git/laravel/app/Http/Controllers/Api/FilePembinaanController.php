<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\FilePembinaan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class FilePembinaanController extends Controller
{
    /**
     * Remove the specified file from storage.
     */
    public function destroy(FilePembinaan $filePemb)
    {
        if (!$filePemb->pembinaan) {
            return response()->json(['message' => 'File pembinaan tidak valid'], 400);
        }

        if (Auth::user()->role !== 'admin' && $filePemb->pembinaan->created_by_id !== Auth::id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $disk = Storage::disk('public');
        $fileExisted = $disk->exists($filePemb->nama_file);
        
        if ($fileExisted) {
            $disk->delete($filePemb->nama_file);
        }

        $filePemb->delete();

        return response()->json([
            'message' => $fileExisted 
                ? 'File berhasil dihapus' 
                : 'Data file dihapus dari database (file fisik tidak ditemukan di storage)'
        ]);
    }
}
