<?php

namespace App\Http\Requests\Concerns;

use App\Support\InputSanitizer;

trait SanitizesInput
{
    /**
     * @param  array<string, int>  $fields
     */
    protected function sanitizePlainTextFields(array $fields): void
    {
        $this->merge($this->sanitizeFields($fields, false));
    }

    /**
     * @param  array<string, int>  $fields
     */
    protected function sanitizeNullablePlainTextFields(array $fields): void
    {
        $this->merge($this->sanitizeFields($fields, true));
    }

    protected function sanitizeEmailField(string $field): void
    {
        if ($this->has($field)) {
            $this->merge([$field => InputSanitizer::email($this->input($field))]);
        }
    }

    protected function sanitizePhoneField(string $field, bool $nullable = false): void
    {
        if ($this->has($field)) {
            $this->merge([
                $field => $nullable
                    ? InputSanitizer::nullablePhone($this->input($field))
                    : InputSanitizer::phone($this->input($field)),
            ]);
        }
    }

    protected function sanitizePlainTextArrayField(string $field, int $maxLength = 255): void
    {
        if (! $this->has($field) || ! is_array($this->input($field))) {
            return;
        }

        $this->merge([
            $field => array_map(
                static fn (mixed $value): string => InputSanitizer::plainText($value, $maxLength),
                $this->input($field),
            ),
        ]);
    }

    /**
     * @param  array<string, int>  $fields
     * @return array<string, string|null>
     */
    private function sanitizeFields(array $fields, bool $nullable): array
    {
        $sanitized = [];

        foreach ($fields as $field => $maxLength) {
            if (! $this->has($field)) {
                continue;
            }

            $sanitized[$field] = $nullable
                ? InputSanitizer::nullablePlainText($this->input($field), $maxLength)
                : InputSanitizer::plainText($this->input($field), $maxLength);
        }

        return $sanitized;
    }
}
