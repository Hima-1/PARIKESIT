<?php

return [
    'domains' => [
        [
            'nama_domain' => 'Domain Prinsip SDI',
            'bobot_domain' => 28.0,
            'aspeks' => [
                [
                    'nama_aspek' => 'Standar Data Statistik',
                    'bobot_aspek' => 25.0,
                    'indikators' => [
                        [
                            'kode_indikator' => '10101',
                            'nama_indikator' => 'Tingkat Kematangan Penerapan Standar Data Statistik (SDS)',
                            'bobot_indikator' => 100.0,
                            'kriteria' => [
                                1 => 'Penerapan Standar Data Statistik (SDS) belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Penerapan Standar Data Statistik (SDS) telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Penerapan Standar Data Statistik (SDS) telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Penerapan Standar Data Statistik (SDS) telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Penerapan Standar Data Statistik (SDS) telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                    ],
                ],
                [
                    'nama_aspek' => 'Metadata Statistik',
                    'bobot_aspek' => 25.0,
                    'indikators' => [
                        [
                            'kode_indikator' => '10201',
                            'nama_indikator' => 'Tingkat Kematangan Penerapan Metadata Statistik',
                            'bobot_indikator' => 100.0,
                            'kriteria' => [
                                1 => 'Penerapan Metadata Statistik belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Penerapan Metadata Statistik telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Penerapan Metadata Statistik telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Penerapan Metadata Statistik telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Penerapan Metadata Statistik telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                    ],
                ],
                [
                    'nama_aspek' => 'Interoperabilitas Data',
                    'bobot_aspek' => 25.0,
                    'indikators' => [
                        [
                            'kode_indikator' => '10301',
                            'nama_indikator' => 'Tingkat Kematangan Penerapan Interoperabilitas Data',
                            'bobot_indikator' => 100.0,
                            'kriteria' => [
                                1 => 'Penerapan Interoperabilitas Data belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Penerapan Interoperabilitas Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Penerapan Interoperabilitas Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Penerapan Interoperabilitas Data telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Penerapan Interoperabilitas Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                    ],
                ],
                [
                    'nama_aspek' => 'Kode Referensi dan/atau Data Induk',
                    'bobot_aspek' => 25.0,
                    'indikators' => [
                        [
                            'kode_indikator' => '10401',
                            'nama_indikator' => 'Tingkat Kematangan Penerapan Kode Referensi',
                            'bobot_indikator' => 100.0,
                            'kriteria' => [
                                1 => 'Penerapan Kode Referensi belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Penerapan Kode Referensi telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Penerapan Kode Referensi telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Penerapan Kode Referensi telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Penerapan Kode Referensi telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                    ],
                ],
            ],
        ],
        [
            'nama_domain' => 'Domain Kualitas Data',
            'bobot_domain' => 24.0,
            'aspeks' => [
                [
                    'nama_aspek' => 'Relevansi',
                    'bobot_aspek' => 21.0,
                    'indikators' => [
                        [
                            'kode_indikator' => '20101',
                            'nama_indikator' => 'Tingkat Kematangan Relevansi Data Terhadap Pengguna',
                            'bobot_indikator' => 60.0,
                            'kriteria' => [
                                1 => 'Relevansi Data terhadap Pengguna belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Relevansi Data terhadap Pengguna telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Relevansi Data terhadap Pengguna telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Relevansi Data terhadap Pengguna telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Relevansi Data terhadap Pengguna telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                        [
                            'kode_indikator' => '20102',
                            'nama_indikator' => 'Tingkat Kematangan Proses Identifikasi Kebutuhan Data',
                            'bobot_indikator' => 40.0,
                            'kriteria' => [
                                1 => 'Proses Identifikasi Kebutuhan Data belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Proses Identifikasi Kebutuhan Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Proses Identifikasi Kebutuhan Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Proses Identifikasi Kebutuhan Data telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Proses Identifikasi Kebutuhan Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                    ],
                ],
                [
                    'nama_aspek' => 'Akurasi',
                    'bobot_aspek' => 16.0,
                    'indikators' => [
                        [
                            'kode_indikator' => '20201',
                            'nama_indikator' => 'Tingkat Kematangan Penilaian Akurasi Data',
                            'bobot_indikator' => 100.0,
                            'kriteria' => [
                                1 => 'Penilaian Akurasi Data belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Penilaian Akurasi Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Penilaian Akurasi Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Penilaian Akurasi Data telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Penilaian Akurasi Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                    ],
                ],
                [
                    'nama_aspek' => 'Aktualitas & Ketepatan Waktu',
                    'bobot_aspek' => 21.0,
                    'indikators' => [
                        [
                            'kode_indikator' => '20301',
                            'nama_indikator' => 'Tingkat Kematangan Penjaminan Aktualitas Data',
                            'bobot_indikator' => 50.0,
                            'kriteria' => [
                                1 => 'Penjaminan Aktualitas Data belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Penjaminan Aktualitas Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Penjaminan Aktualitas Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Penjaminan Aktualitas Data telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Penjaminan Aktualitas Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                        [
                            'kode_indikator' => '20302',
                            'nama_indikator' => 'Tingkat Kematangan Pemantauan Ketepatan Waktu Diseminasi',
                            'bobot_indikator' => 50.0,
                            'kriteria' => [
                                1 => 'Pemantauan Ketepatan Waktu Diseminasi belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Pemantauan Ketepatan Waktu Diseminasi telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Pemantauan Ketepatan Waktu Diseminasi telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Pemantauan Ketepatan Waktu Diseminasi telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Pemantauan Ketepatan Waktu Diseminasi telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                    ],
                ],
                [
                    'nama_aspek' => 'Aksesibilitas',
                    'bobot_aspek' => 21.0,
                    'indikators' => [
                        [
                            'kode_indikator' => '20401',
                            'nama_indikator' => 'Tingkat Kematangan Ketersediaan Data untuk Pengguna Data',
                            'bobot_indikator' => 34.0,
                            'kriteria' => [
                                1 => 'Penjaminan Ketersediaan Data belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Penjaminan Ketersediaan Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Penjaminan Ketersediaan Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Penjaminan Ketersediaan Data telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Penjaminan Ketersediaan Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                        [
                            'kode_indikator' => '20402',
                            'nama_indikator' => 'Tingkat Kematangan Akses Media Penyebarluasan Data',
                            'bobot_indikator' => 33.0,
                            'kriteria' => [
                                1 => 'Penjaminan Akses Media Penyebarluasan Data belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Penjaminan Akses Media Penyebarluasan Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Penjaminan Akses Media Penyebarluasan Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Penjaminan Akses Media Penyebarluasan Data telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Penjaminan Akses Media Penyebarluasan Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                        [
                            'kode_indikator' => '20403',
                            'nama_indikator' => 'Tingkat Kematangan Penyediaan Format Data',
                            'bobot_indikator' => 33.0,
                            'kriteria' => [
                                1 => 'Penjaminan Penyediaan Format Data yang beragam belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Penjaminan Penyediaan Format Data yang beragam telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Penjaminan Penyediaan Format Data yang beragam telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Penjaminan Penyediaan Format Data yang beragam telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Penjaminan Penyediaan Format Data yang beragam telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                    ],
                ],
                [
                    'nama_aspek' => 'Keterbandingan & Konsistensi',
                    'bobot_aspek' => 21.0,
                    'indikators' => [
                        [
                            'kode_indikator' => '20501',
                            'nama_indikator' => 'Tingkat Kematangan Keterbandingan Data',
                            'bobot_indikator' => 50.0,
                            'kriteria' => [
                                1 => 'Penjaminan Keterbandingan Data belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Penjaminan Keterbandingan Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Penjaminan Keterbandingan Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Penjaminan Keterbandingan Data telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Penjaminan Keterbandingan Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                        [
                            'kode_indikator' => '20502',
                            'nama_indikator' => 'Tingkat Kematangan Konsistensi Statistik',
                            'bobot_indikator' => 50.0,
                            'kriteria' => [
                                1 => 'Penjaminan Konsistensi Statistik belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Penjaminan Konsistensi Statistik telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Penjaminan Konsistensi Statistik telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Penjaminan Konsistensi Statistik telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Penjaminan Konsistensi Statistik telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                    ],
                ],
            ],
        ],
        [
            'nama_domain' => 'Domain Proses Bisnis Statistik',
            'bobot_domain' => 19.0,
            'aspeks' => [
                [
                    'nama_aspek' => 'Perencanaan Data',
                    'bobot_aspek' => 32.0,
                    'indikators' => [
                        [
                            'kode_indikator' => '30101',
                            'nama_indikator' => 'Tingkat Kematangan Pendefinisian Kebutuhan Statistik',
                            'bobot_indikator' => 33.0,
                            'kriteria' => [
                                1 => 'Pendefinisian Kebutuhan Statistik belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Pendefinisian Kebutuhan Statistik telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Pendefinisian Kebutuhan Statistik telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Pendefinisian Kebutuhan Statistik telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Pendefinisian Kebutuhan Statistik telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                        [
                            'kode_indikator' => '30102',
                            'nama_indikator' => 'Tingkat Kematangan Desain Statistik',
                            'bobot_indikator' => 33.0,
                            'kriteria' => [
                                1 => 'Penerapan Desain Statistik belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Penerapan Desain Statistik telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Penerapan Desain Statistik telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Penerapan Desain Statistik telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Penerapan Desain Statistik telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                        [
                            'kode_indikator' => '30103',
                            'nama_indikator' => 'Tingkat Kematangan Penyiapan Instrumen',
                            'bobot_indikator' => 34.0,
                            'kriteria' => [
                                1 => 'Penyiapan Instrumen belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Penyiapan Instrumen telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Penyiapan Instrumen telah dilakukan berdasarkan prosedur baku yang telah ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Penyiapan Instrumen telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Penyiapan Instrumen telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                    ],
                ],
                [
                    'nama_aspek' => 'Pengumpulan Data',
                    'bobot_aspek' => 26.0,
                    'indikators' => [
                        [
                            'kode_indikator' => '30201',
                            'nama_indikator' => 'Tingkat Kematangan Proses Pengumpulan Data/Akuisisi Data',
                            'bobot_indikator' => 100.0,
                            'kriteria' => [
                                1 => 'Proses Pengumpulan Data atau Akuisisi Data belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Proses Pengumpulan Data atau Akuisisi Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Proses Pengumpulan Data atau Akuisisi Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Proses Pengumpulan Data atau Akuisisi Data telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Proses Pengumpulan Data atau Akuisisi Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                    ],
                ],
                [
                    'nama_aspek' => 'Pemeriksaan Data',
                    'bobot_aspek' => 21.0,
                    'indikators' => [
                        [
                            'kode_indikator' => '30301',
                            'nama_indikator' => 'Tingkat Kematangan Pengolahan Data',
                            'bobot_indikator' => 50.0,
                            'kriteria' => [
                                1 => 'Pengolahan Data belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Pengolahan Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Pengolahan Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Pengolahan Data telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Pengolahan Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                        [
                            'kode_indikator' => '30302',
                            'nama_indikator' => 'Tingkat Kematangan Analisis Data',
                            'bobot_indikator' => 50.0,
                            'kriteria' => [
                                1 => 'Proses Analisis Data belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Proses Analisis Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Proses Analisis Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Proses Analisis Data telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Proses Analisis Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                    ],
                ],
                [
                    'nama_aspek' => 'Penyebarluasan Data',
                    'bobot_aspek' => 21.0,
                    'indikators' => [
                        [
                            'kode_indikator' => '30401',
                            'nama_indikator' => 'Tingkat Kematangan Diseminasi Data',
                            'bobot_indikator' => 100.0,
                            'kriteria' => [
                                1 => 'Proses Diseminasi Data belum dilakukan oleh Walidata',
                                2 => 'Proses Diseminasi Data telah dilakukan oleh Walidata sesuai standar masing-masing Produsen Data',
                                3 => 'Proses Diseminasi Data telah dilakukan oleh Walidata berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Proses Diseminasi Data telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Proses Diseminasi Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                    ],
                ],
            ],
        ],
        [
            'nama_domain' => 'Domain Kelembagaan',
            'bobot_domain' => 17.0,
            'aspeks' => [
                [
                    'nama_aspek' => 'Profesionalitas',
                    'bobot_aspek' => 35.0,
                    'indikators' => [
                        [
                            'kode_indikator' => '40101',
                            'nama_indikator' => 'Tingkat Kematangan Penjaminan Transparansi Informasi Statistik',
                            'bobot_indikator' => 25.0,
                            'kriteria' => [
                                1 => 'Penjaminan Transparansi Informasi Statistik bagi Pengguna Data belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Penjaminan Transparansi Informasi Statistik bagi Pengguna Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Penjaminan Transparansi Informasi Statistik bagi Pengguna Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Penjaminan Transparansi Informasi Statistik bagi Pengguna Data telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Penjaminan Transparansi Informasi Statistik bagi Pengguna Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                        [
                            'kode_indikator' => '40102',
                            'nama_indikator' => 'Tingkat Kematangan Penjaminan Netralitas dan Obyektivitas terhadap Penggunaan Sumber Data dan Metodologi',
                            'bobot_indikator' => 25.0,
                            'kriteria' => [
                                1 => 'Penjaminan Netralitas dan Obyektivitas terhadap Penggunaan Sumber Data dan Metodologi belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Penjaminan Netralitas dan Obyektivitas terhadap Penggunaan Sumber Data dan Metodologi telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Penjaminan Netralitas dan Obyektivitas terhadap Penggunaan Sumber Data dan Metodologi telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Penjaminan Netralitas dan Obyektivitas terhadap Penggunaan Sumber Data dan Metodologi telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Penjaminan Netralitas dan Obyektivitas terhadap Penggunaan Sumber Data dan Metodologi telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                        [
                            'kode_indikator' => '40103',
                            'nama_indikator' => 'Tingkat Kematangan Penjaminan Kualitas Data',
                            'bobot_indikator' => 25.0,
                            'kriteria' => [
                                1 => 'Penjaminan Kualitas Data belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Penjaminan Kualitas Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Penjaminan Kualitas Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Penjaminan Kualitas Data telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Penjaminan Kualitas Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                        [
                            'kode_indikator' => '40104',
                            'nama_indikator' => 'Tingkat Kematangan Penjaminan Konfidensialitas Data',
                            'bobot_indikator' => 25.0,
                            'kriteria' => [
                                1 => 'Penjaminan Konfidensialitas Data belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Penjaminan Konfidensialitas Data telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Penjaminan Konfidensialitas Data telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Penjaminan Konfidensialitas Data telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Penjaminan Konfidensialitas Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                    ],
                ],
                [
                    'nama_aspek' => 'SDM yang Memadai dan Kapabel',
                    'bobot_aspek' => 30.0,
                    'indikators' => [
                        [
                            'kode_indikator' => '40201',
                            'nama_indikator' => 'Tingkat Kematangan Penerapan Kompetensi Sumber Daya Manusia Bidang Statistik',
                            'bobot_indikator' => 50.0,
                            'kriteria' => [
                                1 => 'Pemenuhan Kompetensi Sumber Daya Manusia Bidang Statistik belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Pemenuhan Kompetensi Sumber Daya Manusia Bidang Statistik telah dilakukan oleh setiap Produsen Data sesuai dengan perencanaan',
                                3 => 'Pemenuhan Kompetensi Sumber Daya Manusia Bidang Statistik telah dilakukan seluruhnya yaitu kompetensi di bidang proses bisnis penyelenggaraan Statistik Sektoral',
                                4 => 'Pemenuhan Kompetensi Sumber Daya Manusia Bidang Statistik telah dilakukan peningkatan, penilaian, reviu, dan evaluasi secara berkala',
                                5 => 'Pemenuhan Kompetensi Sumber Daya Manusia Bidang Statistik telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                        [
                            'kode_indikator' => '40202',
                            'nama_indikator' => 'Tingkat Kematangan Penerapan Kompetensi Sumber Daya Manusia Bidang Manajemen Data',
                            'bobot_indikator' => 50.0,
                            'kriteria' => [
                                1 => 'Pemenuhan Kompetensi Sumber Daya Manusia Bidang Manajemen Data belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Pemenuhan Kompetensi Sumber Daya Manusia Bidang Manajemen Data telah dilakukan oleh setiap Produsen Data sesuai dengan perencanaan',
                                3 => 'Pemenuhan Kompetensi Sumber Daya Manusia Bidang Manajemen Data telah dilakukan seluruhnya yaitu kompetensi di bidang proses bisnis penyelenggaraan Statistik Sektoral',
                                4 => 'Pemenuhan Kompetensi Sumber Daya Manusia Bidang Manajemen Data telah dilakukan peningkatan, penilaian, reviu, dan evaluasi secara berkala',
                                5 => 'Pemenuhan Kompetensi Sumber Daya Manusia Bidang Manajemen Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                    ],
                ],
                [
                    'nama_aspek' => 'Pengorganisasian Statistik',
                    'bobot_aspek' => 35.0,
                    'indikators' => [
                        [
                            'kode_indikator' => '40301',
                            'nama_indikator' => 'Tingkat Kematangan Kolaborasi Penyelenggaraan Kegiatan Statistik',
                            'bobot_indikator' => 25.0,
                            'kriteria' => [
                                1 => 'Kolaborasi antar unit kerja/perangkat daerah di Instansi Pusat/Pemerintahan Daerah dalam penyelenggaraan kegiatan statistik belum dilaksanakan',
                                2 => 'Kolaborasi antar unit kerja/perangkat daerah di Instansi Pusat/Pemerintahan Daerah dalam penyelenggaraan kegiatan statistik telah dilaksanakan',
                                3 => 'Kolaborasi antar unit kerja/perangkat daerah di Instansi Pusat/Pemerintahan Daerah dalam penyelenggaraan kegiatan statistik telah dilaksanakan oleh tim yang dibentuk secara formal',
                                4 => 'Kolaborasi antar unit kerja/perangkat daerah di Instansi Pusat/Pemerintahan Daerah dalam penyelenggaraan kegiatan statistik telah dikoordinasikan oleh menteri/kepala lembaga/kepala daerah serta dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Kolaborasi antar unit kerja/perangkat daerah di Instansi Pusat/Pemerintahan Daerah dalam penyelenggaraan kegiatan statistik telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                        [
                            'kode_indikator' => '40302',
                            'nama_indikator' => 'Tingkat Kematangan Penyelenggaraan Forum Satu Data Indonesia',
                            'bobot_indikator' => 25.0,
                            'kriteria' => [
                                1 => 'Walidata/Walidata pendukung belum terlibat dalam Forum Satu Data Indonesia',
                                2 => 'Walidata/Walidata pendukung telah terlibat dalam Forum Satu Data Indonesia sesuai dengan rencana aksi Forum Satu Data Indonesia',
                                3 => 'Walidata/Walidata pendukung telah melaksanakan rencana aksi yang ditetapkan/disepakati dalam Forum Satu Data Indonesia',
                                4 => 'Walidata/Walidata pendukung telah melaksanakan rencana aksi yang ditetapkan/disepakati dalam Forum Satu Data Indonesia dan berkolaborasi dengan Walidata lain atau Pembina Data Statistik',
                                5 => 'Walidata/Walidata pendukung telah menindaklanjuti hasil reviu dan evaluasi',
                            ],
                        ],
                        [
                            'kode_indikator' => '40303',
                            'nama_indikator' => 'Tingkat Kematangan Kolaborasi dengan Pembina Data Statistik',
                            'bobot_indikator' => 25.0,
                            'kriteria' => [
                                1 => 'Kolaborasi pembangunan/pengembangan data dengan Pembina Data Statistik belum dilakukan',
                                2 => 'Kolaborasi pembangunan/pengembangan data dengan Pembina Data Statistik telah dilakukan secara informal',
                                3 => 'Kolaborasi pembangunan/pengembangan data dengan Pembina Data Statistik telah dilakukan secara formal',
                                4 => 'Kolaborasi pembangunan/pengembangan data dengan Pembina Data Statistik telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Kolaborasi pembangunan/pengembangan data dengan Pembina Data Statistik telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                        [
                            'kode_indikator' => '40304',
                            'nama_indikator' => 'Tingkat Kematangan Pelaksanaan Tugas sebagai Walidata',
                            'bobot_indikator' => 25.0,
                            'kriteria' => [
                                1 => 'Walidata belum ditetapkan',
                                2 => 'Tugas/program kerja Walidata belum dilakukan seluruhnya',
                                3 => 'Tugas/program kerja Walidata telah dilakukan seluruhnya',
                                4 => 'Tugas/program kerja Walidata telah dilakukan secara terpadu dengan seluruh Produsen Data yang dikoordinasikan dalam Forum SDI tingkat pusat/daerah, serta telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Tugas/program kerja Walidata telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                    ],
                ],
            ],
        ],
        [
            'nama_domain' => 'Domain Statistik Nasional',
            'bobot_domain' => 12.0,
            'aspeks' => [
                [
                    'nama_aspek' => 'Pemanfaatan Data Statistik',
                    'bobot_aspek' => 34.0,
                    'indikators' => [
                        [
                            'kode_indikator' => '50101',
                            'nama_indikator' => 'Tingkat Kematangan Penggunaan Data Statistik Dasar untuk Perencanaan, Monitoring, Evaluasi, dan/atau Penyusunan Kebijakan',
                            'bobot_indikator' => 34.0,
                            'kriteria' => [
                                1 => 'Penggunaan Data Statistik Dasar untuk Perencanaan, Monitoring, Evaluasi, dan/atau Penyusunan Kebijakan belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Penggunaan Data Statistik Dasar untuk Perencanaan, Monitoring, Evaluasi, dan/atau Penyusunan Kebijakan telah dilakukan oleh setiap Produsen Data sesuai kepentingannya masing-masing',
                                3 => 'Penggunaan Data Statistik Dasar untuk Perencanaan, Monitoring, Evaluasi, dan/atau Penyusunan Kebijakan telah dilakukan oleh Produsen Data bersama Walidata sesuai kepentingan Instansi Pusat/Pemerintahan Daerah',
                                4 => 'Penggunaan Data Statistik Dasar untuk Perencanaan, Monitoring, Evaluasi, dan/atau Penyusunan Kebijakan telah dilakukan oleh Produsen Data bersama Walidata untuk kepentingan Instansi Pusat/Pemerintahan Daerah/Nasional, telah dilakukan koordinasi/konsultasi dengan Pembina Data Statistik, serta telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Penggunaan Data Statistik Dasar untuk Perencanaan, Monitoring, Evaluasi, dan/atau Penyusunan Kebijakan telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                        [
                            'kode_indikator' => '50102',
                            'nama_indikator' => 'Tingkat Kematangan Penggunaan Data Statistik Sektoral untuk Perencanaan, Monitoring, Evaluasi, dan/atau Penyusunan Kebijakan',
                            'bobot_indikator' => 33.0,
                            'kriteria' => [
                                1 => 'Penggunaan Data Statistik Sektoral untuk Perencanaan, Monitoring, Evaluasi, dan/atau Penyusunan Kebijakan belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Penggunaan Data Statistik Sektoral untuk Perencanaan, Monitoring, Evaluasi, dan/atau Penyusunan Kebijakan telah dilakukan oleh setiap Produsen Data sesuai kepentingannya masing-masing',
                                3 => 'Penggunaan Data Statistik Sektoral untuk Perencanaan, Monitoring, Evaluasi, dan/atau Penyusunan Kebijakan telah dilakukan oleh Produsen Data bersama Walidata sesuai kepentingan Instansi Pusat/Pemerintahan Daerah',
                                4 => 'Penggunaan Data Statistik Sektoral untuk Perencanaan, Monitoring, dan Evaluasi, dan/atau Penyusunan Kebijakan telah dilakukan oleh Produsen Data bersama Walidata untuk kepentingan Instansi Pusat/Pemerintahan Daerah/Nasional, telah dilakukan koordinasi/konsultasi/rekomendasi dari Pembina Data Statistik, serta telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Penggunaan Data Statistik Sektoral untuk Perencanaan, Monitoring, Evaluasi, dan/atau Penyusunan Kebijakan telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                        [
                            'kode_indikator' => '50103',
                            'nama_indikator' => 'Tingkat Kematangan Sosialisasi dan Literasi Data Statistik',
                            'bobot_indikator' => 33.0,
                            'kriteria' => [
                                1 => 'Sosialisasi Data Statistik kepada publik belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Sosialisasi Data Statistik kepada publik telah dilakukan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Sosialisasi Data Statistik kepada publik yang telah dilakukan berdasarkan prosedur baku yang ditetapkan dan berlaku untuk seluruh Produsen Data',
                                4 => 'Sosialisasi Data Statistik kepada publik telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Sosialisasi Data Statistik kepada publik telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                    ],
                ],
                [
                    'nama_aspek' => 'Pengelolaan Kegiatan Statistik',
                    'bobot_aspek' => 33.0,
                    'indikators' => [
                        [
                            'kode_indikator' => '50201',
                            'nama_indikator' => 'Tingkat Kematangan Pelaksanaan Rekomendasi Kegiatan Statistik',
                            'bobot_indikator' => 100.0,
                            'kriteria' => [
                                1 => 'Pemberitahuan rancangan kegiatan statistik ke BPS belum dilaksanakan oleh seluruh Produsen Data',
                                2 => 'Pemberitahuan rancangan kegiatan statistik ke BPS telah dilaksanakan oleh setiap Produsen Data sesuai standarnya masing-masing',
                                3 => 'Pemberitahuan rancangan kegiatan statistik ke BPS telah dilaksanakan berdasarkan prosedur baku yang ditetapkan, berlaku untuk seluruh Produsen Data, telah dikoordinasikan oleh Walidata, serta telah menerima rekomendasi dari BPS',
                                4 => 'Pelaksanaan Rekomendasi Kegiatan Statistik telah dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Pelaksanaan Rekomendasi Kegiatan Statistik telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                    ],
                ],
                [
                    'nama_aspek' => 'Penguatan SSN Berkelanjutan',
                    'bobot_aspek' => 33.0,
                    'indikators' => [
                        [
                            'kode_indikator' => '50301',
                            'nama_indikator' => 'Tingkat Kematangan Perencanaan Pembangunan Statistik',
                            'bobot_indikator' => 33.0,
                            'kriteria' => [
                                1 => 'Perencanaan Pembangunan Statistik di Instansi Pusat/Pemerintahan Daerah belum disusun',
                                2 => 'Perencanaan Pembangunan Statistik di Instansi Pusat/Pemerintahan Daerah telah disusun dan ditetapkan',
                                3 => 'Perencanaan Pembangunan Statistik di Instansi Pusat/Pemerintahan Daerah telah dilaksanakan',
                                4 => 'Perencanaan Pembangunan Statistik di Instansi Pusat/Pemerintahan Daerah telah dilakukan reviu serta evaluasi bersama Pembina Data Statistik',
                                5 => 'Perencanaan Pembangunan Statistik di Instansi Pusat/Pemerintahan Daerah telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                        [
                            'kode_indikator' => '50302',
                            'nama_indikator' => 'Tingkat Kematangan Penyebarluasan Data',
                            'bobot_indikator' => 33.0,
                            'kriteria' => [
                                1 => 'Penyebarluasan Data belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Penyebarluasan Data dilakukan oleh setiap Produsen Data untuk kepentingan masing-masing',
                                3 => 'Penyebarluasan Data telah dilakukan oleh Walidata untuk kepentingan Instansi Pusat/Pemerintahan Daerah',
                                4 => 'Penyebarluasan Data telah dilakukan oleh Walidata melalui pusat rujukan informasi statistik, portal Satu Data Indonesia, Jaringan Informasi Geospasial Nasional dan/atau Sistem Big Data Pemerintah serta dilakukan reviu dan evaluasi secara berkala',
                                5 => 'Penyebarluasan Data telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                        [
                            'kode_indikator' => '50303',
                            'nama_indikator' => 'Tingkat Kematangan Pemanfaatan Big Data',
                            'bobot_indikator' => 34.0,
                            'kriteria' => [
                                1 => 'Pemanfaatan Big Data dalam kegiatan Statistik belum dilakukan oleh seluruh Produsen Data',
                                2 => 'Pemanfaatan Big Data dalam kegiatan Statistik telah dilakukan oleh setiap Produsen Data atau Walidata dalam bentuk kajian dan eksperimen',
                                3 => 'Pemanfaatan Big Data dalam kegiatan Statistik telah dilakukan oleh Produsen Data atau Walidata untuk menghasilkan data statistik pendukung',
                                4 => 'Pemanfaatan Big Data dalam kegiatan Statistik telah dilakukan reviu dan evaluasi secara berkala bersama Pembina Data Statistik',
                                5 => 'Pemanfaatan Big Data dalam kegiatan Statistik telah dilakukan pemutakhiran dalam rangka peningkatan kualitas',
                            ],
                        ],
                    ],
                ],
            ],
        ],
    ],
];
