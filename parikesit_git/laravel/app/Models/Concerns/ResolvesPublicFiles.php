<?php

namespace App\Models\Concerns;

use App\Support\PublicFile;

trait ResolvesPublicFiles
{
    public function publicFileUrl(string $attribute): ?string
    {
        return PublicFile::url($this->getAttribute($attribute));
    }

    public function publicFilePath(string $attribute): ?string
    {
        return PublicFile::absolutePath($this->getAttribute($attribute));
    }

    public function publicFileExists(string $attribute): bool
    {
        return PublicFile::exists($this->getAttribute($attribute));
    }
}
