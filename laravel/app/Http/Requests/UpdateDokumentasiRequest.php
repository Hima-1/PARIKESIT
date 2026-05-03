<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Auth;

class UpdateDokumentasiRequest extends FormRequest
{
    protected function prepareForValidation(): void
    {
        if ($this->hasFile('files') && ! is_array($this->file('files'))) {
            $files = [$this->file('files')];
            $this->merge(['files' => $files]);
            $this->files->set('files', $files);
        }
    }

    public function authorize(): bool
    {
        $dokumentasi = $this->route('dokumentasi');
        $user = Auth::user();

        if (! $user || ! $dokumentasi) {
            return false;
        }

        return $user->role === 'admin' || $dokumentasi->created_by_id === $user->id;
    }

    public function rules(): array
    {
        return [
            'judul_dokumentasi' => 'required',
            'bukti_dukung_undangan' => 'nullable|mimes:pdf|max:5120',
            'daftar_hadir' => 'nullable|mimes:pdf|max:5120',
            'materi' => 'nullable|mimes:pdf|max:5120',
            'notula' => 'nullable|mimes:pdf|max:5120',
            'files' => 'nullable',
            'files.*' => 'required|mimes:jpeg,png,jpg,gif,mp4,mp3,avi,flv|max:5120',
        ];
    }

    public function withValidator($validator): void
    {
        $validator->after(function ($validator) {
            $files = $this->file('files');

            if ($files && ! is_array($files)) {
                $singleFileValidator = validator(
                    ['file' => $files],
                    ['file' => 'required|mimes:jpeg,png,jpg,gif,mp4,mp3,avi,flv|max:5120'],
                    [
                        'file.required' => 'File harus diisi',
                        'file.mimes' => 'File harus berupa gambar atau video',
                        'file.max' => 'File maximal 5mb',
                    ]
                );

                foreach ($singleFileValidator->errors()->get('file') as $message) {
                    $validator->errors()->add('files', $message);
                }
            }
        });
    }

    public function messages(): array
    {
        return [
            'judul_dokumentasi.required' => 'Nama dokumentasi harus diisi',
            'bukti_dukung_undangan.mimes' => 'Bukti Dukung harus PDF',
            'bukti_dukung_undangan.max' => 'Bukti Dukung maximal 5mb',
            'daftar_hadir.mimes' => 'Daftar Hadir harus PDF',
            'daftar_hadir.max' => 'Daftar Hadir maximal 5mb',
            'materi.mimes' => 'Materi harus PDF',
            'materi.max' => 'Materi maximal 5mb',
            'notula.mimes' => 'Notula harus PDF',
            'notula.max' => 'Notula maximal 5mb',
            'files.*.required' => 'File harus diisi',
            'files.*.mimes' => 'File harus berupa gambar atau video',
            'files.*.max' => 'File maximal 5mb',
        ];
    }
}
