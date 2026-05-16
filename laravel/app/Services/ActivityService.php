<?php

namespace App\Services;

use App\Support\PublicFile;
use App\Support\UploadSecurity;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use RuntimeException;
use ZipArchive;

class ActivityService
{
    private const MAIN_FILE_FIELDS = [
        'bukti_dukung_undangan',
        'daftar_hadir',
        'materi',
        'notula',
    ];

    private const MAIN_FILE_NAMES = [
        'bukti_dukung_undangan' => 'Bukti Dukung Undangan.pdf',
        'daftar_hadir' => 'Daftar Hadir.pdf',
        'materi' => 'Materi.pdf',
        'notula' => 'Notula.pdf',
    ];

    /**
     * Handle common file uploads for activities
     */
    public function handleFileUploads($request, $basePath, $slug, $existingData = null)
    {
        $data = [];
        $disk = Storage::disk('public');
        $suffix = $this->suffixFromBasePath($basePath);
        $uploadedPaths = [];
        $oldPathsToDelete = [];

        try {
            foreach (self::MAIN_FILE_FIELDS as $field) {
                $fieldKey = $this->fieldKey($field, $suffix);
                $file = $request->file($fieldKey) ?? $request->file($field);

                if ($file) {
                    UploadSecurity::validate($file, ['pdf'], $fieldKey);

                    $existingPath = $existingData[$fieldKey] ?? ($existingData[$field] ?? null);
                    $filSaved = $this->uniqueStoredFileName($field, $file);
                    $path = $basePath.'/'.$slug;
                    $storedPath = $disk->putFileAs($path, $file, $filSaved);

                    if ($storedPath === false) {
                        throw new RuntimeException("Failed to store uploaded file for {$fieldKey}");
                    }

                    $data[$fieldKey] = $basePath.'/'.$slug.'/'.$filSaved;
                    $uploadedPaths[] = $data[$fieldKey];

                    if ($existingPath && $existingPath !== $data[$fieldKey]) {
                        $oldPathsToDelete[] = $existingPath;
                    }
                } else {
                    $data[$fieldKey] = $existingData[$fieldKey] ?? ($existingData[$field] ?? null);
                }
            }
        } catch (\Throwable $exception) {
            foreach ($uploadedPaths as $path) {
                if ($disk->exists($path)) {
                    $disk->delete($path);
                }
            }

            throw $exception;
        }

        foreach (array_unique($oldPathsToDelete) as $path) {
            if ($disk->exists($path)) {
                $disk->delete($path);
            }
        }

        return $data;
    }

    /**
     * Handle additional media files (files[] array)
     */
    public function handleMediaUploads($model, $request, $basePath, $slug, $relationName)
    {
        $files = $this->normalizeFiles($request->file('files'));

        if ($files === []) {
            return;
        }

        $disk = Storage::disk('public');
        $path = $basePath.'/'.$slug.'/media';

        foreach ($files as $index => $file) {
            if (! $file) {
                continue;
            }

            UploadSecurity::validate($file, ['jpeg', 'png', 'jpg', 'gif', 'mp4', 'mp3', 'avi', 'flv'], 'files.'.$index);

            $filSaved = $this->uniqueStoredFileName('media-'.$index, $file);
            $fileext = UploadSecurity::safeExtension($file);
            $storedPath = $disk->putFileAs($path, $file, $filSaved);

            if ($storedPath === false) {
                throw new RuntimeException("Failed to store uploaded media file at index {$index}");
            }

            $model->$relationName()->create([
                'nama_file' => $basePath.'/'.$slug.'/media/'.$filSaved,
                'tipe_file' => $fileext,
            ]);
        }
    }

    /**
     * Generate ZIP for activity downloads
     */
    public function generateZip($activity, $title, $type)
    {
        $zipFileName = $this->zipFileName(Str::slug($title), $type);
        $zip = new ZipArchive;
        $disk = Storage::disk('public');

        $zipFolder = $type.'-zip';
        if (! $disk->exists($zipFolder)) {
            $disk->makeDirectory($zipFolder);
        }

        $zipPath = $disk->path($zipFolder.'/'.$zipFileName);
        $addedFiles = 0;
        $missingFiles = [];

        $openResult = $zip->open($zipPath, ZipArchive::CREATE | ZipArchive::OVERWRITE);
        if ($openResult !== true) {
            \Log::error("ZipArchive failed to open at {$zipPath} with error code: {$openResult}");

            return false;
        }

        foreach ($this->activityFiles($activity, $type) as $zipName => $filePath) {
            $absolutePath = PublicFile::absolutePath($filePath);
            if ($filePath && $absolutePath) {
                $zip->addFile($absolutePath, $zipName);
                $addedFiles++;
            } elseif ($filePath) {
                $missingFiles[] = $filePath;
            }
        }

        $mediaFolder = 'Media/';
        $zip->addEmptyDir($mediaFolder);

        foreach ($this->activityMediaFiles($activity, $type) as $zipName => $mediaPath) {
            $absolutePath = PublicFile::absolutePath($mediaPath);
            if ($absolutePath) {
                $zip->addFile($absolutePath, $mediaFolder.$zipName);
                $addedFiles++;
            } else {
                $missingFiles[] = $mediaPath;
            }
        }

        $zip->close();

        \Log::info('Activity zip generated', [
            'type' => $type,
            'activity_id' => $activity->id ?? null,
            'zip_path' => $zipPath,
            'zip_name' => $zipFileName,
            'added_files' => $addedFiles,
            'missing_files_count' => count($missingFiles),
            'missing_files' => $missingFiles,
            'zip_size' => file_exists($zipPath) ? filesize($zipPath) : null,
        ]);

        return ['path' => $zipPath, 'name' => $zipFileName];
    }

    /**
     * Generate batch ZIP for multiple activities
     */
    public function generateBatchZip($activities, $type)
    {
        if ($activities->isEmpty()) {
            return false;
        }

        $zipFileName = $this->zipFileName('batch', $type);
        $zip = new ZipArchive;
        $disk = Storage::disk('public');

        $zipFolder = 'batch-'.$type.'-zip';
        if (! $disk->exists($zipFolder)) {
            $disk->makeDirectory($zipFolder);
        }

        $zipPath = $disk->path($zipFolder.'/'.$zipFileName);

        if ($zip->open($zipPath, ZipArchive::CREATE | ZipArchive::OVERWRITE) !== true) {
            return false;
        }

        foreach ($activities as $activity) {
            $folderName = Str::slug($this->activityTitle($activity, $type) ?: 'activity-'.$activity->id).'/';
            $zip->addEmptyDir($folderName);

            foreach ($this->activityFiles($activity, $type) as $zipName => $filePath) {
                $absolutePath = PublicFile::absolutePath($filePath);
                if ($filePath && $absolutePath) {
                    $zip->addFile($absolutePath, $folderName.$zipName);
                }
            }

            $mediaFolder = $folderName.'Media/';
            $zip->addEmptyDir($mediaFolder);

            foreach ($this->activityMediaFiles($activity, $type) as $zipName => $mediaPath) {
                $absolutePath = PublicFile::absolutePath($mediaPath);
                if ($absolutePath) {
                    $zip->addFile($absolutePath, $mediaFolder.$zipName);
                }
            }
        }

        $zip->close();

        return ['path' => $zipPath, 'name' => $zipFileName];
    }

    private function suffixFromBasePath(string $basePath): string
    {
        return str_contains($basePath, '-')
            ? explode('-', $basePath)[1]
            : '';
    }

    private function fieldKey(string $field, string $suffix): string
    {
        return $suffix === '' ? $field : $field.'_'.$suffix;
    }

    private function normalizeFiles(mixed $files): array
    {
        if (! $files) {
            return [];
        }

        return is_array($files) ? $files : [$files];
    }

    private function activityFiles($activity, string $type): array
    {
        $files = [];

        foreach (self::MAIN_FILE_NAMES as $fieldBase => $fileName) {
            $fieldWithSuffix = $fieldBase.'_'.$type;
            $files[$fileName] = $activity->$fieldWithSuffix ?? $activity->$fieldBase;
        }

        return $files;
    }

    private function activityMediaFiles($activity, string $type): array
    {
        $files = [];
        $relation = $this->mediaRelationName($activity, $type);

        if (! isset($activity->$relation)) {
            return $files;
        }

        foreach ($activity->$relation as $index => $media) {
            $mediaPath = $media->nama_file;
            $files[($index + 1).'.'.pathinfo($mediaPath, PATHINFO_EXTENSION)] = $mediaPath;
        }

        return $files;
    }

    private function mediaRelationName($activity, string $type): string
    {
        $relation = 'file_'.$type;

        return method_exists($activity, $relation) ? $relation : 'file_media';
    }

    private function activityTitle($activity, string $type): ?string
    {
        if ($type === 'pembinaan') {
            return $activity->judul_pembinaan ?? $activity->judul;
        }

        return $activity->judul_dokumentasi ?? $activity->judul;
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
