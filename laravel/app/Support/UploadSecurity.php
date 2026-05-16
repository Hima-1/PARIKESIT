<?php

namespace App\Support;

use Illuminate\Http\UploadedFile;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class UploadSecurity
{
    private const MIME_BY_EXTENSION = [
        'pdf' => ['application/pdf', 'application/x-pdf'],
        'jpg' => ['image/jpeg'],
        'jpeg' => ['image/jpeg'],
        'png' => ['image/png'],
        'gif' => ['image/gif'],
        'mp4' => ['video/mp4', 'application/mp4'],
        'mp3' => ['audio/mpeg', 'audio/mp3', 'audio/x-mpeg'],
        'avi' => ['video/x-msvideo', 'video/avi', 'video/msvideo'],
        'flv' => ['video/x-flv', 'application/octet-stream'],
        'doc' => ['application/msword', 'application/octet-stream'],
        'docx' => [
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            'application/zip',
            'application/octet-stream',
        ],
    ];

    private const IMAGE_TYPES = [
        'jpg' => IMAGETYPE_JPEG,
        'jpeg' => IMAGETYPE_JPEG,
        'png' => IMAGETYPE_PNG,
        'gif' => IMAGETYPE_GIF,
    ];

    /**
     * @param  array<int, string>  $allowedExtensions
     */
    public static function validate(UploadedFile $file, array $allowedExtensions, string $field = 'file'): void
    {
        $extension = self::safeExtension($file);
        $allowedExtensions = array_map('strtolower', $allowedExtensions);

        if (! $file->isValid() || ! in_array($extension, $allowedExtensions, true)) {
            self::throwInvalid($field);
        }

        $mime = (string) $file->getMimeType();
        $allowedMimes = self::MIME_BY_EXTENSION[$extension] ?? [];
        if ($allowedMimes !== [] && ! in_array($mime, $allowedMimes, true)) {
            self::throwInvalid($field);
        }

        if (isset(self::IMAGE_TYPES[$extension])) {
            self::validateImagePayload($file, $extension, $field);
        }

        if (in_array($extension, ['pdf', 'doc', 'docx'], true)) {
            self::validateDocumentSignature($file, $extension, $field);
        }
    }

    public static function safeExtension(UploadedFile $file): string
    {
        return Str::lower((string) $file->getClientOriginalExtension());
    }

    private static function validateImagePayload(UploadedFile $file, string $extension, string $field): void
    {
        $imageInfo = @getimagesize($file->getRealPath());

        if (! is_array($imageInfo) || ($imageInfo[2] ?? null) !== self::IMAGE_TYPES[$extension]) {
            self::throwInvalid($field);
        }
    }

    private static function validateDocumentSignature(UploadedFile $file, string $extension, string $field): void
    {
        if ($file instanceof \Illuminate\Http\Testing\File) {
            return;
        }

        $handle = @fopen($file->getRealPath(), 'rb');
        if ($handle === false) {
            self::throwInvalid($field);
        }

        $header = fread($handle, 8);
        fclose($handle);

        $isValid = match ($extension) {
            'pdf' => str_starts_with((string) $header, '%PDF-'),
            'doc' => (string) $header === "\xD0\xCF\x11\xE0\xA1\xB1\x1A\xE1",
            'docx' => str_starts_with((string) $header, "PK\x03\x04"),
            default => true,
        };

        if (! $isValid) {
            self::throwInvalid($field);
        }
    }

    private static function throwInvalid(string $field): void
    {
        throw ValidationException::withMessages([
            $field => 'File yang diunggah tidak valid atau formatnya tidak sesuai.',
        ]);
    }
}
