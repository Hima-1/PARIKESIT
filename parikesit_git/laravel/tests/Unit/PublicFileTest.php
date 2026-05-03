<?php

use App\Support\PublicFile;
use Illuminate\Support\Facades\Storage;

uses(Tests\TestCase::class);

test('public file url for storage-backed files is host agnostic', function () {
    Storage::disk('public')->put('file-dokumentasi/modern-doc/undangan.pdf', 'modern-undangan');

    expect(PublicFile::url('file-dokumentasi/modern-doc/undangan.pdf'))
        ->toBe('/storage/file-dokumentasi/modern-doc/undangan.pdf');
});

test('public file url supports paths stored with storage prefix', function () {
    Storage::disk('public')->put('file-dokumentasi/modern-doc/materi.pdf', 'modern-materi');

    expect(PublicFile::url('storage/file-dokumentasi/modern-doc/materi.pdf'))
        ->toBe('/storage/file-dokumentasi/modern-doc/materi.pdf');
});

test('public file url keeps legacy public assets working', function () {
    $legacyDirectory = public_path('legacy-dokumentasi');

    if (! is_dir($legacyDirectory)) {
        mkdir($legacyDirectory, 0777, true);
    }

    file_put_contents($legacyDirectory . DIRECTORY_SEPARATOR . 'legacy-unit.pdf', 'legacy-file');

    expect(PublicFile::url('legacy-dokumentasi/legacy-unit.pdf'))
        ->toBe(asset('legacy-dokumentasi/legacy-unit.pdf'));
});
