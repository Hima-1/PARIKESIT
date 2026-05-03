{{-- Ringkasan Progress (Compact View) --}}
<div class="bg-white rounded-lg border border-gray-200 shadow-sm overflow-hidden">

    {{-- Header dengan Nilai Akhir --}}
    <div class="bg-gradient-to-r from-blue-600 to-blue-700 px-4 py-3 flex items-center justify-between">
        <div class="flex items-center">
            <i class="fas fa-chart-line text-gray-800 text-lg mr-2"></i>
            <h5 class="text-gray-800 font-semibold text-base">Progress Penilaian</h5>
        </div>
        @if($kegiatan['hasil_penilaian_akhir'] !== null)
            <div class="bg-white bg-opacity-20 rounded-lg px-3 py-1.5">
                <div class="text-xs text-gray-800 font-medium uppercase tracking-wide mb-0.5">Nilai Akhir</div>
                <div class="text-3xl font-extrabold text-gray-800 drop-shadow-lg">{{ number_format($kegiatan['hasil_penilaian_akhir'], 2) }}</div>
            </div>
        @endif
    </div>

    {{-- Content --}}
    <div class="p-4 space-y-3">

        {{-- Progress Pengisian OPD --}}
        <div class="pb-3 border-b border-gray-100">
            <div class="flex items-center justify-between mb-1.5">
                <div class="flex items-center">
                    <i class="fas fa-edit text-blue-500 text-sm mr-2"></i>
                    <span class="text-sm font-medium text-gray-700">Pengisian Saya</span>
                </div>
                <span class="text-xs font-semibold px-2 py-0.5 bg-blue-100 text-blue-700 rounded-full">
                    {{ $kegiatan['progress_per_indikator']['terisi'] }}/{{ $kegiatan['progress_per_indikator']['total'] }}
                </span>
            </div>
            <div class="w-full bg-gray-200 rounded-full h-3 overflow-hidden shadow-inner">
                @php
                    $persentase = $kegiatan['progress_per_indikator']['persentase'];
                    $bgColor = $persentase == 100 ? 'bg-gradient-to-r from-green-500 to-green-600' : 
                               ($persentase >= 75 ? 'bg-gradient-to-r from-blue-500 to-blue-600' : 
                               ($persentase >= 50 ? 'bg-gradient-to-r from-yellow-500 to-yellow-600' : 
                               'bg-gradient-to-r from-red-500 to-red-600'));
                @endphp
                <div class="{{ $bgColor }} h-3 rounded-full transition-all duration-500 shadow-md"
                     style="width: {{ $persentase }}%"></div>
            </div>
            <div class="text-right mt-1">
                @php
                    $textColor = $persentase == 100 ? 'text-green-600' : 
                                ($persentase >= 75 ? 'text-blue-600' : 
                                ($persentase >= 50 ? 'text-yellow-600' : 
                                'text-red-600'));
                @endphp
                <span class="text-xs font-bold {{ $textColor }}">{{ $persentase }}%</span>
            </div>
        </div>

        {{-- Progress Koreksi Walidata --}}
        @if($kegiatan['progress_koreksi_walidata'] !== null)
            <div class="pb-3 border-b border-gray-100">
                <div class="flex items-center justify-between mb-1.5">
                    <div class="flex items-center">
                        <i class="fas fa-user-check text-green-500 text-sm mr-2"></i>
                        <span class="text-sm font-medium text-gray-700">Koreksi Walidata</span>
                    </div>
                    <span class="text-xs font-semibold px-2 py-0.5 bg-green-100 text-green-700 rounded-full">
                        {{ $kegiatan['progress_koreksi_walidata']['sudah_dikoreksi'] }}/{{ $kegiatan['progress_koreksi_walidata']['total'] }}
                    </span>
                </div>
                <div class="w-full bg-gray-200 rounded-full h-3 overflow-hidden shadow-inner">
                    @php
                        $persentase_koreksi = $kegiatan['progress_koreksi_walidata']['persentase'];
                        $bgColorKoreksi = $persentase_koreksi == 100 ? 'bg-gradient-to-r from-emerald-500 to-emerald-600' : 
                                   ($persentase_koreksi >= 75 ? 'bg-gradient-to-r from-green-500 to-green-600' : 
                                   ($persentase_koreksi >= 50 ? 'bg-gradient-to-r from-teal-500 to-teal-600' : 
                                   'bg-gradient-to-r from-orange-500 to-orange-600'));
                    @endphp
                    <div class="{{ $bgColorKoreksi }} h-3 rounded-full transition-all duration-500 shadow-md"
                         style="width: {{ $persentase_koreksi }}%"></div>
                </div>
                <div class="text-right mt-1">
                    @php
                        $textColorKoreksi = $persentase_koreksi == 100 ? 'text-emerald-600' : 
                                    ($persentase_koreksi >= 75 ? 'text-green-600' : 
                                    ($persentase_koreksi >= 50 ? 'text-teal-600' : 
                                    'text-orange-600'));
                    @endphp
                    <span class="text-xs font-bold {{ $textColorKoreksi }}">{{ $persentase_koreksi }}%</span>
                </div>
            </div>
        @endif

        {{-- Progress Evaluasi Admin --}}
        @if($kegiatan['progress_evaluasi_admin'] !== null)
            <div>
                <div class="flex items-center justify-between mb-1.5">
                    <div class="flex items-center">
                        <i class="fas fa-user-shield text-purple-500 text-sm mr-2"></i>
                        <span class="text-sm font-medium text-gray-700">Evaluasi Admin</span>
                    </div>
                    <span class="text-xs font-semibold px-2 py-0.5 bg-purple-100 text-purple-700 rounded-full">
                        {{ $kegiatan['progress_evaluasi_admin']['sudah_dievaluasi'] }}/{{ $kegiatan['progress_evaluasi_admin']['total'] }}
                    </span>
                </div>
                <div class="w-full bg-gray-200 rounded-full h-3 overflow-hidden shadow-inner">
                    @php
                        $persentase_evaluasi = $kegiatan['progress_evaluasi_admin']['persentase'];
                        $bgColorEvaluasi = $persentase_evaluasi == 100 ? 'bg-gradient-to-r from-violet-500 to-violet-600' : 
                                   ($persentase_evaluasi >= 75 ? 'bg-gradient-to-r from-purple-500 to-purple-600' : 
                                   ($persentase_evaluasi >= 50 ? 'bg-gradient-to-r from-indigo-500 to-indigo-600' : 
                                   'bg-gradient-to-r from-pink-500 to-pink-600'));
                    @endphp
                    <div class="{{ $bgColorEvaluasi }} h-3 rounded-full transition-all duration-500 shadow-md"
                         style="width: {{ $persentase_evaluasi }}%"></div>
                </div>
                <div class="text-right mt-1">
                    @php
                        $textColorEvaluasi = $persentase_evaluasi == 100 ? 'text-violet-600' : 
                                    ($persentase_evaluasi >= 75 ? 'text-purple-600' : 
                                    ($persentase_evaluasi >= 50 ? 'text-indigo-600' : 
                                    'text-pink-600'));
                    @endphp
                    <span class="text-xs font-bold {{ $textColorEvaluasi }}">{{ $persentase_evaluasi }}%</span>
                </div>
            </div>
        @endif

    </div>

    {{-- Footer Status --}}
    <div class="bg-gray-50 px-4 py-2 border-t border-gray-200">
        @if($kegiatan['progress_per_indikator']['persentase'] == 100)
            <div class="flex items-center text-green-700 text-xs">
                <i class="fas fa-check-circle mr-1.5"></i>
                <span class="font-semibold">Penilaian Anda sudah lengkap</span>
            </div>
        @else
            <div class="flex items-center text-orange-600 text-xs">
                <i class="fas fa-hourglass-half mr-1.5"></i>
                <span class="font-semibold">{{ $kegiatan['progress_per_indikator']['total'] - $kegiatan['progress_per_indikator']['terisi'] }} indikator belum terisi</span>
            </div>
        @endif
    </div>

</div>




