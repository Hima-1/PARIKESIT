<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Admin
        User::updateOrCreate(
            ['email' => 'admin@gmail.com'],
            [
                'name' => 'Admin',
                'password' => bcrypt('password'),
                'role' => 'admin',
                'alamat' => 'Kabupaten Klaten',
                'nomor_telepon' => '081234567890',
            ]
        );

        // OPD/Produsen Data - 18 Dinas
        $dinas = [
            [
                'name' => 'Inspektorat Daerah',
                'email' => 'inspektorat@klaten.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'Sekretariat Dewan Perwakilan Rakyat Daerah',
                'email' => 'sekretariatad77@gmail.com',
                'password' => 'password',
            ],
            [
                'name' => 'Dinas Pemberdayaan Masyarakat dan Desa',
                'email' => 'dispermasdes@klaten.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'Dinas Pendidikan',
                'email' => 'klatendisdik@gmail.com',
                'password' => 'password',
            ],
            [
                'name' => 'Dinas Kebudayaan, Kepemudaan, Olahraga dan Pariwisata',
                'email' => 'disbudporapar@klaten.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'Dinas Kesehatan',
                'email' => 'dinas.kesehatan@klaten.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'Dissos P3APPKB',
                'email' => 'dinsosp3akb.klaten@gmail.com',
                'password' => 'password',
            ],
            [
                'name' => 'Dinas Kependudukan dan Pencatatan Sipil',
                'email' => 'disdukcapil@klaten.g.id',
                'password' => 'password',
            ],
            [
                'name' => 'Dinas Penanaman Modal dan Pelayanan Terpadu Satu Pintu',
                'email' => 'dpmptsp@klaten.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'Dinas Koperasi, Usaha Kecil Menengah dan Perdagangan',
                'email' => 'dkukmp@klaten.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'Dinas Perindustrian dan Tenaga Kerja',
                'email' => 'disperinaker@klaten.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'Dinas Perumahan Rakyat dan Kawasan Permukiman',
                'email' => 'disperakim@klaten.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'Dinas Pekerjaan Umum dan Penataan Ruang',
                'email' => 'dpupr@klaten.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'Dinas Perhubungan',
                'email' => 'dinas.perhubungan@klaten.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'Dinas Lingkungan Hidup',
                'email' => 'dinas.lh@klaten.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'Dinas Ketahanan Pangan dan Pertanian',
                'email' => 'dispertanklaten@gmail.com',
                'password' => 'password',
            ],
            [
                'name' => 'Dinas Perpustakaan dan Kearsipan',
                'email' => 'dispersip@klaten.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'Satuan Polisi Pamong Praja dan Pemadan Kebakaran',
                'email' => 'satpol.pp.klaten@gmail.com',
                'password' => 'password',
            ],
            [
                'name' => 'Badan Kepegawaian dan Pengembangan Sumber Daya Manusia',
                'email' => 'bkpsdm@klaten.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'Badan Pengelolaan Keuangan, Pendapatan dan Aset Daerah',
                'email' => 'bpkpad@klaten.gi.id',
                'password' => 'password',
            ],
            [
                'name' => 'Badan Perencanaan Pembangunan, Riset, dan Inovasi Daerah',
                'email' => 'bapperida@klaten.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'Badan Kesatuan Bangsa dan Politik',
                'email' => 'kesbangpolklaten@gmail.com',
                'password' => 'password',
            ],
            [
                'name' => 'Badan Penanggulangan Bencana Daerah',
                'email' => 'bpbd@klaten.go.id',
                'password' => 'password',
            ],
        ];

        foreach ($dinas as $d) {
            User::updateOrCreate(
                ['email' => $d['email']],
                [
                    'name' => $d['name'],
                    'password' => bcrypt($d['password']),
                    'role' => 'opd',
                    'alamat' => 'Kabupaten Klaten, Jawa Tengah',
                    'nomor_telepon' => '-',
                ]
            );
        }

        // Walidata
        User::updateOrCreate(
            ['email' => 'diskominfo@klaten.go.id'],
            [
                'name' => 'Dinas Komunikasi dan Informatika',
                'password' => bcrypt('password'),
                'role' => 'walidata',
                'alamat' => 'Kabupaten Klaten, Jawa Tengah',
                'nomor_telepon' => '-',
            ]
        );

        // Pembina Data (BPS) - Role: Admin
        $pembina_data = [
            [
                'name' => 'ADI TEGUH WIYONO, SST',
                'email' => 'adi.wiyono@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'ALFIAH YUNI ASTUTI, SST',
                'email' => 'alfiah@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'ANDHIKA RAHMADANI, SST',
                'email' => 'andhikarahm@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'ANDIRA IKA NUGRAHENI, SST',
                'email' => 'andira.nugraheni@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'BANGKIT SASETIA UTAMA',
                'email' => 'bangkit.utama@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'BASUKI HARIS SUKARNO',
                'email' => 'basukiharis@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'Cahyo Kristiono, SST., M.Stat',
                'email' => 'ckris@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'EKO DWI PUDJIANA',
                'email' => 'eko.dwip@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'EKO PUJIYANTO, SE',
                'email' => 'eko.pujiyanto@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'EMA YULANDIKA SETYANING P., SST',
                'email' => 'emayulandika@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'EVAN SAKTI HERAWAN, A.Md',
                'email' => 'evanherawan@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'FARIDA NURKHAYYATI, SST., M.Ec.Dev',
                'email' => 'faridanur@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'Ir. ANDHIKASARI KUSHARDATI',
                'email' => 'andhika@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'Ir. EFIYANTI PUSPITORINI',
                'email' => 'efiyanti@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'Ir. SUDARMADI, M.Si',
                'email' => 'sudarmadi2@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'Ir. SUPARYANTO',
                'email' => 'paryanto@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'IRWAN, S.Si., MA.',
                'email' => 'irwan2@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'ISWADI',
                'email' => 'iswadi@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'LARA AYU CAHYANINGTYAS, S.Tr.Stat.',
                'email' => 'laraayu@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'LATIF EFENDI',
                'email' => 'latif.effendi@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'LATIFAH ANDRIANI, SST',
                'email' => 'latifah.andriani@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'M. SALAMUDIN',
                'email' => 'salamudin@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'MASKANATUL MAULIDA, A.Md.Stat',
                'email' => 'maskanatul.maulida@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'MIDDIA MARTANTI DEWI, SST., M.Sc.',
                'email' => 'middia@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'MUHAMMAD ANIES MIZFAR, SST',
                'email' => 'muhammad.mizfar@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'MURDIYANTO, SE',
                'email' => 'murdiyanto@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'NUR HIDAYAH, S.Si',
                'email' => 'nur.hidayah@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'NURUL KHASNAH, A.Md',
                'email' => 'nurulasa@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'NUUR RAFI WISMAMIEN, S.Si',
                'email' => 'nurafi@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'PRASETIYO NUGROHO, SST',
                'email' => 'pras.nugroho@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'PULUNG JATI SUDARMINTO, S.Si',
                'email' => 'pulung.jati@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'RIFKY YUDHA ARDHANA, STrStat',
                'email' => 'rifky.yudha@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'ROHMAN WIDODO, SE',
                'email' => 'rohman.widodo@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'SITI AMALIA, A.Md',
                'email' => 'siti.amalia@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'SITI BADRIYAH, SE',
                'email' => 'siti.badriyah@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'SLAMET WIDODO',
                'email' => 'slamet.widodo@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'STEFANUS RIAN ALDESKA',
                'email' => 'aldeska@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'SUNARDI, SST., M.Si.',
                'email' => 'nardi@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'SUSI PEBRIANA, A.Md',
                'email' => 'susi.pebriana@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'TAFIANINGSIH, A.Md',
                'email' => 'tafianingsih@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'TATIK RUWIYANTI, A.Md',
                'email' => 'tatik_ruwiyati@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'TYAS JUALITA SANTY, SST, M.E.K.K',
                'email' => 'tyasjualita@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'UNTUNG KURNIAWAN, SST., M.Si',
                'email' => 'untungk@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'WAHYU DEWI WIDYANTI, S.Si',
                'email' => 'dewi.widyanti@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'WAHYUNI SETYORINI, A.Md',
                'email' => 'wahyuni.setyorini@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'WISNU TRI WARDOYO',
                'email' => 'wisnu.wardoyo@bps.go.id',
                'password' => 'password',
            ],
            [
                'name' => 'WORO INDAH PALUPI',
                'email' => 'woro.indah@bps.go.id',
                'password' => 'password',
            ],
        ];

        foreach ($pembina_data as $pembina) {
            User::updateOrCreate(
                ['email' => $pembina['email']],
                [
                    'name' => $pembina['name'],
                    'password' => bcrypt($pembina['password']),
                    'role' => 'admin', // Pembina Data = Admin
                    'alamat' => 'BPS Kabupaten Klaten',
                    'nomor_telepon' => '-',
                ]
            );
        }
    }
}
