<?php

namespace App\Support;

class InputSanitizer
{
    public static function plainText(mixed $value, int $maxLength = 2000): string
    {
        $text = is_scalar($value) ? (string) $value : '';
        $text = html_entity_decode(strip_tags($text), ENT_QUOTES | ENT_HTML5, 'UTF-8');
        $text = preg_replace('/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]/u', '', $text) ?? '';
        $text = preg_replace('/\s+/u', ' ', $text) ?? '';
        $text = trim($text);

        if ($maxLength > 0 && mb_strlen($text) > $maxLength) {
            return mb_substr($text, 0, $maxLength);
        }

        return $text;
    }

    public static function nullablePlainText(mixed $value, int $maxLength = 2000): ?string
    {
        $text = self::plainText($value, $maxLength);

        return $text === '' ? null : $text;
    }

    public static function email(mixed $value): string
    {
        return mb_strtolower(self::plainText($value, 255));
    }

    public static function phone(mixed $value): string
    {
        $phone = preg_replace('/[^0-9+()\-\s]/u', '', self::plainText($value, 0)) ?? '';
        $phone = trim(preg_replace('/\s+/u', ' ', $phone) ?? '');

        return mb_strlen($phone) > 20 ? mb_substr($phone, 0, 20) : $phone;
    }

    public static function nullablePhone(mixed $value): ?string
    {
        $phone = self::phone($value);

        return $phone === '' ? null : $phone;
    }

    public static function safeSearch(mixed $value, int $maxLength = 100): string
    {
        return addcslashes(self::plainText($value, $maxLength), '\\%_');
    }

    public static function sortBy(mixed $value, array $allowed, string $default): string
    {
        $sortBy = is_string($value) ? $value : '';

        return in_array($sortBy, $allowed, true) ? $sortBy : $default;
    }

    public static function sortDirection(mixed $value, string $default = 'desc'): string
    {
        return mb_strtolower((string) $value) === 'asc' ? 'asc' : $default;
    }

    public static function safeIntRange(mixed $value, int $default, int $min, int $max): int
    {
        if (filter_var($value, FILTER_VALIDATE_INT) === false) {
            return $default;
        }

        return max($min, min((int) $value, $max));
    }

    /**
     * @return array<int, int>
     */
    public static function intArray(mixed $value): array
    {
        $items = is_array($value) ? $value : [$value];

        return array_values(array_unique(array_filter(
            array_map(
                static fn (mixed $item): ?int => filter_var($item, FILTER_VALIDATE_INT) === false
                    ? null
                    : (int) $item,
                $items,
            ),
            static fn (?int $item): bool => $item !== null && $item > 0,
        )));
    }
}
