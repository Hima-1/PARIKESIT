@extends('dashboard.layout')
@section('title', 'Penialian Kegiatan ' . $formulir->nama_formulir)

@section('content')
    <div class="space-y-6">

        @php
            $ctaLabel = $terisi > 0 ? 'Lanjutkan Pengisian' : 'Mulai Pengisian';
        @endphp

        {{-- Judul --}}
        <div class="flex justify-between items-center">
            <div>
                <h4 class="text-xl font-semibold text-gray-700">Penilaian Kegiatan</h4>
                <p class="text-sm text-gray-500 mt-1">Isi dan pantau progres penilaian untuk kegiatan yang sedang aktif.</p>
            </div>
        </div>

        <nav class="bg-white p-4 border-2 rounded-md w-full mb-4">
            <ol class="list-reset flex text-grey-dark">

                <li><a href="{{ route('penilaian.index') }}" class="text-blue-600 hover:underline">Penilaian</a></li>
                <li><span class="mx-2">&gt;</span></li>
                <li class="text-gray-700">Kegiatan : {{ $formulir->nama_formulir }}</li>
            </ol>
        </nav>


        {{-- Informasi Tahapan dan Kegiatan --}}
        <div class="grid grid-cols-2 md:grid-cols-1 gap-4">
            <!-- Box Kiri -->
            <div class="col-span-1 border-2 border-blue-400 bg-white p-4 rounded-md shadow-sm">
                <div class="text-md text-blue-600 font-bold mb-4">Tahap Saat Ini</div>
                <div class="text-sm text-blue-700 mb-3">Pengisian penilaian untuk kegiatan terpilih.</div>
                <div class="border rounded-md p-3 bg-blue-50">
                    <div class="font-medium text-gray-700 mb-1">Kegiatan Statistik</div>
                    <div class="text-sm text-gray-800">Kegiatan : <div class="font-bold inline">
                            {{ $formulir->nama_formulir }}
                        </div>
                    </div>
                    <div class="text-sm text-blue-600 underline mt-2">
                        {{ $formulir->created_at->format('Y') }} | {{ $formulir->instansi ?? auth()->user()->name }}</div>
                </div>
            </div>

            <!-- Box Kanan -->
            <div class="border bg-white p-4 rounded-md shadow-sm">
                <div class="text-sm font-medium text-gray-700 mb-4">Progres Pengisian</div>

                <div class="bg-indigo-100 p-3 rounded mb-4">
                    <div class="text-sm text-gray-700 font-medium mb-1">Ringkasan Progres</div>


                    <div class="my-4">
                        {{-- @if ($persentase == 0)
                            <div
                                class="text-xl font-bold text-gray-500 bg-gray-100 hover:bg-gray-200 p-2 rounded shadow w-auto">
                                0 / {{ $totalIndikator }} (0%)
                            </div>
                        @elseif ($persentase < 25)
                            <div
                                class="text-xl font-bold text-red-700 bg-red-100 hover:bg-red-200 p-2 rounded shadow w-auto">
                                {{ $terisi }} / {{ $totalIndikator }} ({{ $persentase }}%)
                            </div>
                        @elseif ($persentase < 50)
                            <div
                                class="text-xl font-bold text-yellow-700 bg-yellow-100 hover:bg-yellow-200 p-2 rounded shadow w-auto">
                                {{ $terisi }} / {{ $totalIndikator }} ({{ $persentase }}%)
                            </div>
                        @elseif ($persentase < 75)
                            <div
                                class="text-xl font-bold text-orange-700 bg-orange-100 hover:bg-orange-200 p-2 rounded shadow w-auto">
                                {{ $terisi }} / {{ $totalIndikator }} ({{ $persentase }}%)
                            </div>
                        @else
                            <div
                                class="text-xl font-bold text-green-700 bg-green-100 hover:bg-green-200 p-2 rounded shadow w-auto">
                                {{ $terisi }} / {{ $totalIndikator }} (100%)
                            </div>
                        @endif --}}

                        @php
                            if ($persentase <= 20 && $persentase > 0) {
                                $warna = 'bg-red-500';
                            } elseif ($persentase > 20 && $persentase <= 40) {
                                $warna = 'bg-yellow-500';
                            } elseif ($persentase > 40 && $persentase <= 60) {
                                $warna = 'bg-orange-500';
                            } elseif ($persentase > 60 && $persentase <= 80) {
                                $warna = 'bg-green-500';
                            } elseif ($persentase > 80 && $persentase <= 99) {
                                $warna = 'bg-blue-500';
                            } elseif ($persentase == 100) {
                                $warna = 'bg-indigo-500';
                            } else {
                                $warna = 'bg-gray-500';
                            }
                        @endphp



                        <div class="w-full bg-gray-200 rounded-full h-5">
                            <div class="h-5 rounded-full {{ $warna ?? 'bg-white' }}" style="width: {{ $persentase }}%">
                            </div>
                        </div>
                        <div class="px-1 mt-2">
                            <p class="mt-1 text-sm text-gray-700"> {{ $terisi }} dari {{ $totalIndikator }} indikator
                                <b class="font-weight-bolder">({{ $persentase }}%) </b>
                            </p>
                        </div>

                    </div>

                    {{-- <div class="text-xs text-gray-500">Indikator sudah lengkap</div> --}}
                </div>

                <a href="{{ route('formulir.domain-penilaian', $formulir) }}"
                    class="block text-center bg-indigo-600 hover:bg-indigo-700 text-white font-semibold py-2 px-4 rounded w-full transition">
                    {{ strtoupper($ctaLabel) }}
                </a>
            </div>
        </div>


        {{-- Tabel Nilai IPS --}}
        <div class="mt-6">
            <div class="font-semibold text-gray-700 mb-2">Nilai Indeks Pembangunan Statistik</div>
            <div class="overflow-x-auto">
                <table class="min-w-full border text-sm text-left text-gray-700 bg-white shadow rounded">
                    <thead class="bg-gray-100 text-gray-600">
                        <tr>
                            <th class="py-2 px-4">Domain</th>
                            <th class="py-2 px-4">Aspek</th>
                            {{-- <th class="py-2 px-4">Aspek</th> --}}
                            <th class="py-2 px-4">Nilai</th>

                        </tr>
                    </thead>
                    <tbody>

                        @foreach ($formulir->domains as $domain)
                            <tr>
                                <td class="py-2 px-4 font-semibold">{{ $domain->nama_domain }}</td>
                                <td class="py-2 px-4">{{ $domain->aspek->count() }}</td>
                                <td class="py-2 px-4 font-bold text-blue-700">
                                    {{ number_format($dataPersentasePerDomain[$domain->id]['persentase_domain'] ?? 0, 2) }}
                                </td>
                            </tr>
                        @endforeach

                    </tbody>
                </table>
            </div>
        </div>

    </div>
@endsection

@push('scripts')
@endpush
