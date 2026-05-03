@extends('dashboard.layout')
@section('title','Tambah User')
@section('content')
    <div class="card mt-6 p-8">
        <h4 class="h4 mb-4">Tambah User</h4>


        <form action="{{ route('user.store') }}" method="POST" id="form_create">

            @csrf
            <div class="flex flex-col gap mb-3">
                <label class="font-semibold">Nama</label>
                <input type="text"
                    class="p-2 rounded border border-gray-400 shadow focus:outline-none focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500 focus:bg-gray-200"
                    name="name" value="{{ old('name') }}" required>
            </div>

            <div class="flex flex-col gap mb-3">
                <label class="font-semibold">Email</label>
                <input type="email"
                    class="p-2 rounded border border-gray-400 shadow focus:outline-none focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500 focus:bg-gray-200"
                    name="email" value="{{ old('email') }}" required>
            </div>

            <div class="flex flex-col gap mb-3">
                <label class="font-semibold">Password</label>
                <div class="relative">
                    <input type="password"
                        class="p-2 rounded border border-gray-400 shadow focus:outline-none focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500 focus:bg-gray-200 w-full"
                        name="password" id="password" required>
                    <button type="button" id="togglePassword" class="absolute inset-y-0 right-0 px-3 flex items-center text-gray-600 hover:text-blue-500">
                        <i id="passwordIcon" class="fas fa-eye-slash"></i>
                    </button>
                </div>
            </div>

            <div class="flex flex-col gap mb-3">
                <label class="font-semibold">Role</label>
                <select name="role"
                    class="p-2 rounded border border-gray-400 shadow focus:outline-none focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500 focus:bg-gray-200">
                    <option value="admin" {{ old('role') == 'admin' ? 'selected' : '' }}>Admin</option>
                    <option value="opd" {{ old('role') == 'opd' ? 'selected' : '' }}>OPD</option>
                    <option value="walidata" {{ old('role') == 'walidata' ? 'selected' : '' }}>Walidata</option>
                </select>
            </div>

            <div class="flex flex-col gap mb-3">
                <label class="font-semibold">Alamat</label>
                <input type="text"
                    class="p-2 rounded border border-gray-400 shadow focus:outline-none focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500 focus:bg-gray-200"
                    name="alamat" value="{{ old('alamat') }}" required>
            </div>

            <div class="flex flex-col gap mb-3">
                <label class="font-semibold">Nomor Telepon</label>
                <input type="text"
                    class="p-2 rounded border border-gray-400 shadow focus:outline-none focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500 focus:bg-gray-200"
                    name="nomor_telepon" value="{{ old('nomor_telepon') }}" required>
            </div>


            <div class="flex justify-end space-x-4 mt-6">
                <a href="{{ route('user.index') }}"
                   class="px-4 py-2 bg-gray-300 text-gray-800 rounded-md hover:bg-gray-400 transition duration-200 ease-in-out">
                    Batal
                </a>
                <button type="submit"
                        class="px-4 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600 transition duration-200 ease-in-out">
                    Simpan
                </button>
            </div>
        </form>


    </div>
@endsection

@push('scripts')
    <script>
    $(document).ready(function() {
        const passwordInput = $('#password');
        const togglePasswordBtn = $('#togglePassword');
        const passwordIcon = $('#passwordIcon');

        togglePasswordBtn.on('click', function() {
            if (passwordInput.attr('type') === 'password') {
                passwordInput.attr('type', 'text');
                passwordIcon.removeClass('fa-eye-slash').addClass('fa-eye');
            } else {
                passwordInput.attr('type', 'password');
                passwordIcon.removeClass('fa-eye').addClass('fa-eye-slash');
            }
        });
    });
    </script>
@endpush
