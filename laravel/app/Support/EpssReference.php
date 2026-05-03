<?php

namespace App\Support;

class EpssReference
{
    /**
     * @return array<int, array<string, mixed>>
     */
    public static function domains(): array
    {
        $domains = config('epss.domains');

        return is_array($domains) ? $domains : [];
    }

    /**
     * @return array<string, array<string, mixed>>
     */
    public static function indicatorsByCode(): array
    {
        $result = [];

        foreach (self::domains() as $domain) {
            foreach (($domain['aspeks'] ?? []) as $aspek) {
                foreach (($aspek['indikators'] ?? []) as $indikator) {
                    $code = (string) ($indikator['kode_indikator'] ?? '');
                    if ($code === '') {
                        continue;
                    }

                    $result[$code] = [
                        'nama_domain' => $domain['nama_domain'],
                        'bobot_domain' => $domain['bobot_domain'],
                        'nama_aspek' => $aspek['nama_aspek'],
                        'bobot_aspek' => $aspek['bobot_aspek'],
                        'kode_indikator' => $code,
                        'nama_indikator' => $indikator['nama_indikator'],
                        'bobot_indikator' => $indikator['bobot_indikator'],
                        'kriteria' => $indikator['kriteria'] ?? [],
                    ];
                }
            }
        }

        return $result;
    }

    /**
     * @return array<string, mixed>|null
     */
    public static function indicatorByCode(string $kodeIndikator): ?array
    {
        return self::indicatorsByCode()[$kodeIndikator] ?? null;
    }
}
