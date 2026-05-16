<?php

namespace App\Http\Controllers;

use App\Models\FilePembinaan;
use App\Support\UploadSecurity;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class FilePembinaanController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'file' => 'required|file|mimes:pdf,jpg,png,jpeg|max:2048',
        ]);

        $file = $request->file('file');
        UploadSecurity::validate($file, ['pdf', 'jpg', 'png', 'jpeg']);
        $nama_file = $this->uniqueStoredFileName($file);

        $tujuan_upload = 'data_file';
        $file->move($tujuan_upload, $nama_file);

        FilePembinaan::create([
            'nama_file' => $tujuan_upload.'/'.$nama_file,
            'dokumentasi_kegiatan_id' => $request->dokumentasi_kegiatan_id,
        ]);

        return redirect()->back()->with('success', 'File berhasil diupload');
    }

    public function destroy(FilePembinaan $filePemb)
    {
        // Pastikan file pembinaan memiliki relasi pembinaan
        if (! $filePemb->pembinaan) {
            return redirect()->back()->with('error', 'File pembinaan tidak valid');
        }

        // Pastikan file hanya bisa dihapus oleh pembuat pembinaan atau admin
        $pembinaan = $filePemb->pembinaan;
        if (Auth::user()->role !== 'admin' && $pembinaan->created_by_id !== Auth::user()->id) {
            return redirect()->back()->with('error', 'Anda tidak memiliki izin untuk menghapus media pembinaan ini');
        }

        // Hapus file fisik jika ada
        if (file_exists(public_path($filePemb->nama_file))) {
            unlink(public_path($filePemb->nama_file));
        }

        $filePemb->delete();

        return redirect()->back()->with('success', 'File berhasil dihapus');
    }

    private function uniqueStoredFileName($file): string
    {
        return Str::ulid().'.'.UploadSecurity::safeExtension($file);
    }
}
