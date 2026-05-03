@extends('dashboard.layout')
@section('title', 'Download Dokumentasi')
@section('content')
<div class="card p-8">
    <div class="mb-6">
        <h2 class="text-2xl font-bold text-gray-800">Download Dokumentasi</h2>
        <p class="text-gray-600 mt-2">Pilih dokumentasi yang ingin Anda download</p>
    </div>

    <form action="{{ route('dokumentasi.download-multiple') }}" method="POST" id="downloadForm">
        @csrf
        <div class="flex mb-4">
            <label class="inline-flex items-center mr-4">
                <input type="checkbox" id="selectAllDokumentasi" class="form-checkbox h-5 w-5 text-blue-600 rounded">
                <span class="ml-2">Pilih Semua</span>
            </label>
            <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 flex items-center">
                <i class="fas fa-download mr-2"></i> Download Terpilih
            </button>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            @forelse ($dokumentasis as $dok)
                <div class="border rounded-lg shadow p-6 bg-white hover:bg-gray-50 transition ease-in-out duration-150">
                    <div class="flex items-center mb-2">
                        <input type="checkbox"
                            name="selected_dokumentasi[]"
                            value="{{ $dok->id }}"
                            class="mr-3 form-checkbox h-5 w-5 text-blue-600 rounded">
                        <h2 class="text-lg font-semibold">{{ $dok->judul_dokumentasi }}</h2>
                    </div>
                    <div class="text-sm text-gray-500 flex items-center mb-2">
                        <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                            <path d="M6 2a1 1 0 011 1v1h6V3a1 1 0 112 0v1h1a2 2 0 012 2v1H3V6a2 2 0 012-2h1V3a1 1 0 011-1zM3 9h14v7a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                        </svg>
                        {{ \Carbon\Carbon::parse($dok->created_at)->locale('id')->isoFormat('dddd, D MMMM Y H:m') }}
                    </div>
                    <p class="text-sm text-gray-700 mb-3">
                        @php
                            $countDok = count($dok->file_dokumentasi);
                        @endphp
                        <b>
                            @if ($countDok > 0)
                                {{ $countDok }} File Dokumentasi
                            @else
                                Tidak ada file
                            @endif
                        </b>
                    </p>
                    <div class="flex space-x-2">
                        <a href="{{ route('dokumentasi.show', $dok->id) }}"
                            class="bg-gray-800 text-white text-sm px-4 py-2 rounded hover:bg-gray-600">Lihat Detail</a>
                    </div>
                </div>
            @empty
                <div class="col-span-full text-center py-8">
                    <p class="text-gray-600 text-lg">Tidak ada dokumentasi yang tersedia untuk download</p>
                </div>
            @endforelse
        </div>
    </form>
</div>

@push('scripts')
<script>
$(document).ready(function() {
    $('#selectAllDokumentasi').on('change', function() {
        $('input[name="selected_dokumentasi[]"]').prop('checked', $(this).prop('checked'));
    });

    $('#downloadForm').on('submit', function(e) {
        const selectedDokumentasi = $('input[name="selected_dokumentasi[]"]:checked');

        if (selectedDokumentasi.length === 0) {
            e.preventDefault();
            alert('Pilih setidaknya satu dokumentasi untuk didownload');
        }
    });
});
</script>
@endpush
@endsection
