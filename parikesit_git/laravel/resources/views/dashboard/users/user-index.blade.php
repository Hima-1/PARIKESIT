@extends('dashboard.layout')
@section('title', 'User')
@section('content')
    <div class="card p-8">

        @if(session('success'))
            <div class="mb-4 p-4 bg-green-100 border border-green-400 text-green-700 rounded-lg flex items-center justify-between">
                <div class="flex items-center">
                    <i class="fas fa-check-circle mr-3 text-xl"></i>
                    <span class="font-medium">{{ session('success') }}</span>
                </div>
                <button onclick="this.parentElement.style.display='none'" class="text-green-700 hover:text-green-900">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        @endif

        <div class="flex justify-between mb-4">
            <h4 class="h4">User</h4>

            <a href="{{ route('user.create') }}"
                class="py-3 px-8 bg-blue-600 rounded shadow text-white hover:text-blue-200 hover:bg-gray-800 transform duration-100 ease-in-out">Tambah
                User</a>
        </div>

        <hr class="my-4 border-t-2 border-gray-300">

        @php
            $isAdmin = Auth::user()->role == 'admin';
        @endphp

        <div class="mb-4 flex space-x-4">
            <div class="relative w-full">
                    <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-gray-500">
                        <i class="fas fa-search"></i>
                    </span>
                    <input type="text" id="searchUser"
                    value="{{ $search }}"
                        placeholder="Cari user (nama, email, role)..."
                        class="w-full pl-10 pr-10 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                <button id="clearSearch"
                    class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 cursor-pointer hover:text-red-500 {{ $search ? '' : 'hidden' }}">
                        <i class="fas fa-times"></i>
                </button>
                <div id="searchLoading" class="absolute right-3 top-1/2 transform -translate-y-1/2 hidden">
                    <i class="fas fa-spinner fa-spin text-blue-500"></i>
                </div>
            </div>
        </div>

        <div id="noResultsMessage" class="{{ $users->isEmpty() && $search ? '' : 'hidden' }} text-center py-10 text-gray-600 bg-gray-50 rounded-lg border border-gray-200">
            <i class="fas fa-search text-4xl mb-4 text-gray-400"></i>
            <p class="text-lg font-medium">Tidak ada user yang cocok dengan pencarian "<span id="searchTerm">{{ $search }}</span>"</p>
        </div>

        <div id="usersTableWrapper">
        <table class="table-auto table-bordered w-full ">
            <thead>
                <tr class="bg-blue-200 border-2">
                    <th class="px-4 py-2 text-left">
                        <a href="{{ route('user.index', ['sort' => 'name', 'direction' => $sortBy == 'name' && $sortDirection == 'asc' ? 'desc' : 'asc', 'search' => $search]) }}"
                           class="flex items-center space-x-2 hover:text-blue-800 transition-colors">
                            <span class="font-semibold">Nama</span>
                            @if($sortBy == 'name')
                                @if($sortDirection == 'asc')
                                    <i class="fas fa-sort-up text-blue-800 font-bold text-lg"></i>
                                @else
                                    <i class="fas fa-sort-down text-blue-800 font-bold text-lg"></i>
                                @endif
                            @else
                                <i class="fas fa-sort text-gray-500 hover:text-gray-700"></i>
                            @endif
                        </a>
                    </th>
                    <th class="px-4 py-2 text-left">Email</th>
                    <th class="px-4 py-2 text-left">
                        <a href="{{ route('user.index', ['sort' => 'role', 'direction' => $sortBy == 'role' && $sortDirection == 'asc' ? 'desc' : 'asc', 'search' => $search]) }}"
                           class="flex items-center space-x-2 hover:text-blue-800 transition-colors">
                            <span class="font-semibold">Role</span>
                            @if($sortBy == 'role')
                                @if($sortDirection == 'asc')
                                    <i class="fas fa-sort-up text-blue-800 font-bold text-lg"></i>
                                @else
                                    <i class="fas fa-sort-down text-blue-800 font-bold text-lg"></i>
                                @endif
                            @else
                                <i class="fas fa-sort text-gray-500 hover:text-gray-700"></i>
                            @endif
                        </a>
                    </th>
                    <th class="px-4 py-2 text-left">Tanggal Dibuat</th>
                    <th class="px-4 py-2 text-left">Aksi</th>
                </tr>
            </thead>
            <tbody id="usersTableBody">
                @foreach ($users as $user)
                    <tr class="user-row border border-1">
                        <td class="px-4 py-2 user-name">{{ $user->name }}</td>
                        <td class="px-4 py-2 user-email">{{ $user->email }}</td>
                        <td class="px-4 py-2 user-role">
                            @if ($user->role == 'opd')
                                <button class="px-2 py-1 bg-yellow-600 text-white rounded">OPD</button>
                            @elseif ($user->role == 'admin')
                                <button class="px-2 py-1 bg-blue-500 text-white rounded">Admin</button>
                            @else
                                <button class="px-2 py-1 bg-green-500 text-white rounded">Walidata</button>
                            @endif
                        </td>
                        <td class="px-4 py-2 user-created-at">
                            {{ \Carbon\Carbon::parse($user->created_at)->locale('id')->isoFormat('dddd, D MMMM Y') }}
                        </td>
                        <td class="px-4 py-2">
                            <div class="flex flex-wrap gap-2">
                                <a href="{{ route('user.edit', $user->id) }}"
                                    class="text-green-600 hover:text-green-800 border rounded-md p-2"
                                    title="Edit User">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                                    </svg>
                                </a>
                                @if($isAdmin)
                                    <form action="{{ route('user.reset-password', $user->id) }}" method="POST"
                                        class="inline">
                                        @csrf
                                        <button type="button"
                                            class="text-orange-600 hover:text-orange-800 border rounded-md p-2 resetPasswordBtn"
                                            title="Reset Password">
                                            <i class="fas fa-key text-sm"></i>
                                        </button>
                                    </form>
                                @endif
                                <form action="{{ route('user.destroy', $user->id) }}" method="POST"
                                    class="inline">
                                    @csrf
                                    @method('DELETE')
                                    <button type="button"
                                        class="text-red-600 hover:text-red-800 border rounded-md p-2 deleteBtn"
                                        title="Hapus User">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                        </svg>
                                    </button>
                                </form>
                                <a href="{{ route('user.show', $user->id) }}"
                                    class="text-gray-800 hover:text-gray-600 border rounded-md px-2 py-1"
                                    title="Lihat Detail">
                                    <i class="fad fa-eye text-sm"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>
        </div>

    </div>
@endsection

@push('scripts')
    <script>
    $(document).ready(function() {
        const searchInput = $('#searchUser');
        const clearSearchBtn = $('#clearSearch');
        const searchLoading = $('#searchLoading');
        const usersTableBody = $('#usersTableBody');
        const usersTableWrapper = $('#usersTableWrapper');
        const noResultsMessage = $('#noResultsMessage');
        const searchTermSpan = $('#searchTerm');

        let searchTimeout;
        const currentSortBy = '{{ $sortBy }}';
        const currentSortDirection = '{{ $sortDirection }}';
        const isAdmin = {{ $isAdmin ? 'true' : 'false' }};
        const baseUrl = '{{ url("/") }}';
        const csrfToken = '{{ csrf_token() }}';

        function getRoleBadge(role) {
            if (role === 'opd') {
                return '<button class="px-2 py-1 bg-yellow-600 text-white rounded">OPD</button>';
            } else if (role === 'admin') {
                return '<button class="px-2 py-1 bg-blue-500 text-white rounded">Admin</button>';
            } else {
                return '<button class="px-2 py-1 bg-green-500 text-white rounded">Walidata</button>';
            }
        }

        function escapeHtml(value) {
            return $('<div>').text(value ?? '').html();
        }

        function renderUsersTable(users) {
            if (users.length === 0) {
                usersTableWrapper.hide();
                noResultsMessage.show();
                usersTableBody.html('');
                return;
            }

            usersTableWrapper.show();
            noResultsMessage.hide();

            let html = '';
            users.forEach(function(user) {
                html += '<tr class="user-row border border-1">';
                html += '<td class="px-4 py-2 user-name">' + escapeHtml(user.name) + '</td>';
                html += '<td class="px-4 py-2 user-email">' + escapeHtml(user.email) + '</td>';
                html += '<td class="px-4 py-2 user-role">' + getRoleBadge(user.role) + '</td>';

                html += '<td class="px-4 py-2 user-created-at">' + escapeHtml(user.created_at) + '</td>';
                html += '<td class="px-4 py-2">';
                html += '<div class="flex flex-wrap gap-2">';
                html += '<a href="' + baseUrl + '/user/' + user.id + '/edit" class="text-green-600 hover:text-green-800 border rounded-md p-2" title="Edit User">';
                html += '<svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" /></svg>';
                html += '</a>';

                if (isAdmin) {
                    html += '<form action="' + baseUrl + '/user/' + user.id + '/reset-password" method="POST" class="inline">';
                    html += '<input type="hidden" name="_token" value="' + csrfToken + '">';
                    html += '<button type="button" class="text-orange-600 hover:text-orange-800 border rounded-md p-2 resetPasswordBtn" title="Reset Password">';
                    html += '<i class="fas fa-key text-sm"></i>';
                    html += '</button>';
                    html += '</form>';
                }

                html += '<form action="' + baseUrl + '/user/' + user.id + '" method="POST" class="inline">';
                html += '<input type="hidden" name="_token" value="' + csrfToken + '">';
                html += '<input type="hidden" name="_method" value="DELETE">';
                html += '<button type="button" class="text-red-600 hover:text-red-800 border rounded-md p-2 deleteBtn" title="Hapus User">';
                html += '<svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" /></svg>';
                html += '</button>';
                html += '</form>';
                html += '<a href="' + baseUrl + '/user/' + user.id + '" class="text-gray-800 hover:text-gray-600 border rounded-md px-2 py-1" title="Lihat Detail">';
                html += '<i class="fad fa-eye text-sm"></i>';
                html += '</a>';
                html += '</div>';
                html += '</td>';
                html += '</tr>';
            });

            usersTableBody.html(html);
            attachEventHandlers();
        }

        function performSearch(searchTerm) {
            searchLoading.show();
            clearSearchBtn.hide();

            $.ajax({
                url: '{{ route("user.index") }}',
                method: 'GET',
                data: {
                    search: searchTerm,
                    sort: currentSortBy,
                    direction: currentSortDirection
                },
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                },
                success: function(response) {
                    searchLoading.hide();

                    if (searchTerm) {
                        clearSearchBtn.show();
                    } else {
                        clearSearchBtn.hide();
                    }

                    if (response.users.length === 0 && searchTerm) {
                        searchTermSpan.text(searchTerm);
                        noResultsMessage.show();
                        usersTableWrapper.hide();
                        usersTableBody.html('');
                    } else {
                        renderUsersTable(response.users);
                    }
                },
                error: function() {
                    searchLoading.hide();
                    alert('Terjadi kesalahan saat melakukan pencarian');
                }
            });
        }

        searchInput.on('input', function() {
            const searchTerm = $(this).val().trim();
            clearTimeout(searchTimeout);

            searchTimeout = setTimeout(function() {
                performSearch(searchTerm);
            }, 300);
        });

        clearSearchBtn.on('click', function() {
            searchInput.val('');
            clearSearchBtn.hide();
            performSearch('');
        });

        function attachEventHandlers() {
            $('.deleteBtn').off('click').on('click', function(e) {
                e.preventDefault();
                const form = $(this).closest('form');

                Swal.fire({
                    title: 'Apakah kamu yakin?',
                    text: 'Anda tidak dapat mengembalikan user ini!',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Ya, hapus user ini!',
                    cancelButtonText: 'Batal'
                }).then((result) => {
                    if (result.isConfirmed) {
                        form.submit();
                    }
                });
            });

            $('.resetPasswordBtn').off('click').on('click', function(e) {
                e.preventDefault();
                const form = $(this).closest('form');

                Swal.fire({
                    title: 'Reset Password?',
                    text: 'User akan menerima email reset password dan seluruh token aktif akan dicabut.',
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonColor: '#f97316',
                    cancelButtonColor: '#6b7280',
                    confirmButtonText: 'Ya, Reset Password!',
                    cancelButtonText: 'Batal'
                }).then((result) => {
                    if (result.isConfirmed) {
                        form.submit();
                    }
                });
            });
        }

        attachEventHandlers();
    });
    </script>
@endpush
