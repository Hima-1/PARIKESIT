    @extends('dashboard.layout')
    @section('title', 'Detail Kegiatan')

    @section('content')
        <nav class="bg-white p-4 border-2 rounded-md w-full mb-4">
            <ol class="list-reset flex text-grey-dark">

                <li><a href="{{ route('disposisi.penilaian.tersedia') }}" class="text-blue-600 hover:underline">Koreksi Penilaian</a></li>
                <li><span class="mx-2">&gt;</span></li>
                <li class="text-gray-700"> <a href="{{ route('disposisi.penilaian.tersedia.detail', [$formulir->nama_formulir]) }}"
                        class="text-blue-600 hover:underline">Kegiatan Selesai : {{ $formulir->nama_formulir }} </a> </li>
                <li><span class="mx-2">&gt;</span></li>


            </ol>
        </nav>
        <div>
            <div class="bg-white border border-indigo-400 shadow-sm rounded-lg">
                <!-- Header -->
                <div class="p-6 pb-4 border-b border-gray-200">
                    <div class="flex justify-between items-start">
                        <div>
                            <h1 class="text-2xl font-bold text-gray-800 mb-2">
                                Detail Kegiatan {{ $formulir->nama_formulir ?? 'perbaru' }}
                            </h1>
                            {{-- <p class="text-gray-600">
                                Berikut adalah daftar OPD yang sudah melakukan penilaian
                            </p> --}}
                        </div>
                        {{-- <button
                            class="px-4 py-2 border border-gray-300 rounded-md hover:bg-gray-50 transition duration-200">
                            <i class="fas fa-download mr-2"></i>
                            Ekspor Data
                        </button> --}}
                    </div>

                    <!-- Progress Summary -->
                    @php
                        $totalParticipants = 12;
                        $completedParticipants = 6;
                        $progressPercentage = ($completedParticipants / $totalParticipants) * 100;
                    @endphp

                    {{-- <div class="mt-6 grid grid-cols-3 md:grid-cols-3 gap-4">
                        <div class="bg-blue-50 p-4 rounded-lg border border-blue-200">
                            <div class="flex items-center justify-between">
                                <div>
                                    <p class="text-sm text-blue-600 font-medium">Total Peserta</p>
                                    <p class="text-2xl font-bold text-blue-800">{{ $totalParticipants }}</p>
                                </div>
                                <i class="fas fa-users text-blue-600 text-xl"></i>
                            </div>
                        </div>

                        <div class="bg-green-50 p-4 rounded-lg border border-green-200">
                            <div class="flex items-center justify-between">
                                <div>
                                    <p class="text-sm text-green-600 font-medium">Sudah Selesai</p>
                                    <p class="text-2xl font-bold text-green-800">{{ $completedParticipants }}</p>
                                </div>
                                <i class="fas fa-check-circle text-green-600 text-xl"></i>
                            </div>
                        </div>

                        <div class="bg-purple-50 p-4 rounded-lg border border-purple-200">
                            <div class="flex items-center justify-between">
                                <div>
                                    <p class="text-sm text-purple-600 font-medium">Progress</p>
                                    <p class="text-2xl font-bold text-purple-800">
                                        {{ number_format($progressPercentage, 2) }}%
                                    </p>
                                </div>
                                <i class="fas fa-chart-line text-purple-600 text-xl"></i>
                            </div>
                        </div>
                    </div>

                    <div class="mt-4">
                        <div class="flex justify-between text-sm text-gray-600 mb-2">
                            <span>Progress Keseluruhan</span>
                            <span>{{ $completedParticipants }} dari {{ $totalParticipants }} peserta</span>
                        </div>
                        <div class="w-full bg-gray-200 rounded-full h-2">
                            <div class="bg-blue-600 h-2 rounded-full transition-all duration-300"
                                style="width: {{ $progressPercentage }}%"></div>
                        </div>
                    </div> --}}
                </div>

                <!-- Content -->
                <div class="p-6">

                    {{-- Perbandingan Hasil Akhir --}}
                    @if(isset($perbandinganHasil) && !empty($perbandinganHasil))
                        <div class="mb-6 bg-white rounded-lg border border-gray-200 shadow-sm overflow-hidden">
                            <div class="bg-indigo-600 px-4 py-3">
                                <h2 class="text-xl font-bold text-white">Perbandingan Hasil Akhir</h2>
                                <p class="text-lg text-indigo-100 mt-1">
                                    {{ $perbandinganHasil['nama'] }} • {{ \Carbon\Carbon::parse($perbandinganHasil['tanggal'])->format('d/m/Y') }}
                                </p>
                            </div>

                            <div class="p-4">
                                @if(Auth::user()->role === 'opd')
                                    {{-- Tampilan untuk OPD (Single User) - Compact --}}
                                    <div class="grid grid-cols-1 md:grid-cols-3 gap-3 mb-4">
                                        {{-- Nilai OPD --}}
                                        <div class="bg-blue-50 border border-blue-200 rounded-lg p-3 text-center">
                                            <div class="text-lg font-semibold text-blue-700 mb-1">Penilaian OPD</div>
                                            <div class="text-2xl font-bold text-blue-600">
                                                {{ $perbandinganHasil['opd_result']['nilai'] ? number_format($perbandinganHasil['opd_result']['nilai'], 2) : '-' }}
                                            </div>
                                        </div>

                                        {{-- Nilai Walidata --}}
                                        <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-3 text-center">
                                            <div class="text-lg font-medium text-yellow-700 mb-1">Koreksi Walidata</div>
                                            <div class="text-2xl font-bold text-yellow-600">
                                                {{ $perbandinganHasil['walidata_result']['nilai'] ? number_format($perbandinganHasil['walidata_result']['nilai'], 2) : '-' }}
                                            </div>
                                        </div>

                                        {{-- Nilai Admin --}}
                                        <div class="bg-green-50 border border-green-200 rounded-lg p-3 text-center">
                                            <div class="text-lg font-medium text-green-700 mb-1">Evaluasi Admin</div>
                                            <div class="text-2xl font-bold text-green-600">
                                                {{ $perbandinganHasil['bps_result']['nilai'] ? number_format($perbandinganHasil['bps_result']['nilai'], 2) : '-' }}
                                            </div>
                                        </div>
                                    </div>

                                    {{-- Tabel Detail Compact --}}
                                            <div class="overflow-x-auto">
                                        <table class="min-w-full text-sm">
                                            <thead class="bg-gray-100">
                                                        <tr>
                                                    <th class="px-3 py-2 text-left font-semibold text-gray-700">Jenis Penilaian</th>
                                                    <th class="px-3 py-2 text-center font-semibold text-gray-700">Nilai</th>
                                                    <th class="px-3 py-2 text-center font-semibold text-gray-700">Status</th>
                                                        </tr>
                                                    </thead>
                                            <tbody class="bg-white divide-y divide-gray-200">
                                                <tr class="hover:bg-gray-50">
                                                    <td class="px-3 py-2 text-gray-900">Penilaian Mandiri {{ Auth::user()->name }}</td>
                                                    <td class="px-3 py-2 text-center">
                                                        <span class="px-2 py-1 bg-blue-100 text-blue-800 rounded text-sm font-semibold">
                                                            {{ $perbandinganHasil['opd_result']['nilai'] ? number_format($perbandinganHasil['opd_result']['nilai'], 2) : 'N/A' }}
                                                        </span>
                                                    </td>
                                                    <td class="px-3 py-2 text-center">
                                                        @if($perbandinganHasil['opd_result']['terisi'] == $perbandinganHasil['total_indikator'])
                                                            <span class="px-2 py-1 bg-green-100 text-green-700 rounded text-xs font-medium">Selesai</span>
                                                        @else
                                                            <span class="px-2 py-1 bg-orange-100 text-orange-700 rounded text-xs font-medium">
                                                                Belum Lengkap ({{ $perbandinganHasil['opd_result']['terisi'] }}/{{ $perbandinganHasil['total_indikator'] }})
                                                            </span>
                                                        @endif
                                                    </td>
                                                </tr>
                                                <tr class="hover:bg-gray-50">
                                                    <td class="px-3 py-2 text-gray-900">Penilaian Walidata</td>
                                                    <td class="px-3 py-2 text-center">
                                                        <span class="px-2 py-1 bg-yellow-100 text-yellow-800 rounded text-sm font-semibold">
                                                            {{ $perbandinganHasil['walidata_result']['nilai'] ? number_format($perbandinganHasil['walidata_result']['nilai'], 2) : 'N/A' }}
                                                        </span>
                                                    </td>
                                                    <td class="px-3 py-2 text-center">
                                                        @if($perbandinganHasil['walidata_result']['terkoreksi'] == $perbandinganHasil['total_indikator'])
                                                            <span class="px-2 py-1 bg-green-100 text-green-700 rounded text-xs font-medium">Selesai</span>
                                                        @elseif($perbandinganHasil['walidata_result']['terkoreksi'] > 0)
                                                            <span class="px-2 py-1 bg-orange-100 text-orange-700 rounded text-xs font-medium">
                                                                Belum Lengkap ({{ $perbandinganHasil['walidata_result']['terkoreksi'] }}/{{ $perbandinganHasil['total_indikator'] }})
                                                            </span>
                                                        @else
                                                            <span class="px-2 py-1 bg-gray-100 text-gray-600 rounded text-xs font-medium">Menunggu</span>
                                                        @endif
                                                    </td>
                                                </tr>
                                                <tr class="hover:bg-gray-50">
                                                    <td class="px-3 py-2 text-gray-900">Penilaian Pembina Data</td>
                                                    <td class="px-3 py-2 text-center">
                                                        <span class="px-2 py-1 bg-green-100 text-green-800 rounded text-sm font-semibold">
                                                            {{ $perbandinganHasil['bps_result']['nilai'] ? number_format($perbandinganHasil['bps_result']['nilai'], 2) : 'N/A' }}
                                                        </span>
                                                    </td>
                                                    <td class="px-3 py-2 text-center">
                                                        @if($perbandinganHasil['bps_result']['terevaluasi'] == $perbandinganHasil['total_indikator'])
                                                            <span class="px-2 py-1 bg-green-100 text-green-700 rounded text-xs font-medium">Selesai</span>
                                                        @elseif($perbandinganHasil['bps_result']['terevaluasi'] > 0)
                                                            <span class="px-2 py-1 bg-orange-100 text-orange-700 rounded text-xs font-medium">
                                                                Belum Lengkap ({{ $perbandinganHasil['bps_result']['terevaluasi'] }}/{{ $perbandinganHasil['total_indikator'] }})
                                                            </span>
                                                        @else
                                                            <span class="px-2 py-1 bg-gray-100 text-gray-600 rounded text-xs font-medium">Menunggu</span>
                                                        @endif
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                @else
                                    {{-- Tampilan untuk Walidata dan Admin (All OPD) - Compact --}}
                                    @if(isset($perbandinganHasil['results']) && count($perbandinganHasil['results']) > 0)
                                        <div class="overflow-x-auto">
                                            <table class="min-w-full text-sm">
                                                <thead class="bg-gray-100">
                                                    <tr>
                                                        <th class="px-3 py-2 text-left font-semibold text-gray-700">No</th>
                                                        <th class="px-3 py-2 text-left font-semibold text-gray-700">Nama OPD</th>
                                                        <th class="px-3 py-2 text-center font-semibold text-gray-700">OPD</th>
                                                        <th class="px-3 py-2 text-center font-semibold text-gray-700">Walidata</th>
                                                        <th class="px-3 py-2 text-center font-semibold text-gray-700">Admin</th>
                                                    </tr>
                                                </thead>
                                                <tbody class="bg-white divide-y divide-gray-200">
                                                    @foreach($perbandinganHasil['results'] as $index => $result)
                                                        <tr class="hover:bg-gray-50">
                                                            <td class="px-3 py-2 text-gray-700">{{ $index + 1 }}</td>
                                                            <td class="px-3 py-2 font-medium text-gray-900">{{ $result['user_name'] }}</td>
                                                            <td class="px-3 py-2 text-center">
                                                                <span class="px-2 py-1 bg-blue-100 text-blue-800 rounded text-xs font-semibold">
                                                                    {{ $result['opd_result']['nilai'] ? number_format($result['opd_result']['nilai'], 2) : '-' }}
                                                                </span>
                                                            </td>
                                                            <td class="px-3 py-2 text-center">
                                                                @if($result['walidata_result']['nilai'])
                                                                    <span class="px-2 py-1 bg-yellow-100 text-yellow-800 rounded text-xs font-semibold">
                                                                        {{ number_format($result['walidata_result']['nilai'], 2) }}
                                                                    </span>
                                                                @else
                                                                    <span class="px-2 py-1 bg-gray-100 text-gray-500 rounded text-xs">-</span>
                                                                @endif
                                                            </td>
                                                            <td class="px-3 py-2 text-center">
                                                                @if($result['bps_result']['nilai'])
                                                                    <span class="px-2 py-1 bg-green-100 text-green-800 rounded text-xs font-semibold">
                                                                        {{ number_format($result['bps_result']['nilai'], 2) }}
                                                                    </span>
                                                                @else
                                                                    <span class="px-2 py-1 bg-gray-100 text-gray-500 rounded text-xs">-</span>
                                                                @endif
                                                                </td>
                                                            </tr>
                                                        @endforeach
                                                    </tbody>
                                                </table>
                                            </div>
                                    @else
                                        <div class="text-center py-6 text-gray-500">
                                            <p class="text-sm">Belum ada data perbandingan hasil</p>
                                        </div>
                                    @endif
                                @endif
                            </div>
                        </div>
                    @endif

                    <!-- OPD List - Tampilan Langsung -->

                    @foreach ($opdsMenilai as $index => $opd)
                        <div class="my-6 bg-white rounded-lg shadow-md border border-gray-200 overflow-hidden">
                            <!-- Header OPD -->
                            <div class="bg-gradient-to-r from-indigo-500 to-indigo-600 px-6 py-4">
                                <div class="flex items-center text-white">
                                    <i class="fas fa-building text-xl mr-3"></i>
                                    <h3 class="text-lg font-bold">{{ $opd['opd']->name }}</h3>
                                </div>
                                    </div>

                            <!-- Content -->
                            <div class="p-6 bg-gray-50">
                                <div class="mb-3">
                                    <h4 class="font-semibold text-gray-800 text-base mb-4">
                                        <i class="fas fa-chart-bar text-indigo-500 mr-2"></i>
                                        Nilai Indeks Pembangunan Statistik
                                    </h4>
                                </div>

                                <div class="overflow-x-auto">
                                    <table class="min-w-full border text-sm text-left text-gray-700 bg-white shadow-sm rounded-lg overflow-hidden">
                                        <thead class="bg-indigo-600 text-white">
                                            <tr>
                                                <th class="py-3 px-4 font-semibold">Domain</th>
                                                <th class="py-3 px-4 font-semibold text-center">Aspek</th>
                                                <th class="py-3 px-4 font-semibold text-center">Aksi</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-gray-200">
                                            @foreach ($opd['domains'] as $domain)
                                                <tr class="hover:bg-indigo-50 transition-colors">
                                                    <td class="py-3 px-4 font-medium text-gray-800">
                                                        {{ $domain->nama_domain }}
                                                    </td>
                                                    <td class="py-3 px-4 text-center">
                                                        <span class="inline-flex items-center px-3 py-1 bg-indigo-100 text-indigo-800 rounded-full text-sm font-semibold">
                                                            {{-- <i class="fas fa-list-ul mr-1.5 text-xs"></i> --}}
                                                            {{ $domain->aspek->count() }}
                                                        </span>
                                                    </td>
                                                    <td class="py-3 px-4 text-center">
                                                        <a href="{{ route('disposisi.koreksi.isi-domain', [$opd['opd']->name, $formulir->nama_formulir, $domain->nama_domain]) }}"
                                                            class="inline-flex items-center px-4 py-2 bg-gray-900 hover:bg-gray-800 text-white rounded-lg transition-colors shadow-sm">
                                                            <i class="fas fa-pencil-alt mr-2"></i>
                                                            Lihat Rincian
                                                        </a>
                                                    </td>
                                                </tr>
                                            @endforeach
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    @endforeach



                </div>
            </div>
        </div>


    @endsection

    @push('scripts')
        <script>
            $('.deleteBtn').click(function(e) {

                var id = $(this).data('id');

                Swal.fire({
                    title: 'Apakah kamu yakin?',
                    text: "Anda tidak dapat mengembalikan user ini!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Ya, hapus user ini!'
                }).then((result) => {
                    if (result.isConfirmed) {
                        e.preventDefault();
                        $('#form_delete').submit();

                    }
                })
            });
        </script>
    @endpush
