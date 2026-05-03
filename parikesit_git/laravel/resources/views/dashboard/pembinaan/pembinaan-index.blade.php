@extends('dashboard.layout')
@section('title', 'Pembinaan')
@section('content')
@php
    use Illuminate\Support\Facades\Auth;
@endphp
    <div class="card p-8">

        <div class="flex justify-between mb-4">
            <h4 class="h4">Pembinaan</h4>

            @php
                $user = Auth::user();
                $allowedRoles = ['admin'];
            @endphp

            @if($user->hasAnyRole($allowedRoles))
                <div class="">
                    <a href="{{ route('pembinaan.create') }}"
                        class="p-2 px-4 bg-blue-500 text-white hover:bg-blue-700 hover:text-white ease-in-out transition duration-100 border rounded-md flex items-center">
                        <i class="fad fa-plus mr-2"></i> Tambah Pembinaan
                    </a>
                </div>
            @endif
        </div>
        <hr class="my-4 border-t-2 border-gray-300">

        <div class="mb-4 flex space-x-4">
            <div class="relative w-1/2">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <span class="text-gray-500">
                        <i class="fas fa-search text-lg"></i>
                    </span>
                </div>
                <input type="text" id="searchPembinaan" placeholder="Cari Pembinaan..."
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
                    <input type="date" id="startDate" name="start_date"
                        class="w-full pl-10 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 shadow-sm transition duration-200 ease-in-out hover:border-blue-300">
                </div>
                <div class="relative flex-grow">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <span class="text-gray-500">
                            <i class="fas fa-calendar-alt text-lg"></i>
                        </span>
                    </div>
                    <input type="date" id="endDate" name="end_date"
                        class="w-full pl-10 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 shadow-sm transition duration-200 ease-in-out hover:border-blue-300">
                </div>
                <button id="filterDate" class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50 transition duration-200 ease-in-out flex items-center shadow-md">
                    <i class="fas fa-filter mr-2"></i>Filter
                </button>
            </div>
        </div>

        <hr class="my-4 border-t-2 border-gray-300">

        <div id="pembinaanContainer" class="grid grid-cols-3 lg:grid-cols-2 md:grid-cols-1 sm:grid-cols-1 gap-6">
            @forelse ($pembinaans as $pb)
                <div class="pembinaan-item border rounded-lg shadow p-6 bg-white hover:bg-gray-50 transition ease-in-out duration-150" data-date="{{ $pb->created_at }}">
                    <div class="flex xl:flex md:flex-none justify-between mt-4">
                        <h2 class="text-lg font-semibold mb-2 pembinaan-judul">{{ $pb->judul_pembinaan }}</h2>
                    </div>
                    <div class="text-sm text-gray-500 flex items-center mb-2">
                        <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                            <path
                                d="M6 2a1 1 0 011 1v1h6V3a1 1 0 112 0v1h1a2 2 0 012 2v1H3V6a2 2 0 012-2h1V3a1 1 0 011-1zM3 9h14v7a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                        </svg>
                        {{ \Carbon\Carbon::parse($pb->created_at)->locale('id')->isoFormat('dddd, D MMMM Y') }}
                    </div>
                    <p class="text-sm text-gray-700 mb-3">
                        <span class="flex items-center">
                            <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                <path d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z"/>
                            </svg>
                            <b>Dibuat oleh: {{ $pb->profile->name ?? 'Unknown' }}</b>
                        </span>
                    </p>
                    <div class="flex space-x-2">
                        <a href="{{ route('pembinaan.show', $pb->id) }}"
                            class="bg-gray-800 text-white text-sm px-4 py-2 rounded hover:bg-gray-600">Lihat</a>
                    </div>
                </div>
            @empty
                <div id="noPembinaan" class="col-span-full text-center py-10 bg-gray-100 rounded-lg">
                    <p class="text-gray-600 text-lg">Belum ada pembinaan</p>
                </div>
            @endforelse
        </div>
    </div>
@endsection

@push('scripts')
    <script>
        $(document).ready(function() {
            const searchInput = $('#searchPembinaan');
            const clearSearchIcon = $('#clearSearchIcon');
            const pembinaanContainer = $('#pembinaanContainer');
            const noPembinaan = $('#noPembinaan');
            const startDate = $('#startDate');
            const endDate = $('#endDate');
            const filterDateBtn = $('#filterDate');

            function performSearch() {
                const searchTerm = searchInput.val().toLowerCase().trim();
                const startDateVal = startDate.val();
                const endDateVal = endDate.val();
                let visibleItems = 0;

                $('.pembinaan-item').each(function() {
                    const judul = $(this).find('.pembinaan-judul').text().toLowerCase();
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
                    noPembinaan.html(`
                        <p class="text-gray-600 text-lg">
                            Tidak ada pembinaan yang cocok dengan pencarian "${searchInput.val()}"
                        </p>
                    `).show();
                } else {
                    noPembinaan.hide();
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
        });
    </script>
@endpush
