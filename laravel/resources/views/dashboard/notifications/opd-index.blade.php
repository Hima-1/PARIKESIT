@extends('dashboard.layout')
@section('title', 'Notifikasi OPD')
@section('content')
    <div class="card p-8">
        <div class="flex justify-between mb-4">
            <div>
                <h4 class="h4">Notifikasi OPD</h4>
                <p class="text-sm text-gray-600 mt-2">Kirim reminder pengisian formulir ke user OPD dari halaman khusus ini.</p>
            </div>
        </div>

        <hr class="my-4 border-t-2 border-gray-300">

        <form id="allReminderForm" action="{{ route('user.trigger-opd-reminder.all') }}" method="POST" class="hidden">
            @csrf
        </form>

        <form id="bulkReminderForm" action="{{ route('user.trigger-opd-reminder.bulk') }}" method="POST" class="hidden">
            @csrf
        </form>

        <div class="mb-4 flex space-x-4">
            <div class="relative w-full">
                <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-gray-500">
                    <i class="fas fa-search"></i>
                </span>
                <input type="text" id="searchUser"
                    value="{{ $search }}"
                    placeholder="Cari user OPD (nama atau email)..."
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
            <p class="text-lg font-medium">Tidak ada user OPD yang cocok dengan pencarian "<span id="searchTerm">{{ $search }}</span>"</p>
        </div>

        <div class="mb-4 flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
            <div class="text-sm text-gray-600">
                Total {{ $opdTotal }} user OPD tersedia untuk notifikasi.
            </div>
            <div class="flex flex-col gap-2 sm:flex-row">
                <button type="button" id="allReminderButton"
                    class="rounded bg-blue-600 px-4 py-2 text-sm font-medium text-white disabled:cursor-not-allowed disabled:bg-blue-300"
                    {{ $opdTotal === 0 ? 'disabled' : '' }}>
                    Kirim Notifikasi Semua OPD
                </button>
                <button type="button" id="bulkReminderButton"
                    class="rounded border border-blue-600 px-4 py-2 text-sm font-medium text-blue-700 disabled:cursor-not-allowed disabled:border-blue-200 disabled:text-blue-300"
                    disabled>
                    Kirim ke yang Dicentang
                </button>
            </div>
        </div>

        <div id="usersTableWrapper">
            <table class="table-auto table-bordered w-full">
                <thead>
                    <tr class="bg-blue-200 border-2">
                        <th class="px-4 py-2 text-center w-12">
                            <input type="checkbox" id="selectAllOpd"
                                class="h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                                title="Pilih semua OPD di halaman ini"
                                aria-label="Pilih semua OPD di halaman ini"
                                {{ $users->isEmpty() ? 'disabled' : '' }}>
                        </th>
                        <th class="px-4 py-2 text-left">
                            <a href="{{ route('opd-notifications.index', ['sort' => 'name', 'direction' => $sortBy == 'name' && $sortDirection == 'asc' ? 'desc' : 'asc', 'search' => $search]) }}"
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
                        <th class="px-4 py-2 text-left">
                            <a href="{{ route('opd-notifications.index', ['sort' => 'email', 'direction' => $sortBy == 'email' && $sortDirection == 'asc' ? 'desc' : 'asc', 'search' => $search]) }}"
                                class="flex items-center space-x-2 hover:text-blue-800 transition-colors">
                                <span class="font-semibold">Email</span>
                                @if($sortBy == 'email')
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
                        <th class="px-4 py-2 text-left">
                            <a href="{{ route('opd-notifications.index', ['sort' => 'created_at', 'direction' => $sortBy == 'created_at' && $sortDirection == 'asc' ? 'desc' : 'asc', 'search' => $search]) }}"
                                class="flex items-center space-x-2 hover:text-blue-800 transition-colors">
                                <span class="font-semibold">Tanggal Dibuat</span>
                                @if($sortBy == 'created_at')
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
                        <th class="px-4 py-2 text-left">Aksi</th>
                    </tr>
                </thead>
                <tbody id="usersTableBody">
                    @foreach ($users as $user)
                        <tr class="user-row border border-1">
                            <td class="px-4 py-2 text-center">
                                <input type="checkbox"
                                    name="user_ids[]"
                                    value="{{ $user->id }}"
                                    form="bulkReminderForm"
                                    class="opd-user-checkbox h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500">
                            </td>
                            <td class="px-4 py-2 user-name">{{ $user->name }}</td>
                            <td class="px-4 py-2 user-email">{{ $user->email }}</td>
                            <td class="px-4 py-2 user-created-at">
                                {{ \Carbon\Carbon::parse($user->created_at)->locale('id')->isoFormat('dddd, D MMMM Y') }}
                            </td>
                            <td class="px-4 py-2">
                                <form action="{{ route('user.trigger-opd-reminder', $user->id) }}" method="POST" class="inline reminderForm">
                                    @csrf
                                    <button type="button"
                                        class="text-blue-600 hover:text-blue-800 border rounded-md p-2 triggerReminderBtn"
                                        data-user-name="{{ $user->name }}"
                                        title="Kirim Reminder">
                                        <i class="fas fa-bell text-sm"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    @endforeach
                </tbody>
            </table>
        </div>

        <div id="paginationSummary" class="mt-4 text-sm text-gray-600 {{ $users->total() === 0 ? 'hidden' : '' }}">
            Menampilkan {{ $users->firstItem() ?? 0 }} sampai {{ $users->lastItem() ?? 0 }} dari {{ $users->total() }} user OPD
        </div>

        <div id="paginationWrapper" class="mt-4 {{ $users->hasPages() ? '' : 'hidden' }}">
            {{ $users->onEachSide(1)->links() }}
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
        const selectAllOpd = $('#selectAllOpd');
        const allReminderButton = $('#allReminderButton');
        const allReminderForm = $('#allReminderForm');
        const bulkReminderButton = $('#bulkReminderButton');
        const bulkReminderForm = $('#bulkReminderForm');
        const paginationSummary = $('#paginationSummary');
        const paginationWrapper = $('#paginationWrapper');

        let searchTimeout;
        const currentSortBy = '{{ $sortBy }}';
        const currentSortDirection = '{{ $sortDirection }}';
        const baseUrl = '{{ url("/") }}';
        const csrfToken = '{{ csrf_token() }}';

        function escapeHtml(value) {
            return $('<div>').text(value ?? '').html();
        }

        function bulkSelectionCount() {
            return $('.opd-user-checkbox:checked').length;
        }

        function updateBulkReminderState() {
            const opdCheckboxes = $('.opd-user-checkbox');
            const checkedCount = bulkSelectionCount();
            const hasAnyOpd = opdCheckboxes.length > 0;

            bulkReminderButton.prop('disabled', checkedCount === 0);
            selectAllOpd.prop('disabled', !hasAnyOpd);
            selectAllOpd.prop('checked', hasAnyOpd && checkedCount === opdCheckboxes.length);
            selectAllOpd.prop('indeterminate', checkedCount > 0 && checkedCount < opdCheckboxes.length);
        }

        function renderUsersTable(users) {
            if (users.length === 0) {
                usersTableWrapper.hide();
                noResultsMessage.show();
                usersTableBody.html('');
                updateBulkReminderState();
                return;
            }

            usersTableWrapper.show();
            noResultsMessage.hide();

            let html = '';
            users.forEach(function(user) {
                html += '<tr class="user-row border border-1">';
                html += '<td class="px-4 py-2 text-center">';
                html += '<input type="checkbox" name="user_ids[]" value="' + user.id + '" form="bulkReminderForm" class="opd-user-checkbox h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500">';
                html += '</td>';
                html += '<td class="px-4 py-2 user-name">' + escapeHtml(user.name) + '</td>';
                html += '<td class="px-4 py-2 user-email">' + escapeHtml(user.email) + '</td>';
                html += '<td class="px-4 py-2 user-created-at">' + escapeHtml(user.created_at) + '</td>';
                html += '<td class="px-4 py-2">';
                html += '<form action="' + baseUrl + '/user/' + user.id + '/trigger-opd-reminder" method="POST" class="inline reminderForm">';
                html += '<input type="hidden" name="_token" value="' + csrfToken + '">';
                html += '<button type="button" class="text-blue-600 hover:text-blue-800 border rounded-md p-2 triggerReminderBtn" data-user-name="' + escapeHtml(user.name) + '" title="Kirim Reminder">';
                html += '<i class="fas fa-bell text-sm"></i>';
                html += '</button>';
                html += '</form>';
                html += '</td>';
                html += '</tr>';
            });

            usersTableBody.html(html);
            attachEventHandlers();
            updateBulkReminderState();
        }

        function updatePagination(pagination) {
            if (!pagination || pagination.total === 0) {
                paginationSummary.addClass('hidden').text('');
                paginationWrapper.addClass('hidden').html('');
                return;
            }

            paginationSummary
                .removeClass('hidden')
                .text('Menampilkan ' + pagination.from + ' sampai ' + pagination.to + ' dari ' + pagination.total + ' user OPD');

            if (pagination.last_page > 1 && pagination.links_html) {
                paginationWrapper.removeClass('hidden').html(pagination.links_html);
            } else {
                paginationWrapper.addClass('hidden').html('');
            }
        }

        function performSearch(searchTerm) {
            searchLoading.show();
            clearSearchBtn.hide();

            $.ajax({
                url: '{{ route("opd-notifications.index") }}',
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
                        updatePagination(response.pagination);
                        updateBulkReminderState();
                    } else {
                        renderUsersTable(response.users);
                        updatePagination(response.pagination);
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
            $('.triggerReminderBtn').off('click').on('click', function(e) {
                e.preventDefault();
                const form = $(this).closest('form');
                const userName = $(this).data('user-name');

                Swal.fire({
                    title: 'Kirim reminder?',
                    text: 'Reminder pengisian formulir akan dikirim ke ' + userName + '.',
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonColor: '#2563eb',
                    cancelButtonColor: '#6b7280',
                    confirmButtonText: 'Ya, kirim reminder',
                    cancelButtonText: 'Batal'
                }).then((result) => {
                    if (result.isConfirmed) {
                        form.submit();
                    }
                });
            });

            $('.opd-user-checkbox').off('change').on('change', function() {
                updateBulkReminderState();
            });
        }

        selectAllOpd.on('change', function() {
            $('.opd-user-checkbox').prop('checked', $(this).is(':checked'));
            updateBulkReminderState();
        });

        allReminderButton.on('click', function(e) {
            e.preventDefault();

            Swal.fire({
                title: 'Kirim notifikasi semua OPD?',
                text: 'Reminder akan dikirim ke seluruh user OPD.',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#2563eb',
                cancelButtonColor: '#6b7280',
                confirmButtonText: 'Ya, kirim notifikasi',
                cancelButtonText: 'Batal'
            }).then((result) => {
                if (result.isConfirmed) {
                    allReminderForm.trigger('submit');
                }
            });
        });

        bulkReminderButton.on('click', function(e) {
            e.preventDefault();

            const selectedCount = bulkSelectionCount();
            if (selectedCount === 0) {
                return;
            }

            Swal.fire({
                title: 'Kirim notifikasi terpilih?',
                text: 'Reminder akan dikirim ke ' + selectedCount + ' user OPD yang dicentang.',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#2563eb',
                cancelButtonColor: '#6b7280',
                confirmButtonText: 'Ya, kirim notifikasi',
                cancelButtonText: 'Batal'
            }).then((result) => {
                if (result.isConfirmed) {
                    bulkReminderForm.trigger('submit');
                }
            });
        });

        attachEventHandlers();
        updateBulkReminderState();
        updatePagination({
            from: {{ $users->firstItem() ?? 0 }},
            to: {{ $users->lastItem() ?? 0 }},
            total: {{ $users->total() }},
            last_page: {{ $users->lastPage() }},
            links_html: @json($users->onEachSide(1)->links()->toHtml()),
        });
    });
    </script>
@endpush
