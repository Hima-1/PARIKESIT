{{-- Nilai Koreksi Akhir --}}
@if($kegiatan['nilai_koreksi_akhir'] !== null)
    <div class="mb-6">
        <h5 class="text-lg font-semibold text-gray-700 mb-3 flex items-center">
            <i class="fas fa-star text-yellow-500 mr-2"></i>Nilai Koreksi Akhir (Rata-rata Domain)
        </h5>
        <div class="bg-white rounded-lg p-4 border border-gray-200">
            <div class="flex items-center justify-center">
                <div class="text-center">
                    <div class="text-4xl font-bold text-yellow-600 mb-2">{{ number_format($kegiatan['nilai_koreksi_akhir'], 2) }}</div>
                    <div class="text-sm text-gray-600">dari skala 1-5</div>
                </div>
            </div>
            <div class="mt-4 w-full bg-gray-200 rounded-full h-3">
                <div class="bg-gradient-to-r from-yellow-400 to-yellow-600 h-3 rounded-full transition-all duration-500"
                     style="width: {{ ($kegiatan['nilai_koreksi_akhir'] / 5) * 100 }}%"></div>
            </div>
        </div>
    </div>
@endif

{{-- Indikator Belum Dikoreksi --}}
@if(count($kegiatan['indikator_belum_dikoreksi']) > 0)
    <div class="mb-6">
        <h5 class="text-lg font-semibold text-gray-700 mb-3 flex items-center">
            <i class="fas fa-exclamation-triangle text-red-500 mr-2"></i>Indikator Belum Dikoreksi
            <span class="ml-2 px-2 py-1 bg-red-100 text-red-700 rounded-full text-sm font-bold">
                {{ count($kegiatan['indikator_belum_dikoreksi']) }}
            </span>
        </h5>
        <div class="bg-white rounded-lg p-4 border border-gray-200 max-h-64 overflow-y-auto">
            <div class="space-y-2">
                @foreach($kegiatan['indikator_belum_dikoreksi'] as $indikator)
                    <div class="p-3 bg-red-50 border border-red-200 rounded-lg hover:bg-red-100 transition">
                        <div class="flex items-start justify-between">
                            <div class="flex-1">
                                <div class="font-medium text-gray-800">{{ $indikator['nama'] }}</div>
                                <div class="text-xs text-gray-600 mt-1">
                                    <span class="font-semibold">Domain:</span> {{ $indikator['domain'] }} |
                                    <span class="font-semibold">Aspek:</span> {{ $indikator['aspek'] }}
                                </div>
                                <div class="text-xs text-gray-600 mt-1">
                                    <span class="font-semibold">OPD:</span> {{ $indikator['user_name'] }}
                                </div>
                            </div>
                        </div>
                    </div>
                @endforeach
            </div>
        </div>
    </div>
@else
    <div class="mb-6">
        <div class="bg-green-50 border border-green-200 rounded-lg p-4">
            <div class="flex items-center text-green-700">
                <i class="fas fa-check-circle text-green-500 mr-2"></i>
                <span class="font-medium">Semua indikator sudah dikoreksi</span>
            </div>
        </div>
    </div>
@endif



