{{-- Compact Statistics Card --}}
<div class="bg-white rounded-lg border border-gray-200 overflow-hidden mb-4">
    {{-- Header with Final Score --}}
    <div class="bg-gradient-to-r from-purple-600 to-purple-700 px-4 py-3 flex items-center justify-between">
        <div class="flex items-center">
            <i class="fas fa-chart-line text-white mr-2"></i>
            <span class="text-white font-semibold text-sm">Statistik Pengisian</span>
        </div>
        @if($kegiatan['nilai_evaluasi_akhir'] !== null)
            <div class="bg-white bg-opacity-20 rounded-lg px-3 py-1">
                <div class="text-xs text-white font-medium uppercase tracking-wide mb-0.5">Nilai Akhir</div>
                <div class="text-2xl font-extrabold text-white">{{ number_format($kegiatan['nilai_evaluasi_akhir'], 2) }}</div>
            </div>
        @endif
    </div>

    {{-- Compact Progress Lines --}}
    <div class="p-4 space-y-3">
        {{-- OPD Progress --}}
        <div>
            <div class="flex items-center justify-between mb-1">
                <span class="text-xs font-semibold text-gray-700 flex items-center">
                    <span class="w-2 h-2 bg-blue-500 rounded-full mr-2"></span>
                    Pengisian OPD
                </span>
                <span class="text-xs font-bold text-gray-600">
                    {{ $kegiatan['statistik_opd']['terisi'] }}/{{ $kegiatan['statistik_opd']['total_indikator'] }}
                    <span class="text-blue-600 ml-1">({{ $kegiatan['statistik_opd']['persentase'] }}%)</span>
                </span>
            </div>
            <div class="w-full bg-blue-100 rounded-full h-2">
                <div class="bg-blue-500 h-2 rounded-full transition-all duration-500"
                     style="width: {{ $kegiatan['statistik_opd']['persentase'] }}%"></div>
            </div>
        </div>

        {{-- Walidata Progress --}}
        <div>
            <div class="flex items-center justify-between mb-1">
                <span class="text-xs font-semibold text-gray-700 flex items-center">
                    <span class="w-2 h-2 bg-yellow-500 rounded-full mr-2"></span>
                    Koreksi Walidata
                </span>
                <span class="text-xs font-bold text-gray-600">
                    {{ $kegiatan['statistik_walidata']['terkoreksi'] }}/{{ $kegiatan['statistik_walidata']['total_indikator'] }}
                    <span class="text-yellow-600 ml-1">({{ $kegiatan['statistik_walidata']['persentase'] }}%)</span>
                </span>
            </div>
            <div class="w-full bg-yellow-100 rounded-full h-2">
                <div class="bg-yellow-500 h-2 rounded-full transition-all duration-500"
                     style="width: {{ $kegiatan['statistik_walidata']['persentase'] }}%"></div>
            </div>
        </div>
    </div>

    {{-- Footer Status --}}
    <div class="bg-gray-50 px-4 py-2 border-t border-gray-200">
        @if($kegiatan['statistik_opd']['terisi'] == $kegiatan['statistik_opd']['total_indikator'] && $kegiatan['statistik_walidata']['terkoreksi'] == $kegiatan['statistik_walidata']['total_indikator'])
            <p class="text-xs text-green-700 font-medium flex items-center">
                <i class="fas fa-check-circle mr-1"></i>
                Semua indikator sudah terisi dan dikoreksi
            </p>
        @else
            <p class="text-xs text-gray-600 font-medium">
                <i class="fas fa-info-circle mr-1"></i>
                Proses pengisian dan koreksi masih berlangsung
            </p>
        @endif
    </div>
</div>

{{-- Indikator Belum Dievaluasi --}}
@if(count($kegiatan['indikator_belum_dievaluasi']) > 0)
    <div class="bg-white rounded-lg border border-red-200 overflow-hidden">
        <div class="bg-red-50 px-4 py-2 border-b border-red-200 flex items-center justify-between">
            <span class="text-sm font-semibold text-red-700 flex items-center">
                <i class="fas fa-exclamation-triangle mr-2"></i>
                Indikator Belum Dievaluasi
            </span>
            <span class="px-2 py-0.5 bg-red-100 text-red-700 rounded-full text-xs font-bold">
                {{ count($kegiatan['indikator_belum_dievaluasi']) }}
            </span>
        </div>
        <div class="max-h-64 overflow-y-auto">
            @foreach($kegiatan['indikator_belum_dievaluasi'] as $indikator)
                <div class="px-4 py-3 hover:bg-red-50 transition border-b border-gray-100 last:border-b-0">
                    <div class="flex items-start justify-between mb-1">
                        <div class="flex-1">
                            <div class="text-sm font-medium text-gray-800">{{ $indikator['nama'] }}</div>
                            <div class="text-xs text-gray-600 mt-0.5">
                                {{ $indikator['domain'] }} › {{ $indikator['aspek'] }} •
                                <span class="font-medium">{{ $indikator['user_name'] }}</span>
                            </div>
                        </div>
                        <span class="ml-2 px-2 py-0.5 bg-yellow-100 text-yellow-700 rounded text-xs font-semibold flex-shrink-0">
                            Nilai: {{ $indikator['nilai_koreksi'] }}
                        </span>
                    </div>
                    @if($indikator['catatan_koreksi'])
                        <div class="mt-2 pl-3 border-l-2 border-blue-300 bg-blue-50 rounded-r px-3 py-2">
                            <div class="flex items-start">
                                <i class="fas fa-comment-dots text-blue-500 text-xs mr-2 mt-0.5"></i>
                                <div class="flex-1">
                                    <div class="text-xs font-semibold text-blue-700 mb-1">Penjelasan Koreksi Walidata:</div>
                                    <div class="text-xs text-gray-700 leading-relaxed">{{ $indikator['catatan_koreksi'] }}</div>
                                </div>
                            </div>
                        </div>
                    @endif
                </div>
            @endforeach
        </div>
    </div>
@else
    {{-- <div class="bg-green-50 border border-green-200 rounded-lg px-4 py-2">
        <p class="text-xs text-green-700 font-medium flex items-center">
            <i class="fas fa-check-circle mr-2"></i>
            Semua indikator sudah dievaluasi
        </p>
    </div> --}}
@endif





