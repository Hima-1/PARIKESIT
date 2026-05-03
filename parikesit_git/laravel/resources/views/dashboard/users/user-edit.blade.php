@extends('dashboard.layout')
@section('content')
    <div class="card mt-6 p-8 max-w-5xl mx-auto shadow-lg rounded-lg">
        <div class="flex justify-between items-center mb-6 border-b pb-4">
            <h4 class="h4 text-2xl font-bold text-gray-800">Edit Pengguna</h4>
            {{-- <a href="{{ route('user.index') }}"
               class="px-4 py-2 bg-gray-300 text-gray-800 rounded-md hover:bg-gray-400 transition duration-200 flex items-center">
                <i class="fas fa-arrow-left mr-2"></i>Kembali
            </a> --}}
        </div>

        <form action="{{ route('user.update', $user->id) }}" method="POST">
            @method('PUT')
            @csrf

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="space-y-4">
                    <div class="flex flex-col">
                        <label class="text-sm font-medium text-gray-600 mb-2">Nama</label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-gray-500">
                                <i class="fas fa-user"></i>
                            </span>
                            <input type="text"
                                class="w-full pl-10 p-2 rounded border border-gray-300 shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                                name="name" value="{{ $user->name }}" required>
                        </div>
                    </div>

                    <div class="flex flex-col">
                        <label class="text-sm font-medium text-gray-600 mb-2">Email</label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-gray-500">
                                <i class="fas fa-envelope"></i>
                            </span>
                            <input type="email"
                                class="w-full pl-10 p-2 rounded border border-gray-300 shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                                name="email" value="{{ $user->email }}" required>
                        </div>
                    </div>
                </div>

                <div class="space-y-4">
                    <div class="flex flex-col">
                        <label class="text-sm font-medium text-gray-600 mb-2">Alamat</label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-gray-500">
                                <i class="fas fa-map-marker-alt"></i>
                            </span>
                            <input type="text"
                                class="w-full pl-10 p-2 rounded border border-gray-300 shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                                name="alamat" value="{{ $user->alamat }}" required>
                        </div>
                    </div>

                    <div class="flex flex-col">
                        <label class="text-sm font-medium text-gray-600 mb-2">Nomor Telepon</label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-gray-500">
                                <i class="fas fa-phone"></i>
                            </span>
                            <input type="text"
                                class="w-full pl-10 p-2 rounded border border-gray-300 shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                                name="nomor_telepon" value="{{ $user->nomor_telepon }}" required>
                        </div>
                    </div>
                </div>
            </div>

            <div class="mt-6">
                <label class="text-sm font-medium text-gray-600 mb-2">Role</label>
                <select name="role"
                    class="w-full p-2 rounded border border-gray-300 shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500">
                    <option value="admin" {{ $user->role == 'admin' ? 'selected' : '' }}>Admin</option>
                    <option value="opd" {{ $user->role == 'opd' ? 'selected' : '' }}>OPD</option>
                    <option value="walidata" {{ $user->role == 'walidata' ? 'selected' : '' }}>Walidata</option>
                </select>
            </div>

            @if(Auth::user()->role == 'admin')
                <div class="mt-6 border-t pt-6">
                    <div class="bg-yellow-50 border-l-4 border-yellow-400 p-4 mb-4">
                        <div class="flex">
                            <div class="flex-shrink-0">
                                <i class="fas fa-exclamation-triangle text-yellow-400"></i>
                            </div>
                            <div class="ml-3">
                                <p class="text-sm text-yellow-700">
                                    <strong>Ubah Password (Opsional)</strong><br>
                                    Kosongkan jika tidak ingin mengubah password. Password minimal 8 karakter.
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="flex flex-col">
                        <label class="text-sm font-medium text-gray-600 mb-2">
                            Password Baru (Opsional)
                        </label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-gray-500">
                                <i class="fas fa-lock"></i>
                            </span>
                            <input type="password" id="password"
                                class="w-full pl-10 p-2 rounded border border-gray-300 shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                                name="password" placeholder="Masukkan password baru (min. 8 karakter)">
                        </div>
                        @error('password')
                            <span class="text-red-500 text-sm mt-1">{{ $message }}</span>
                        @enderror
                    </div>
                </div>
            @endif

            <div class="flex justify-end space-x-4 mt-6">
                <a href="{{ route('user.index') }}"
                   class="px-4 py-2 bg-gray-300 text-gray-800 rounded-md hover:bg-gray-400 transition duration-200 flex items-center">
                    <i class="fas fa-arrow-left mr-2"></i>Kembali
                </a>
                <button type="submit"
                    class="px-4 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600 transition duration-200 ease-in-out flex items-center">
                    <i class="fas fa-save mr-2"></i>Perbarui
                </button>
            </div>
        </form>
    </div>
@endsection



{{-- @push('scripts')
    <script>
        $(document).ready(function() {
            $('#form_create').submit(function(e) {
                e.preventDefault();

                $.ajax({
                    url: $(this).attr('action'),
                    method: $(this).attr('method'),
                    data: new FormData(this),
                    processData: false,
                    dataType: 'json',
                    contentType: false,
                    success: function(response) {
                        if (response.status) {
                            swal("Berhasil", response.message, "success");
                            window.location.href = "{{ route('formulir.index') }}";
                        } else {
                            swal("Gagal", response.message, "error");
                        }
                    },
                    error: function(xhr, ajaxOptions, thrownError) {
                        swal("Gagal", xhr.responseText, "error");
                    }
                });
            });
        });
    </script>
@endpush --}}
