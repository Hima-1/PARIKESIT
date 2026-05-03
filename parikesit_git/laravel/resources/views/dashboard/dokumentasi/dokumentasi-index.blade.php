@extends('dashboard.layout')
@section('title', 'Dokumentasi Kegiatan')
@section('content')
    <div class="card p-8">
        <div class="flex justify-between mb-4">
                <h4 class="h4">Dokumentasi Kegiatan</h4>

            <div class="">
                <a href="{{ route('dokumentasi.create') }}"
                    class="p-2 px-4 bg-blue-500 text-white hover:bg-blue-700 hover:text-white ease-in-out transition duration-100 border rounded-md flex items-center">
                    <i class="fad fa-plus mr-2"></i> Tambah Dokumentasi Kegiatan</a>
            </div>
        </div>

        <hr class="my-4 border-t-2 border-gray-300">

        <div class="mb-4 flex space-x-4">
            <div class="relative w-1/2">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <span class="text-gray-500">
                        <i class="fas fa-search text-lg"></i>
                    </span>
                </div>
                <input type="text" id="searchDokumentasi" placeholder="Cari dokumentasi..."
                    class="w-full pl-10 pr-10 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 shadow-sm transition duration-200 ease-in-out hover:border-blue-300">
                <span id="clearSearchIcon" class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 cursor-pointer hover:text-red-500 hidden">
                    <i class="fas fa-times text-lg"></i>
                </span>
            </div>

            <div class="flex space-x-2 w-1/2">
                <div class="relative flex-grow">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <span class="text-gray-500">
                            <i class="fas fa-calendar-alt text-lg"></i>
                        </span>
                    </div>
                    <input type="text" id="startDate" name="start_date" placeholder="Tanggal Awal"
                        onfocus="(this.type='date')" onblur="(this.type='text')"
                        class="w-full pl-10 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 shadow-sm transition duration-200 ease-in-out hover:border-blue-300">
                </div>
                <div class="relative flex-grow">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <span class="text-gray-500">
                            <i class="fas fa-calendar-alt text-lg"></i>
                        </span>
                    </div>
                    <input type="text" id="endDate" name="end_date" placeholder="Tanggal Akhir"
                        onfocus="(this.type='date')" onblur="(this.type='text')"
                        class="w-full pl-10 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 shadow-sm transition duration-200 ease-in-out hover:border-blue-300">
                </div>
                <button id="filterDate" class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50 transition duration-200 ease-in-out flex items-center shadow-md">
                    <i class="fas fa-filter mr-2"></i>Filter
                </button>
            </div>
        </div>

        {{-- <div class="mb-4 flex justify-between items-center">
            <a href="{{ route('dokumentasi.download-page') }}" class="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700 flex items-center">
                <i class="fas fa-download mr-2"></i> Download Dokumentasi
            </a>
        </div> --}}

        <div id="noDokumentasi" class="hidden text-center py-10"></div>

        <form id="downloadForm" action="{{ route('dokumentasi.download-multiple') }}" method="POST" class="hidden">
            @csrf
            <div id="dokumentasiContainer" class="grid grid-cols-3 lg:grid-cols-2 md:grid-cols-1 sm:grid-cols-1 gap-6">
                @foreach ($dokumentasis as $dok)
                    <div class="dokumentasi-item border rounded-lg shadow p-6 bg-white hover:bg-gray-50 transition ease-in-out duration-150" data-date="{{ $dok->created_at }}">
                        <div class="flex items-center mb-2">
                            <input type="checkbox"
                                name="selected_dokumentasi[]"
                                value="{{ $dok->id }}"
                                class="dokumentasi-checkbox mr-3 form-checkbox h-5 w-5 text-blue-600 rounded"
                                style="display: none;">
                            <h2 class="text-lg font-semibold dokumentasi-judul">{{ $dok->judul_dokumentasi }}</h2>
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
                                    Dokumentasi tersedia
                                @else
                                    Belum ada dokumentasi
                                @endif
                            </b>
                        </p>
                        <div class="flex space-x-2">
                            <a href="{{ route('dokumentasi.show', $dok->id) }}"
                                class="bg-gray-800 text-white text-sm px-4 py-2 rounded hover:bg-gray-600">Lihat</a>
                        </div>
                    </div>
                @endforeach
            </div>
        </form>

        <div id="defaultDokumentasiContainer" class="grid grid-cols-3 lg:grid-cols-2 md:grid-cols-1 sm:grid-cols-1 gap-6">
            @foreach ($dokumentasis as $dok)
                <div class="dokumentasi-item border rounded-lg shadow p-6 bg-white hover:bg-gray-50 transition ease-in-out duration-150" data-date="{{ $dok->created_at }}">
                    <div class="flex xl:flex md:flex-none justify-between mt-4">
                        <h2 class="text-lg font-semibold mb-2 dokumentasi-judul">{{ $dok->judul_dokumentasi }}</h2>
                    </div>
                    <div class="text-sm text-gray-500 flex items-center mb-2">
                        <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                            <path
                                d="M6 2a1 1 0 011 1v1h6V3a1 1 0 112 0v1h1a2 2 0 012 2v1H3V6a2 2 0 012-2h1V3a1 1 0 011-1zM3 9h14v7a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                        </svg>
                        {{ \Carbon\Carbon::parse($dok->created_at)->locale('id')->isoFormat('dddd, D MMMM Y H:m') }}
                    </div>
                    <p class="text-sm text-gray-700 mb-3">
                        @php
                            $countDok = count($dok->file_dokumentasi);
                        @endphp
                        <b>
                            @if ($countDok > 0)
                                Dokumentasi tersedia
                            @else
                                Belum ada dokumentasi
                            @endif
                        </b>
                    </p>
                    <div class="flex space-x-2">
                        <a href="{{ route('dokumentasi.show', $dok->id) }}"
                            class="bg-gray-800 text-white text-sm px-4 py-2 rounded hover:bg-gray-600">Lihat</a>
                    </div>
                </div>
            @endforeach
        </div>
    </div>

    @push('scripts')
    <script>
    $(document).ready(function() {
        const searchInput = $('#searchDokumentasi');
        const clearSearchIcon = $('#clearSearchIcon');
        const dokumentasiContainer = $('#defaultDokumentasiContainer');
        const noDokumentasi = $('#noDokumentasi');
        const startDate = $('#startDate');
        const endDate = $('#endDate');
        const filterDateBtn = $('#filterDate');

        function performSearch() {
            const searchTerm = searchInput.val().toLowerCase().trim();
            const startDateVal = startDate.val();
            const endDateVal = endDate.val();
            let visibleItems = 0;

            $('.dokumentasi-item').each(function() {
                const judul = $(this).find('.dokumentasi-judul').text().toLowerCase();
                const itemDate = $(this).data('date');

                let matchSearch = judul.includes(searchTerm);
                let matchDate = true;

                if (startDateVal && endDateVal) {
                    matchDate = (itemDate >= startDateVal && itemDate <= endDateVal);
                }

                if (matchSearch && matchDate) {
                    $(this).show();
                    visibleItems++;
                } else {
                    $(this).hide();
                }
            });

            if (visibleItems === 0) {
                noDokumentasi.html(`
                    <p class="text-gray-600 text-lg">
                        Tidak ada dokumentasi yang cocok dengan pencarian "${searchInput.val()}"
                    </p>
                `).show();
            } else {
                noDokumentasi.hide();
            }

            if (searchTerm) {
                clearSearchIcon.show();
            } else {
                clearSearchIcon.hide();
            }
        }

        searchInput.on('input', performSearch);
        clearSearchIcon.on('click', function() {
            searchInput.val('');
            performSearch();
        });

        filterDateBtn.on('click', performSearch);

        // Reset date input type
        startDate.on('change', function() {
            if (startDate.val()) {
                startDate.attr('type', 'date');
            }
        });

        endDate.on('change', function() {
            if (endDate.val()) {
                endDate.attr('type', 'date');
            }
        });
    });
    </script>
    @endpush
@endsection
