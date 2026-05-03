@extends('dashboard.layout')
@section('title', 'Penilaian Indikator ' . $indikator->nama_indikator)

@php
use App\Models\Penilaian;
@endphp

@section('content')
    @php
        $role = Auth::user()->role;
        $isReadonlyOpd = $role === 'opd';
    @endphp
    <div class="flex justify-between items-center">
        <h4 class="text-lg font-semibold text-blue-700 text-uppercase mb-3">{{ $isReadonlyOpd ? 'Tinjau' : 'Aspek' }} {{ strtoupper($aspek->nama_aspek) }}</h4>
    </div>

    <nav class="bg-white p-4 border-2 rounded-md w-full mb-4">
        <ol class="list-reset flex text-grey-dark">

            <li><a href="{{ route('disposisi.penilaian.tersedia') }}" class="text-blue-600 hover:underline">{{ $isReadonlyOpd ? 'Tinjau Penilaian' : 'Koreksi Penilaian' }}</a></li>
            <li><span class="mx-2">&gt;</span></li>
            <li class="text-gray-700"> <a
                    href="{{ route('disposisi.penilaian.tersedia.detail', [$formulir->nama_formulir]) }}"
                    class="text-blue-600 hover:underline">Kegiatan Selesai : {{ $formulir->nama_formulir }} </a> </li>
            <li><span class="mx-2">&gt;</span></li>
            <li class="text-gray-700">
                <a href="{{ route('disposisi.koreksi.isi-domain', [$opd->name, $formulir->nama_formulir, $domain->nama_domain]) }}"
                    class="text-blue-600 hover:underline"> Domain Kegiatan : {{ $domain->nama_domain }} </a>
            </li>
            <li><span class="mx-2">&gt;</span></li>
            <li class="text-gray-700">
                Indikator {{ $indikator->nama_indikator }}
            </li>
        </ol>
    </nav>


    <div id="accordion-color" data-accordion="collapse"
        data-active-classes="bg-indigo-500 text-gray-100 rounded dark:bg-gray-800 dark:text-white"
        data-inactive-classes="text-white" class="my-5 rounded-md shadow-md">
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
                        {{-- <tr>
                            <td
                                class="px-3 py-1 border-t border-b text-gray-100 border-gray-300 bg-gray-900 dark:border-gray-600 w-1/6">
                                Jabatan</td>
                            <td class="px-3 py-1 border-t border-b border-gray-300 dark:border-gray-600 text-uppercase">
                                {{ $opd->role ?? '-' }}</td>
                        </tr> --}}
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

    <div class="p-6 bg-white shadow rounded-md">
        <!-- Header -->
        <div class="flex justify-between items-center  pb-4">
            <div class="text-blue-600 font-semibold text-sm">Indikator {{ $indikator->nama_indikator }}</div>
            <div class="space-x-2">




                {{-- @if ($prev_indikator != null)
                    <a href="{{ route('formulir.penilaianAspek', [$formulir, $domain->nama_domain, $aspek->nama_aspek, $prev_indikator->nama_indikator]) }}"
                        class="text-blue-600 hover:text-blue-800">
                        ⬅️
                    </a>
                @endif

                  @if ($next_indikator != null)
                    <a href="{{ route('formulir.penilaianAspek', [$formulir, $domain->nama_domain, $aspek->nama_aspek, $next_indikator->nama_indikator]) }}"
                        class="text-blue-600 hover:text-blue-800">
                        ➡️
                    </a>
                @endif --}}
            </div>
        </div>


        @include('dashboard.partials.indikator-reference', [
            'domain' => $domain,
            'aspek' => $aspek,
            'indikator' => $indikator,
        ])

        <div class="grid grid-cols-3 gap-4">

            <!-- Kolom Kiri: Nilai & Bukti Dukung -->
            <div class="col-span-1 space-y-2">
                <!-- Nilai Dipilih -->
                <div class="border-2 bg-gray-100 border-blue-200 p-4 rounded-md">
                    <h1 class="text-blue-500 font-semibold text-md mb-2">Nilai Awal</h1>
                    <div class="bg-blue-700 py-3 text-center rounded-md shadow">
                        <p class="text-4xl font-bold text-gray-100">{{ $nilai_diinput->nilai ?? '0.00' }} / 5.00 </p>
                    </div>
                </div>

                <!-- Bukti Dukung -->

            </div>

            <div class="col-span-1 space-y-2">

                <div class="border-2 bg-gray-900 border-gray-200 p-4 rounded-md">
                    <h1 class="text-white font-semibold text-md mb-2">Nilai Diupdate</h1>
                    <div class="bg-indigo-500 py-3 text-center rounded-md shadow">
                        <p class="text-4xl font-bold text-gray-100">{{ $nilai_diinput->nilai_diupdate ?? '0.00' }} / 5.00
                        </p>
                    </div>
                </div>
            </div>

            <div class="col-span-1 space-y-2">

                <div class="border-2 bg-gray-900 border-green-200 p-4 rounded-md">
                    <h1 class="text-white font-semibold text-md mb-2">Nilai Evaluasi</h1>
                    <div class="bg-green-500 py-3 text-center rounded-md shadow">
                        <p class="text-4xl font-bold text-gray-100">{{ $nilai_dievaluasi->nilai_koreksi ?? '0.00' }} / 5.00
                        </p>
                    </div>
                </div>
            </div>




        </div>


        <div class="grid grid-cols-2 mt-8 gap-5">
                <div class="col-span-1 space-y-2">
                    <div class="border-2 bg-gray-100 border-green-200 p-4 rounded-md h-full">
                        <h1 class="text-green-500 font-semibold text-md mb-2">Bukti Dukung Dilampirkan</h1>
                        @if (!is_null($nilai_diinput))
                            @php
                                $buktiDukungFiles = $nilai_diinput->normalizedBuktiDukung();
                            @endphp
                            @if (!empty($buktiDukungFiles))
                                @foreach ($buktiDukungFiles as $buktiFile)
                                    <a href="{{ $nilai_diinput->resolveBuktiDukungUrl($buktiFile) }}" target="_blank"
                                        class="flex items-center space-x-2 text-green-700 hover:underline mb-2">
                                        <i class="fas fa-file-alt text-lg"></i>
                                        <span>Lihat Bukti Dukung</span>
                                    </a>
                                @endforeach
                            @else
                                <p class="text-md text-gray-900">Tidak ada bukti dukung yang diupload</p>
                            @endif
                        @else
                            <p class="text-md text-gray-900">Tidak ada bukti dukung yang diupload</p>
                        @endif
                    </div>
                </div>

                <div class="col-span-1 space-y-2">
                    <div class="border-2  border-yellow-400 p-4 rounded-md h-full">
                        <h1 class="text-yellow-500 font-semibold text-md mb-2">Catatan</h1>
                        <p class="text-md {{ optional($nilai_diinput)->catatan ? 'text-gray-900' : 'text-red-600' }}">
                            {{ optional($nilai_diinput)->catatan ??
                                'Tidak ada catatan tambahan untuk penilaian ini.' }}
                        </p>
                    </div>
                </div>
            </div>

        @if( Auth::user()->role === 'opd')
            <div class="mt-8 space-y-4">
                {{-- Penjelasan Koreksi dari Walidata --}}
                <div class="border-2 border-green-400 p-4 rounded-md">
                    <h1 class="text-green-600 font-semibold text-md mb-2">
                        <i class="fas fa-comment-dots mr-2"></i>Penjelasan Koreksi dari Walidata
                    </h1>
                    <p class="text-md {{ optional($nilai_dikoreksi)->catatan_koreksi ? 'text-gray-900' : 'text-red-600' }}">
                        {{ optional($nilai_dikoreksi)->catatan_koreksi ?? 'Belum ada penjelasan koreksi dari Walidata.' }}
                    </p>
                </div>
                
                {{-- Evaluasi dari Admin --}}
                <div class="border-2 border-blue-400 p-4 rounded-md">
                    <h1 class="text-blue-500 font-semibold text-md mb-2">
                        <i class="fas fa-clipboard-check mr-2"></i>Evaluasi Admin
                    </h1>
                    <p class="text-md {{ optional($nilai_dievaluasi)->evaluasi ? 'text-gray-900' : 'text-red-600' }}">
                        {{ optional($nilai_dievaluasi)->evaluasi ?? 'Belum ada evaluasi dari Admin.' }}
                    </p>
                </div>
            </div>
        @endif


        @php
            $nilaiKoreksiTerkunci = $nilai_dikoreksi ? $nilai_dikoreksi->nilai_diupdate : null;
            $style =
                $nilaiKoreksiTerkunci == null
                    ? 'block bg-white border rounded-md p-3 shadow-sm cursor-pointer hover:bg-indigo-200 ease-in-out transition duration-100'
                    : 'block bg-gray-300 border disabled rounded-md p-3 shadow-sm cursor-pointer';

            $nilaiEvaluasiterkunci = $nilai_dievaluasi ? $nilai_dievaluasi->nilai_koreksi : null;

            $styleEvaluasi =
                $nilaiEvaluasiterkunci == null
                    ? 'block bg-white border rounded-md p-3 shadow-sm cursor-pointer hover:bg-green-200 ease-in-out transition duration-100'
                    : 'block bg-gray-300 border disabled rounded-md p-3 shadow-sm cursor-pointer';

        @endphp

        {{--
          <div
                    class="{{ $role == 'walidata' ? '' : 'pointer-events-none opacity-75 cursor-not-allowed bg-gray-300' }}"> --}}


        @php
            $route = $role == 'walidata'
                ? 'disposisi.koreksi.indikator.store-koreksi'
                : 'disposisi.koreksi.indikator.update-evaluasi';
        @endphp

        @if ($role == 'walidata')
            @if ($nilai_diinput)
                <form action="{{ route($route, [$formulir, $domain, $aspek, $indikator, $nilai_diinput->id]) }}" method="POST"
                    enctype="multipart/form-data">
                    <div class="">

                        @csrf
                        <div class="space-y-2 mt-5 p-3 border-2 rounded-md font-semibold">


                            <input type="hidden" name="penilaian_id" value="{{ $nilai_diinput->id }}">
                            <div class="font-semibold text-sm text-gray-700">{{ $indikator->nama_indikator }}</div>
                            <div class="space-y-2 text-sm">
                                <label for="level1" class="{{ $style }}">
                                    <div class="flex items-start space-x-3">
                                        <input type="radio" id="level1" name="nilai" value="1"
                                            class="mt-1 accent-blue-600" {{ $nilaiKoreksiTerkunci == 1 ? 'checked' : '' }}
                                            {{ $nilaiKoreksiTerkunci !== null && $nilaiKoreksiTerkunci != 1 ? 'disabled' : '' }}>
                                        <div class="flex flex-col">
                                        <span>Level 1. Rintisan</span>
                                            @if(!empty($indikator->level_1_kriteria))
                                                <small class="text-xs text-gray-600 mt-1">
                                                    {{ $indikator->level_1_kriteria }}
                                                </small>
                                            @endif
                                        </div>
                                    </div>
                                </label>
                                <label for="level2" class="{{ $style }}">
                                    <div class="flex items-start space-x-3">
                                        <input type="radio" id="level2" name="nilai" value="2"
                                            class="mt-1 accent-blue-600" {{ $nilaiKoreksiTerkunci == 2 ? 'checked' : '' }}
                                            {{ $nilaiKoreksiTerkunci !== null && $nilaiKoreksiTerkunci != 2 ? 'disabled' : '' }}>
                                        <div class="flex flex-col">
                                        <span>Level 2. Terkelola</span>
                                            @if(!empty($indikator->level_2_kriteria))
                                                <small class="text-xs text-gray-600 mt-1">
                                                    {{ $indikator->level_2_kriteria }}
                                                </small>
                                            @endif
                                        </div>
                                    </div>
                                </label>
                                <label for="level3" class="{{ $style }}">
                                    <div class="flex items-start space-x-3">
                                        <input type="radio" id="level3" name="nilai" value="3"
                                            class="mt-1 accent-blue-600" {{ $nilaiKoreksiTerkunci == 3 ? 'checked' : '' }}
                                            {{ $nilaiKoreksiTerkunci !== null && $nilaiKoreksiTerkunci != 3 ? 'disabled' : '' }}>
                                        <div class="flex flex-col">
                                        <span>Level 3. Terdefinisi</span>
                                            @if(!empty($indikator->level_3_kriteria))
                                                <small class="text-xs text-gray-600 mt-1">
                                                    {{ $indikator->level_3_kriteria }}
                                                </small>
                                            @endif
                                        </div>
                                    </div>
                                </label>
                                <label for="level4" class="{{ $style }}">
                                    <div class="flex items-start space-x-3">
                                        <input type="radio" id="level4" name="nilai" value="4"
                                            class="mt-1 accent-blue-600" {{ $nilaiKoreksiTerkunci == 4 ? 'checked' : '' }}
                                            {{ $nilaiKoreksiTerkunci !== null && $nilaiKoreksiTerkunci != 4 ? 'disabled' : '' }}>
                                        <div class="flex flex-col">
                                        <span>Level 4. Terpadu</span>
                                            @if(!empty($indikator->level_4_kriteria))
                                                <small class="text-xs text-gray-600 mt-1">
                                                    {{ $indikator->level_4_kriteria }}
                                                </small>
                                            @endif
                                        </div>
                                    </div>
                                </label>
                                <label for="level5" class="{{ $style }}">
                                    <div class="flex items-start space-x-3">
                                        <input type="radio" id="level5" name="nilai" value="5"
                                            class="mt-1 accent-blue-600" {{ $nilaiKoreksiTerkunci == 5 ? 'checked' : '' }}
                                            {{ $nilaiKoreksiTerkunci !== null && $nilaiKoreksiTerkunci != 5 ? 'disabled' : '' }}>
                                        <div class="flex flex-col">
                                        <span>Level 5. Optimum</span>
                                            @if(!empty($indikator->level_5_kriteria))
                                                <small class="text-xs text-gray-600 mt-1">
                                                    {{ $indikator->level_5_kriteria }}
                                                </small>
                                            @endif
                                        </div>
                                    </div>
                                </label>
                            </div>
                        </div>

                        {{-- Catatan Penjelasan Koreksi Walidata --}}
                        @if ($role == 'walidata')
                            <div class="mt-5">
                                <label for="catatan_koreksi" class="text-sm font-semibold text-gray-700 mb-1 block">
                                    <i class="fas fa-comment-dots text-blue-600 mr-2"></i>Penjelasan Koreksi
                                </label>
                                <div class="text-xs text-gray-500 mb-2">
                                    Berikan penjelasan mengenai koreksi penilaian ini (opsional)
                                </div>
                                @if ($nilai_dikoreksi && $nilai_dikoreksi->catatan_koreksi)
                                    <textarea id="catatan_koreksi" name="catatan_koreksi" rows="4" 
                                        class="w-full border-2 border-gray-300 rounded-lg p-3 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-200" 
                                        disabled>{{ $nilai_dikoreksi->catatan_koreksi }}</textarea>
                                @else
                                    <textarea id="catatan_koreksi" name="catatan_koreksi" rows="4" 
                                        class="w-full border-2 border-gray-300 rounded-lg p-3 text-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-200" 
                                        placeholder="Contoh: Nilai dinaikkan karena bukti dukung sudah lengkap dan sesuai dengan standar yang ditetapkan..."></textarea>
                                @endif
                            </div>
                        @endif


                        @if ($role == 'admin')
                            <div class="mt-5 font-semibold">
                                <label for="evaluasi" class="text-sm font-semibold text-gray-700 mb-1 block">Evaluasi</label>
                                <textarea id="evaluasi" name="evaluasi" rows="4" class="w-full border rounded p-2 text-sm"
                                    placeholder="Masukkan evaluasi..."></textarea>

                            </div>
                        @endif


                        <div class="mt-10">


                            @if ($nilai_diinput->nilai_diupdate != null)
                                <a href="{{ route('disposisi.koreksi.isi-domain', [$opd->name, $formulir->nama_formulir, $domain->nama_domain]) }}"
                                    class="bg-gray-600 shadow hover:bg-gray-800 dark:hover:bg-gray-700  p-3 w-full text-white mt-4 rounded-md text-center">Kembali</a>
                            @else
                                <div class="flex justify-between">
                                    <button type="submit"
                                        class="bg-indigo-500 p-3 w-50 text-white mt-4 rounded-md">{{ $role == 'walidata' ? 'Simpan Koreksi' : 'Simpan Evaluasi' }}</button>

                                    <a href="{{ route('disposisi.koreksi.isi-domain', [$opd->name, $formulir->nama_formulir, $domain->nama_domain]) }}"
                                        class="bg-gray-600 shadow hover:bg-gray-800 dark:hover:bg-gray-700  p-3 text-white mt-4 rounded-md text-center">Kembali</a>
                                </div>
                            @endif

                        </div>
                    </form>
                @else
                    <div class="text-center py-10 border-2 border-red-300 bg-red-50 shadow-md rounded-md mt-10">
                        <p class="text-2xl text-red-900 font-semibold">Belum Ada Penilaian</p>
                        <p class="font-bold text-red-700">Silakan tunggu penilaian </p>
                    </div>
                @endif

            @elseif ($role == 'admin')
                @if ($nilai_diinput != null)
                    @php
                        $penilaianWalidata = Penilaian::where('user_id', $opd->id)
                            ->where('formulir_id', $formulir->id)
                            ->where('indikator_id', $indikator->id)
                            ->whereNotNull('nilai_diupdate')
                            ->first();
                    @endphp

                    @if($penilaianWalidata)
                        <form action="{{ route($route, [$formulir, $domain, $aspek, $indikator, $nilai_diinput->id]) }}"
                            method="POST" enctype="multipart/form-data">
                            <div class="">
                                @csrf
                                <div class="space-y-2 mt-5 p-3 border-2 rounded-md font-semibold ">
                                    <input type="hidden" name="penilaian_id" value="{{ $nilai_diinput->id }}">
                                    <div class="font-semibold text-sm text-gray-700">{{ $indikator->nama_indikator }} <b
                                            class="text-red-600">(Evaluasi)</b> </div>
                                    <div class="space-y-2 text-sm">
                                        <label for="level1_evaluasi" class="{{ $styleEvaluasi }}">
                                            <div class="flex items-start space-x-3">
                                                <input type="radio" id="level1_evaluasi" name="nilai_evaluasi" value="1"
                                                    class="mt-1 accent-blue-600"
                                                    {{ $nilaiEvaluasiterkunci == 1 ? 'checked' : '' }}
                                                    {{ $nilaiEvaluasiterkunci !== null && $nilaiEvaluasiterkunci != 1 ? 'disabled' : '' }}>
                                                <div class="flex flex-col">
                                                <span>Level 1. Rintisan</span>
                                                    @if(!empty($indikator->level_1_kriteria))
                                                        <small class="text-xs text-gray-600 mt-1">
                                                            {{ $indikator->level_1_kriteria }}
                                                        </small>
                                                    @endif
                                                </div>
                                            </div>
                                        </label>
                                        <label for="level2_evaluasi" class="{{ $styleEvaluasi }}">
                                            <div class="flex items-start space-x-3">
                                                <input type="radio" id="level2_evaluasi" name="nilai_evaluasi" value="2"
                                                    class="mt-1 accent-blue-600"
                                                    {{ $nilaiEvaluasiterkunci == 2 ? 'checked' : '' }}
                                                    {{ $nilaiEvaluasiterkunci !== null && $nilaiEvaluasiterkunci != 2 ? 'disabled' : '' }}>
                                                <div class="flex flex-col">
                                                <span>Level 2. Terkelola</span>
                                                    @if(!empty($indikator->level_2_kriteria))
                                                        <small class="text-xs text-gray-600 mt-1">
                                                            {{ $indikator->level_2_kriteria }}
                                                        </small>
                                                    @endif
                                                </div>
                                            </div>
                                        </label>
                                        <label for="level3_evaluasi" class="{{ $styleEvaluasi }}">
                                            <div class="flex items-start space-x-3">
                                                <input type="radio" id="level3_evaluasi" name="nilai_evaluasi" value="3"
                                                    class="mt-1 accent-blue-600"
                                                    {{ $nilaiEvaluasiterkunci == 3 ? 'checked' : '' }}
                                                    {{ $nilaiEvaluasiterkunci !== null && $nilaiEvaluasiterkunci != 3 ? 'disabled' : '' }}>
                                                <div class="flex flex-col">
                                                <span>Level 3. Terdefinisi</span>
                                                    @if(!empty($indikator->level_3_kriteria))
                                                        <small class="text-xs text-gray-600 mt-1">
                                                            {{ $indikator->level_3_kriteria }}
                                                        </small>
                                                    @endif
                                                </div>
                                            </div>
                                        </label>
                                        <label for="level4_evaluasi" class="{{ $styleEvaluasi }}">
                                            <div class="flex items-start space-x-3">
                                                <input type="radio" id="level4_evaluasi" name="nilai_evaluasi" value="4"
                                                    class="mt-1 accent-blue-600"
                                                    {{ $nilaiEvaluasiterkunci == 4 ? 'checked' : '' }}
                                                    {{ $nilaiEvaluasiterkunci !== null && $nilaiEvaluasiterkunci != 4 ? 'disabled' : '' }}>
                                                <div class="flex flex-col">
                                                <span>Level 4. Terpadu</span>
                                                    @if(!empty($indikator->level_4_kriteria))
                                                        <small class="text-xs text-gray-600 mt-1">
                                                            {{ $indikator->level_4_kriteria }}
                                                        </small>
                                                    @endif
                                                </div>
                                            </div>
                                        </label>
                                        <label for="level5_evaluasi" class="{{ $styleEvaluasi }}">
                                            <div class="flex items-start space-x-3">
                                                <input type="radio" id="level5_evaluasi" name="nilai_evaluasi" value="5"
                                                    class="mt-1 accent-blue-600"
                                                    {{ $nilaiEvaluasiterkunci == 5 ? 'checked' : '' }}
                                                    {{ $nilaiEvaluasiterkunci !== null && $nilaiEvaluasiterkunci != 5 ? 'disabled' : '' }}>
                                                <div class="flex flex-col">
                                                <span>Level 5. Optimum</span>
                                                    @if(!empty($indikator->level_5_kriteria))
                                                        <small class="text-xs text-gray-600 mt-1">
                                                            {{ $indikator->level_5_kriteria }}
                                                        </small>
                                                    @endif
                                                </div>
                                            </div>
                                        </label>
                                    </div>
                                </div>

                                {{-- Tampilkan Catatan Koreksi dari Walidata untuk Admin --}}
                                @if($penilaianWalidata && $penilaianWalidata->catatan_koreksi)
                                    <div class="mt-5 border-2 border-green-400 rounded-lg p-4 bg-green-50">
                                        <label class="text-sm font-semibold text-green-700 mb-2 block">
                                            <i class="fas fa-comment-dots mr-2"></i>Penjelasan Koreksi dari Walidata
                                        </label>
                                        <p class="text-md text-gray-900 bg-white p-3 rounded border">
                                            {{ $penilaianWalidata->catatan_koreksi }}
                                        </p>
                                    </div>
                                @endif

                                <div class="mt-5 font-semibold">
                                    <label for="evaluasi"
                                        class="text-sm font-semibold text-gray-700 mb-1 block">Evaluasi</label>
                                    <textarea id="evaluasi" name="evaluasi" rows="4"
                                        class="w-full border-gray-500 border-2 rounded p-2 text-md shadow-md"
                                        placeholder="Masukkan evaluasi...">{{ $nilai_diinput->evaluasi ?? '' }}</textarea>
                                </div>

                                <div class="mt-10">
                                    @if ($nilai_diinput->evaluasi != null)
                                        <a href="{{ route('disposisi.koreksi.isi-domain', [$opd->name, $formulir->nama_formulir, $domain->nama_domain]) }}"
                                            class="bg-gray-600 shadow hover:bg-gray-800 dark:hover:bg-gray-700  p-3 w-full text-white mt-4 rounded-md text-center">Kembali</a>
                                    @else
                                        <div class="flex justify-between">
                                            <button type="submit"
                                                class="bg-indigo-500 p-3 w-50 text-white mt-4 rounded-md">Simpan Evaluasi</button>
                                            <a href="{{ route('disposisi.koreksi.isi-domain', [$opd->name, $formulir->nama_formulir, $domain->nama_domain]) }}"
                                                class="bg-gray-600 shadow hover:bg-gray-800 dark:hover:bg-gray-700  p-3 text-white mt-4 rounded-md text-center">Kembali</a>
                                        </div>
                                    @endif
                                </div>
                            </div>
                        </form>
                    @else
                    <br>
                        <div class="bg-yellow-100 border border-yellow-400 text-yellow-700 px-4 py-3 rounded relative" role="alert">
                            <strong class="font-bold">Peringatan!</strong>
                            <span class="block sm:inline">Walidata belum mengisi penilaian. Anda tidak dapat melakukan evaluasi saat ini.</span>
                        </div>
                    @endif
                @else
                    <div class="text-center  py-10 border-2 border-gray-300 shadow-md rounded-md mt-10">
                        <p class="text-2xl text-gray-900 font-semibold">Data belum ada</p>
                        <p class="font-bold">Silakan menunggu penilaian terlebih dahulu</p>
                    </div>
                @endif
            @elseif ($role == 'opd')
                <div class="mt-10">
                    <a href="{{ route('disposisi.koreksi.isi-domain', [$opd->name, $formulir->nama_formulir, $domain->nama_domain]) }}"
                        class="bg-gray-600 shadow hover:bg-gray-800 dark:hover:bg-gray-700 p-3 w-full text-white mt-4 rounded-md text-center inline-block">Kembali</a>
                </div>
            @endif


        {{-- @endif --}}

    </div>

@endsection
@push('scripts')
    <script>
        $(function() {
            const radios = $('input[name="nilai"]');

            function updateSelectedBackground() {
                radios.each(function() {
                    const label = $(`label[for="${this.id}"]`);
                    if (this.checked) {
                        label.addClass('bg-indigo-400');
                    } else {
                        label.removeClass('bg-indigo-400');
                    }
                });
            }

            // Jalankan saat load halaman untuk menyetel nilai yang tersimpan
            updateSelectedBackground();

            // Tambahkan event saat diklik
            radios.on('change', updateSelectedBackground);
        });



        $(function() {
            const radiosEvaluasi = $('input[name="nilai_evaluasi"]');

            function updateSelectedEvaluasiBackground() {
                radiosEvaluasi.each(function() {
                    const label = $(`label[for="${this.id}"]`);
                    if (this.checked) {
                        label.addClass('bg-green-300');
                    } else {
                        label.removeClass('bg-green-300');
                    }
                });
            }

            // Jalankan saat load halaman untuk menyetel nilai yang tersimpan
            updateSelectedEvaluasiBackground();

            // Tambahkan event saat diklik
            radiosEvaluasi.on('change', updateSelectedEvaluasiBackground);
        });
    </script>
@endpush
