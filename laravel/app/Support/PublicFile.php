<?php

namespace App\Support;

use Illuminate\Support\Facades\Storage;

class PublicFile
{
    public static function url(?string $path): ?string
    {
        foreach (self::candidatePaths($path) as $candidate) {
            if (Storage::disk('public')->exists($candidate)) {
                return self::storageUrl($candidate);
            }
        }

        $legacyPath = self::normalize($path);
        if ($legacyPath && file_exists(public_path($legacyPath))) {
            return asset($legacyPath);
        }

        return null;
    }

    public static function absolutePath(?string $path): ?string
    {
        foreach (self::candidatePaths($path) as $candidate) {
            if (Storage::disk('public')->exists($candidate)) {
                return Storage::disk('public')->path($candidate);
            }
        }

        $legacyPath = self::normalize($path);
        if ($legacyPath) {
            $absolutePath = public_path($legacyPath);
            if (file_exists($absolutePath)) {
                return $absolutePath;
            }
        }

        return null;
    }

    public static function exists(?string $path): bool
    {
        return self::absolutePath($path) !== null;
    }

    /**
     * Support both current disk-backed paths and older public/ paths.
     *
     * @return array<int, string>
     */
    private static function candidatePaths(?string $path): array
    {
        $normalizedPath = self::normalize($path);
        if ($normalizedPath === null) {
            return [];
        }

        $candidates = [$normalizedPath];

        if (str_starts_with($normalizedPath, 'storage/')) {
            $candidates[] = substr($normalizedPath, strlen('storage/'));
        }

        if (str_starts_with($normalizedPath, 'public/')) {
            $candidates[] = substr($normalizedPath, strlen('public/'));
        }

        return array_values(array_unique(array_filter($candidates)));
    }

    private static function normalize(?string $path): ?string
    {
        if (! is_string($path)) {
            return null;
        }

        $normalizedPath = trim(str_replace('\\', '/', $path), '/');

        return $normalizedPath !== '' ? $normalizedPath : null;
    }

    private static function storageUrl(string $path): string
    {
        return '/storage/' . ltrim(str_replace('\\', '/', $path), '/');
    }
}
