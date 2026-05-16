<?php

namespace App\Http\Controllers;

use App\Models\Pembinaan;
use App\Support\InputSanitizer;
use App\Support\UploadSecurity;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Str;

class PembinaanController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Pembinaan::with('file_pembinaan')->latest();

        if ($request->has('search')) {
            $search = InputSanitizer::safeSearch($request->input('search'));
            $query->where('judul_pembinaan', 'like', '%'.$search.'%');
        }

        if ($request->has('start_date') && $request->has('end_date')) {
            $startDate = $request->input('start_date');
            $endDate = $request->input('end_date');

            $query->whereBetween('created_at', [$startDate, $endDate]);
        }

        $pembinaans = $query->paginate(10)->withQueryString();

        return view('dashboard.pembinaan.pembinaan-index', compact('pembinaans'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view('dashboard.pembinaan.pembinaan-create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'judul_pembinaan' => 'required|string|max:255',
            'bukti_dukung_undangan' => 'required|file|mimes:pdf|max:5120',
            'daftar_hadir' => 'required|file|mimes:pdf|max:5120',
            'materi' => 'required|file|mimes:pdf|max:5120',
            'notula' => 'required|file|mimes:pdf|max:5120',
            'files' => 'nullable|array',
            'files.*' => 'required|file|mimes:jpeg,png,jpg,gif,mp4,mp3,avi,flv|max:5120',
        ], [
            'judul_pembinaan.required' => 'Nama pembinaan harus diisi',
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

        $judulPembinaan = InputSanitizer::plainText($request->judul_pembinaan, 255);
        $judul = $this->uniqueActivityDirectory($judulPembinaan);
        $path = 'file-pembinaan/'.$judul;
        if (! file_exists($path)) {
            mkdir($path, 0777, true);
        }

        $data = [];
        $data['judul_pembinaan'] = $judulPembinaan;

        $fileFields = [
            'bukti_dukung_undangan',
            'daftar_hadir',
            'materi',
            'notula',
        ];

        foreach ($fileFields as $field) {
            $file = $request->file($field);
            if ($file) {
                UploadSecurity::validate($file, ['pdf'], $field);
                $filSaved = $this->uniqueStoredFileName($field, $file);
                $path = $file->move('file-pembinaan/'.$judul.'/', $filSaved);
                $data[$field] = $path;
            } else {
                $data[$field] = null;
            }
        }

        $kegiatan = Pembinaan::create([
            'created_by_id' => Auth::user()->id,
            'judul_pembinaan' => $judulPembinaan,
            'directory_pembinaan' => $judul,
            'bukti_dukung_undangan_pembinaan' => $data['bukti_dukung_undangan'],
            'daftar_hadir_pembinaan' => $data['daftar_hadir'],
            'materi_pembinaan' => $data['materi'],
            'notula_pembinaan' => $data['notula'],
        ]);

        $files = $request->file('files');
        if ($files && is_array($files)) {
            foreach ($files as $index => $file) {
                if ($file) {
                    UploadSecurity::validate($file, ['jpeg', 'png', 'jpg', 'gif', 'mp4', 'mp3', 'avi', 'flv'], 'files.'.$index);
                    $filSaved = $this->uniqueStoredFileName('media-'.$index, $file);
                    $fileext = UploadSecurity::safeExtension($file);
                    $file->move('file-pembinaan/'.$judul.'/media', $filSaved);

                    $kegiatan->file_pembinaan()->create([
                        'nama_file' => 'file-pembinaan/'.$judul.'/media/'.$filSaved,
                        'tipe_file' => $fileext,
                        'pembinaan_id' => $kegiatan->id,
                    ]);
                }
            }
        }

        return redirect()->route('pembinaan.index')->with('success', 'Pembinaan berhasil ditambahkan');
    }

    /**
     * Display the specified resource.
     */
    public function show(Pembinaan $pembinaan)
    {
        $pembinaan->load('file_pembinaan');

        return view('dashboard.pembinaan.pembinaan-show', compact('pembinaan'));
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Pembinaan $pembinaan)
    {
        $pembinaan->load('file_pembinaan');

        return view('dashboard.pembinaan.pembinaan-edit', compact('pembinaan'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Pembinaan $pembinaan)
    {
        $pembinaan->load('file_pembinaan');

        $request->validate([
            'judul_pembinaan' => 'required|string|max:255',
            'bukti_dukung_undangan' => 'nullable|file|mimes:pdf|max:5120',
            'daftar_hadir' => 'nullable|file|mimes:pdf|max:5120',
            'materi' => 'nullable|file|mimes:pdf|max:5120',
            'notula' => 'nullable|file|mimes:pdf|max:5120',

        ], [
            'judul_pembinaan.required' => 'Nama pembinaan harus diisi',
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

        $judul = $pembinaan->directory_pembinaan;
        $path = 'file-pembinaan/'.$judul;
        $data = [];
        $data['judul_pembinaan'] = InputSanitizer::plainText($request->judul_pembinaan, 255);

        $dataFiles = [
            'bukti_dukung_undangan' => [
                'request_file' => $request->file('bukti_dukung_undangan'),
                'local_file' => $pembinaan->bukti_dukung_undangan_pembinaan,
            ],
            'daftar_hadir' => [
                'request_file' => $request->file('daftar_hadir'),
                'local_file' => $pembinaan->daftar_hadir_pembinaan,
            ],
            'materi' => [
                'request_file' => $request->file('materi'),
                'local_file' => $pembinaan->materi_pembinaan,
            ],
            'notula' => [
                'request_file' => $request->file('notula'),
                'local_file' => $pembinaan->notula_pembinaan,
            ],
        ];

        foreach ($dataFiles as $indexName => $field) {
            $file = $field['request_file'];
            $localFile = $field['local_file'];

            if ($file) {
                UploadSecurity::validate($file, ['pdf'], $indexName);
                $fileSaved = $this->uniqueStoredFileName($indexName, $file);
                $path = $file->move('file-pembinaan/'.$judul.'/', $fileSaved);
                $data[$indexName] = $path;

                if (File::exists($localFile)) {
                    unlink($localFile);
                }
            }
        }

        $pembinaan->update([
            'created_by_id' => Auth::user()->id,
            'judul_pembinaan' => $data['judul_pembinaan'],
            'bukti_dukung_undangan_pembinaan' => $data['bukti_dukung_undangan'] ?? $pembinaan->bukti_dukung_undangan_pembinaan,
            'daftar_hadir_pembinaan' => $data['daftar_hadir'] ?? $pembinaan->daftar_hadir_pembinaan,
            'materi_pembinaan' => $data['materi'] ?? $pembinaan->materi_pembinaan,
            'notula_pembinaan' => $data['notula'] ?? $pembinaan->notula_pembinaan,
        ]);

        return redirect()->route('pembinaan.show', $pembinaan->id)->with('success', 'Pembinaan berhasil diupdate');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Pembinaan $pembinaan)
    {
        $pembinaan->delete();

        return redirect()->route('pembinaan.index')->with('success', 'Pembinaan Berhasil dihapus');
    }

    public function downloadAll(Pembinaan $pembinaan)
    {
        $pembinaan->load('file_pembinaan');

        $zipFileName = $this->zipFileName(Str::slug($pembinaan->judul_pembinaan), 'pembinaan');
        $zip = new \ZipArchive;
        $zipPath = storage_path('app/public/pembinaan-zip/'.$zipFileName);

        if (! file_exists(dirname($zipPath))) {
            mkdir(dirname($zipPath), 0777, true);
        }

        if ($zip->open($zipPath, \ZipArchive::CREATE | \ZipArchive::OVERWRITE) === true) {
            $mainFiles = [
                'bukti_dukung_undangan_pembinaan' => 'Bukti Dukung Undangan.pdf',
                'daftar_hadir_pembinaan' => 'Daftar Hadir.pdf',
                'materi_pembinaan' => 'Materi.pdf',
                'notula_pembinaan' => 'Notula.pdf',
            ];

            foreach ($mainFiles as $field => $fileName) {
                $filePath = $pembinaan->$field;
                if ($filePath && file_exists(public_path($filePath))) {
                    $zip->addFile(
                        public_path($filePath),
                        $fileName
                    );
                }
            }

            $mediaFolder = 'Media/';
            $zip->addEmptyDir($mediaFolder);

            foreach ($pembinaan->file_pembinaan as $index => $media) {
                $mediaPath = $media->nama_file;
                if (file_exists(public_path($mediaPath))) {
                    $zip->addFile(
                        public_path($mediaPath),
                        $mediaFolder.($index + 1).'.'.pathinfo($mediaPath, PATHINFO_EXTENSION)
                    );
                }
            }

            $zip->close();

            return response()->download($zipPath, $zipFileName)->deleteFileAfterSend(true);
        }

        return redirect()->back()->with('error', 'Gagal membuat file zip');
    }

    private function uniqueActivityDirectory(string $title): string
    {
        $base = Str::slug($title);

        return ($base !== '' ? $base : 'activity').'-'.Str::ulid();
    }

    private function uniqueStoredFileName(string $prefix, $file): string
    {
        return $prefix.'-'.Str::ulid().'.'.UploadSecurity::safeExtension($file);
    }

    private function zipFileName(string $name, string $type): string
    {
        $baseName = $name !== '' ? $name : 'activity';

        return $baseName.'-'.$type.'-'.now()->format('YmdHis').'-'.Str::ulid().'.zip';
    }
}
