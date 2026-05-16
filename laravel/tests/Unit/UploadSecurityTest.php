<?php

use App\Support\UploadSecurity;
use Illuminate\Http\UploadedFile;

uses(Tests\TestCase::class);

test('upload security accepts readable images with allowed extensions', function () {
    $file = UploadedFile::fake()->image('photo.jpg');

    UploadSecurity::validate($file, ['jpg', 'jpeg', 'png']);

    expect(UploadSecurity::safeExtension($file))->toBe('jpg');
});

test('upload security rejects spoofed image payloads', function () {
    $file = UploadedFile::fake()->create('photo.jpg', 10, 'image/jpeg');

    UploadSecurity::validate($file, ['jpg', 'jpeg', 'png']);
})->throws(\Illuminate\Validation\ValidationException::class);

test('upload security rejects disallowed extensions even when mime is known', function () {
    $file = UploadedFile::fake()->create('payload.php', 10, 'application/pdf');

    UploadSecurity::validate($file, ['pdf']);
})->throws(\Illuminate\Validation\ValidationException::class);
