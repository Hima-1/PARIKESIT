@extends('dashboard.layout')
@php
use App\Models\Penilaian;
@endphp
@section('title', 'Domain Penilaian Kegiatan : ' . $formulir->nama_formulir)
@section('content')
    @php
        $isReadonlyOpd = Auth::user()->role === 'opd';
    @endphp
    <div class="space-y-6">

        <div class="flex justify-between items-center">
            <h4 class="text-xl font-semibold text-gray-700">{{ $isReadonlyOpd ? 'TINJAU PENILAIAN DOMAIN' : 'KOREKSI PENILAIAN DARI DOMAIN' }}</h4>
        </div>
        <nav class="bg-white p-4 border-2 rounded-md w-full mb-4">
            <ol class="list-reset flex text-grey-dark">

                <li><a href="{{ route('disposisi.penilaian.tersedia') }}" class="text-blue-600 hover:underline">{{ $isReadonlyOpd ? 'Tinjau Penilaian' : 'Koreksi Penilaian' }}</a></li>
                <li><span class="mx-2">&gt;</span></li>
                <li class="text-gray-700"> <a
                        href="{{ route('disposisi.penilaian.tersedia.detail', [$formulir->nama_formulir]) }}"
                        class="text-blue-600 hover:underline">Kegiatan Selesai : {{ $formulir->nama_formulir }} </a> </li>
                <li><span class="mx-2">&gt;</span></li>
                <li class="text-gray-700">Domain Kegiatan : {{ $domain->nama_domain }}</li>
            </ol>
        </nav>
        {{-- Judul --}}

        <div id="accordion-color" data-accordion="collapse"
            data-active-classes="bg-indigo-500 text-gray-100 rounded dark:bg-gray-800 dark:text-white"
            data-inactive-classes="text-white">
            <h2 id="accordion-color-heading-1">
                <button type="button"
                    class="flex items-center justify-between w-full p-5 font-medium rtl:text-right border-2 bg-black text-white border-indigo-100 border-b-0 rounded-t-xl focus:ring-4 focus:ring-blue-200 dark:focus:ring-blue-800 dark:border-gray-700 dark:text-gray-400 hover:bg-gray-700 dark:hover:bg-gray-800 hover:text-gray-100 gap-3"
                    data-accordion-target="#accordion-color-body-1" aria-expanded="false"
                    aria-controls="accordion-color-body-1">
                    <span>Data Identitas Penilai</span>
                    <svg data-accordion-icon class="w-3 h-3 rotate-180 shrink-0" aria-hidden="true"
                        xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 10 6">
                        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M9 5 5 1 1 5" />
                    </svg>
                </button>
            </h2>
            <div id="accordion-color-body-1" class="hidden bg-white" aria-labelledby="accordion-color-heading-1">
                <div class="p-5 border border-gray-200  dark:border-gray-700 dark:bg-gray-900">
                    <table class="w-full border-2">
                        <tbody>
                            <tr>
                                <td
                                    class="px-3 py-1 border-t border-b text-gray-100 border-gray-300 bg-gray-900 dark:border-gray-600 w-1/6">
                                    Nama OPD</td>
                                <td class="px-3 py-1 border-t border-b border-gray-300 dark:border-gray-600 text-uppercase">
                                    {{ $opd->name }}</td>
                            </tr>
                            <tr>
                                <td
                                    class="px-3 py-1 border-t border-b text-gray-100 border-gray-300 bg-gray-900 dark:border-gray-600 w-1/6">
                                    Jabatan</td>
                                <td class="px-3 py-1 border-t border-b border-gray-300 dark:border-gray-600 text-uppercase">
                                    {{ $opd->role ?? '-' }}</td>
                            </tr>
                            <tr>
                                <td
                                    class="px-3 py-1 border-t border-b text-gray-100 border-gray-300 bg-gray-900 dark:border-gray-600 w-1/6">
                                    Kontak</td>
                                <td class="px-3 py-1 border-t border-b border-gray-300 dark:border-gray-600 text-uppercase">
                                    {{ $opd->nomor_telepon ?? '-' }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>


        </div>


        <div class="grid grid-cols-1 sm:grid-cols-1 md:grid-cols-1 lg:grid-cols-1 gap-6">
            @foreach ($domain->aspek as $aspek)
                @php
                    $aspectScore = $aspectScores[$aspek->id] ?? null;
                @endphp
                <div
                    class="bg-white border border-gray-300 shadow-lg rounded-md hover:bg-gray-100 transition ease-in-out duration-100">

                    <div class="h-4 bg-gray-800 rounded-t-md"></div>
                    <div class="px-8 pt-6 pb-8">
                        <div class="flex items-center justify-between">
                            <h5 class="text-md font-bold text-blue-700">{{ $isReadonlyOpd ? 'Tinjau Aspek' : 'Koreksi Aspek' }} {{ $aspek->nama_aspek }}</h5>


                            <p class="text-gray-800 text-md">
                                {{ \Carbon\Carbon::parse($aspek->created_at)->locale('id')->isoFormat('dddd, D MMMM Y') }}
                            </p>



                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-3 mt-4">
                            <div class="rounded-lg border border-blue-200 bg-blue-50 p-3">
                                <div class="text-xs font-bold uppercase tracking-wide text-blue-700">Skor OPD</div>
                                <div class="mt-1 text-lg font-black text-blue-700">
                                    {{ isset($aspectScore['opd_score']) && $aspectScore['opd_score'] !== null ? number_format($aspectScore['opd_score'], 2) : '-' }}
                                </div>
                            </div>
                            <div class="rounded-lg border border-yellow-200 bg-yellow-50 p-3">
                                <div class="text-xs font-bold uppercase tracking-wide text-yellow-700">Skor Walidata</div>
                                <div class="mt-1 text-lg font-black text-yellow-700">
                                    {{ isset($aspectScore['walidata_score']) && $aspectScore['walidata_score'] !== null ? number_format($aspectScore['walidata_score'], 2) : '-' }}
                                </div>
                            </div>
                            <div class="rounded-lg border border-green-200 bg-green-50 p-3">
                                <div class="text-xs font-bold uppercase tracking-wide text-green-700">Skor BPS</div>
                                <div class="mt-1 text-lg font-black text-green-700">
                                    {{ isset($aspectScore['admin_score']) && $aspectScore['admin_score'] !== null ? number_format($aspectScore['admin_score'], 2) : '-' }}
                                </div>
                            </div>
                        </div>

                        <div class="flex bg-blue-100 rounded-md p-4 mt-4 shadow">




                            <div class="relative overflow-x-auto w-full">

                                <table class="w-full text-sm">
                                    <thead class="bg-indigo-600 text-white">
                                        <tr>
                                            <th class="px-3 py-2 text-left text-xs font-semibold uppercase">Indikator</th>
                                            <th class="px-3 py-2 text-center text-xs font-semibold uppercase w-20">OPD</th>
                                            <th class="px-3 py-2 text-center text-xs font-semibold uppercase w-20">Walidata</th>
                                            <th class="px-3 py-2 text-center text-xs font-semibold uppercase w-20">BPS</th>
                                            <th class="px-3 py-2 text-center text-xs font-semibold uppercase w-24">{{ $isReadonlyOpd ? 'Detail' : 'Aksi' }}</th>
                                        </tr>
                                    </thead>
                                    <tbody class="bg-white divide-y divide-gray-200">
                                        @foreach ($aspek->indikator as $index => $indikator)
                                            @php
                                                $penilaianUser = $indikator->penilaian->where('user_id', $opd->id)->where('formulir_id', $formulir->id)->first();

                                                $penilaianOPD = Penilaian::where('user_id', $opd->id)
                                                    ->where('formulir_id', $formulir->id)
                                                    ->where('indikator_id', $indikator->id)
                                                    ->whereHas('user', function($query) { $query->where('role', 'opd'); })
                                                    ->first();

                                                $penilaianWalidata = Penilaian::where('user_id', $opd->id)
                                                    ->where('formulir_id', $formulir->id)
                                                    ->where('indikator_id', $indikator->id)
                                                    ->whereNotNull('nilai_diupdate')
                                                    ->first();

                                                $penilaianBPS = Penilaian::where('user_id', $opd->id)
                                                    ->where('formulir_id', $formulir->id)
                                                    ->where('indikator_id', $indikator->id)
                                                    ->whereNotNull('nilai_koreksi')
                                                    ->first();
                                            @endphp
                                            <tr class="hover:bg-gray-50">
                                                <td class="px-3 py-2">
                                                    <span class="text-gray-800 font-medium leading-snug">
                                                        {{ $indikator->nama_indikator }}
                                                    </span>
                                                </td>
                                                <td class="px-3 py-2 text-center">
                                                    <span class="inline-block px-2 py-1 bg-blue-100 text-blue-800 rounded font-semibold">
                                                        {{ $penilaianOPD ? ($penilaianOPD->nilai ?? '-') : '-' }}
                                                    </span>
                                                </td>
                                                <td class="px-3 py-2 text-center">
                                                    <span class="inline-block px-2 py-1 {{ $penilaianWalidata ? 'bg-yellow-100 text-yellow-800' : 'bg-gray-100 text-gray-600' }} rounded font-semibold">
                                                        {{ $penilaianWalidata ? ($penilaianWalidata->nilai_diupdate ?? '-') : '-' }}
                                                    </span>
                                                </td>
                                                <td class="px-3 py-2 text-center">
                                                    <span class="inline-block px-2 py-1 {{ $penilaianBPS ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-600' }} rounded font-semibold">
                                                        {{ $penilaianBPS ? ($penilaianBPS->nilai_koreksi ?? '-') : '-' }}
                                                    </span>
                                                </td>
                                                <td class="px-3 py-2 text-center">
                                                    <a href="{{ route('disposisi.koreksi.indikator.beri-koreksi', [$opd->name, $formulir->nama_formulir, $domain->nama_domain, $aspek->nama_aspek, $indikator->nama_indikator]) }}"
                                                        class="inline-flex items-center px-3 py-1.5 bg-indigo-600 hover:bg-indigo-700 text-white rounded text-xs font-medium transition-colors">
                                                        <i class="fas {{ $isReadonlyOpd ? 'fa-eye' : 'fa-edit' }} mr-1"></i> {{ $isReadonlyOpd ? 'Lihat' : 'Koreksi' }}
                                                    </a>
                                                </td>
                                            </tr>
                                        @endforeach
                                    </tbody>
                                </table>
                            </div>

                        </div>

                    </div>

                    {{-- <div class="w-full">
                        <a href="{{route('formulir.sesiPenilaian',[$formulir, $domain])}}" class="block text-center bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded w-full transition mt-4">Mulai Penilaian</a>
                    </div> --}}


                </div>
            @endforeach
        </div>


    </div>
@endsection

@push('scripts')
@endpush
