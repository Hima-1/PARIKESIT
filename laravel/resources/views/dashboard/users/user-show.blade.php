@extends('dashboard.layout')
@section('content')
    <div class="card mt-6 p-8 max-w-5xl mx-auto shadow-lg rounded-lg">
        <div class="border-b pb-4 mb-6">
            <h4 class="h4 text-2xl font-bold text-gray-800">Detail Pengguna</h4>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div class="space-y-4">
                <div class="bg-gray-50 p-4 rounded-lg shadow-sm">
                    <label class="block text-sm font-medium text-gray-600 mb-2">Nama</label>
                    <div class="flex items-center">
                        <i class="fas fa-user mr-3 text-blue-500"></i>
                        <span class="text-lg font-semibold text-gray-800">{{ $user->name }}</span>
                    </div>
                </div>

                <div class="bg-gray-50 p-4 rounded-lg shadow-sm">
                    <label class="block text-sm font-medium text-gray-600 mb-2">Email</label>
                    <div class="flex items-center">
                        <i class="fas fa-envelope mr-3 text-green-500"></i>
                        <span class="text-lg font-semibold text-gray-800">{{ $user->email }}</span>
                    </div>
                </div>

                <div class="bg-gray-50 p-4 rounded-lg shadow-sm">
                    <label class="block text-sm font-medium text-gray-600 mb-2">Role</label>
                    <div class="flex items-center">
                        <i class="fas fa-user-tag mr-3 text-purple-500"></i>
                        <span class="text-lg font-semibold text-gray-800 uppercase
                            @if($user->role == 'admin') text-blue-600
                            @elseif($user->role == 'opd') text-yellow-600
                            @else text-green-600
                            @endif">
                            {{ $user->role }}
                        </span>
                    </div>
                </div>
            </div>

            <div class="space-y-4">
                <div class="bg-gray-50 p-4 rounded-lg shadow-sm">
                    <label class="block text-sm font-medium text-gray-600 mb-2">Nomor Telepon</label>
                    <div class="flex items-center">
                        <i class="fas fa-phone mr-3 text-indigo-500"></i>
                        <span class="text-lg font-semibold text-gray-800">{{ $user->nomor_telepon }}</span>
                    </div>
                </div>

                <div class="bg-gray-50 p-4 rounded-lg shadow-sm">
                    <label class="block text-sm font-medium text-gray-600 mb-2">Alamat</label>
                    <div class="flex items-center">
                        <i class="fas fa-map-marker-alt mr-3 text-red-500"></i>
                        <span class="text-lg font-semibold text-gray-800">{{ $user->alamat }}</span>
                    </div>
                </div>

                <div class="bg-gray-50 p-4 rounded-lg shadow-sm">
                    <label class="block text-sm font-medium text-gray-600 mb-2">Tanggal Dibuat</label>
                    <div class="flex items-center">
                        <i class="fas fa-calendar-alt mr-3 text-teal-500"></i>
                        <span class="text-lg font-semibold text-gray-800">
                            {{ \Carbon\Carbon::parse($user->created_at)->locale('id')->isoFormat('dddd, D MMMM Y') }}
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <div class="flex justify-end space-x-4 mt-6">
            <a href="{{ route('user.index') }}"
               class="px-4 py-2 bg-gray-300 text-gray-800 rounded-md hover:bg-gray-400 transition duration-200 flex items-center">
                <i class="fas fa-arrow-left mr-2"></i>Kembali
            </a>
            <a href="{{ route('user.edit', $user->id) }}"
               class="px-4 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600 transition duration-200 flex items-center">
                <i class="fas fa-edit mr-2"></i>Edit
            </a>
        </div>
    </div>
@endsection
