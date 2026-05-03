<?php

namespace App\Http\Controllers;

use App\Models\FileDokumentasi;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class FileDokumentasiController extends Controller
{
    public function destroy(FileDokumentasi $fileDok)
    {
        abort_unless(
            Auth::user()?->role === 'admin' || $fileDok->dokumentasi?->created_by_id === Auth::id(),
            403
        );

        if (Storage::disk('public')->exists($fileDok->nama_file)) {
            Storage::disk('public')->delete($fileDok->nama_file);
        } elseif ($legacyPath = $fileDok->publicPath()) {
            @unlink($legacyPath);
        }

        $fileDok->delete();
        return redirect()->back()->with('success', 'File berhasil dihapus');
    }
}
