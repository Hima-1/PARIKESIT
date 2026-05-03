@extends('dashboard.layout')
<link href="https://cdn.jsdelivr.net/npm/flowbite@3.1.2/dist/flowbite.min.css" rel="stylesheet" />

@section('title', 'Detail : '. $pembinaan->judul_pembinaan)

@section('content')
    <div class="space-y-6">

        {{-- Judul --}}
        <div class="flex justify-between items-center">
            <h4 class="text-xl font-semibold text-gray-700">Pembinaan</h4>
        </div>



        <nav class="bg-white p-4 border-2 rounded-md w-full mb-4">
            <ol class="list-reset flex text-grey-dark">

                <li><a href="{{ route('pembinaan.index') }}" class="text-blue-600 hover:underline">Pembinaan</a></li>
                <li><span class="mx-2">&gt;</span></li>
                <li class="text-gray-700">Pembinaan : {{ $pembinaan->judul_pembinaan }}</li>
            </ol>
        </nav>


        {{-- Informasi Tahapan dan Kegiatan --}}

        <div class="grid grid-cols-4 md:grid-cols-1 gap-4">
            <!-- Box Kiri -->
            <div class="col-span-4 border-2 border-blue-400 bg-white p-4 rounded-md shadow-sm">
                {{-- <div class="text-md text-blue-600 font-bold mb-4">Nama pembinaan</div> --}}
                {{-- <div class="text-sm text-blue-700 mb-3">Penilaian Mandiri (1 April 2024 – 31 April 2024)</div> --}}
                {{-- <div class="text-xs text-gray-500 mb-3">Berakhir dalam 4 hari 5 jam 49 menit 24 detik</div> --}}
                <div class="border rounded-md p-3 bg-blue-50">
                    {{-- <div class="font-medium text-gray-700 mb-1">Kegiatan Statistik</div> --}}
                    <div class="flex justify-between">
                        <div class="">
                            <div class="text-2xl underline text-gray-800">
                                <div class="font-bold inline">
                                    {{ $pembinaan->judul_pembinaan }}
                                </div>
                            </div>
                            <div class="text-sm text-blue-600  mt-2">
                                {{ $pembinaan->created_at->format('d F Y') }} |
                                {{ $pembinaan->instansi ?? $pembinaan->profile->name }}</div>

                        </div>


                    </div>





                </div>


            </div>

            <div class="col-span-4">
                @if(Auth::user()->role === 'admin')
                <div class="flex gap-5">
                    <div class="w-1/2">
                        <a href="{{ route('pembinaan.edit', $pembinaan->id) }}"
                            class="w-full text-center block bg-indigo-800 text-white px-4 py-2 rounded hover:bg-gray-500 hover:text-black ">Edit</a>
                    </div>
                    <div class="w-1/2">
                        <form action="{{ route('pembinaan.destroy', $pembinaan->id) }}" method="POST"
                            id="form_delete">
                            @csrf
                            @method('DELETE')
                            <button type="button" id="delete_parent"
                                class=" w-full text-center block bg-red-700 text-white px-4 py-2 rounded hover:bg-red-900 hover:text-white" data-id="{{$pembinaan->id}}">Hapus</button>
                        </form>
                    </div>
                </div>
                @endif
            </div>




            <div class="col-span-4 border border-gray-300 bg-white p-4 rounded-md shadow-sm">
                <div class="text-md font-bold text-gray-800 mb-4">Dokumen Terkait</div>

                <div class="grid grid-cols-2 sm:grid-cols-2 lg:grid-cols-1 md:grid-cols-1 gap-4">
                    <!-- Item 1: PDF Undangan -->
                    <div class="flex items-center justify-between p-4 border rounded-md bg-white shadow-sm">
                        <div class="flex items-center">
                            <i class="fas fa-envelope text-blue-500 text-xl mr-3"></i>
                            <div>
                                <div class="font-semibold text-sm text-gray-800">Undangan</div>
                                {{-- <div class="text-xs text-gray-600 truncate">undangan_penilaian_mandiri.pdf</div> --}}
                            </div>
                        </div>
                        <a href="{{ asset($pembinaan->bukti_dukung_undangan_pembinaan) }}" target="_blank"
                            class="flex items-center text-gray-700 hover:text-black text-sm">
                            <i class="fas fa-download mr-1"></i> Lihat
                        </a>
                    </div>

                    <!-- Item 2: PDF Daftar Hadir -->
                    <div class="flex items-center justify-between p-4 border rounded-md bg-white shadow-sm">
                        <div class="flex items-center">
                            <i class="fas fa-users text-green-600 text-xl mr-3"></i>
                            <div>
                                <div class="font-semibold text-sm text-gray-800">Daftar Hadir</div>
                                {{-- <div class="text-xs text-gray-600 truncate">daftar_hadir_april.pdf</div> --}}
                            </div>
                        </div>
                        <a href="{{ asset( $pembinaan->daftar_hadir_pembinaan) }}" target="_blank"
                            class="flex items-center text-gray-700 hover:text-black text-sm">
                            <i class="fas fa-download mr-1"></i> Lihat
                        </a>
                    </div>

                    <!-- Item 3: PDF Notula -->
                    <div class="flex items-center justify-between p-4 border rounded-md bg-white shadow-sm">
                        <div class="flex items-center">
                            <i class="fas fa-file-alt text-orange-500 text-xl mr-3"></i>
                            <div>
                                <div class="font-semibold text-sm text-gray-800">Notula</div>
                                {{-- <div class="text-xs text-gray-600 truncate">notula_rapat_evaluasi.pdf</div> --}}
                            </div>
                        </div>
                        <a href="{{ asset( $pembinaan->notula_pembinaan) }}" target="_blank"
                            class="flex items-center text-gray-700 hover:text-black text-sm">
                            <i class="fas fa-download mr-1"></i> Lihat
                        </a>
                    </div>

                      <!-- Item 4: PDF Materi -->
                    <div class="flex items-center justify-between p-4 bg-white rounded-md shadow-sm border border-gray-300">
                        <div class="flex items-center">
                            <i class="fas fa-file-alt text-gray-800 text-xl mr-3"></i>
                            <div>
                                <div class="font-semibold text-sm text-gray-800">Materi</div>
                                {{-- <div class="text-xs text-gray-600 truncate">notula_rapat_evaluasi.pdf</div> --}}
                            </div>
                        </div>
                        <a href="{{ asset( $pembinaan->materi_pembinaan) }}" target="_blank"
                            class="flex items-center text-gray-700 hover:text-black text-sm">
                            <i class="fas fa-download mr-1"></i> Lihat
                        </a>
                    </div>
                </div>
            </div>

        </div>






        <div class="grid grid-cols-1 md:grid-cols-1 lg:grid-cols-1 sm:grid-cols-1 gap-4">
            <div class="bg-gray-100 min-h-100 w-100 p-5 border border-gray-500 rounded">
                <div class="font-semibold text-gray-700 mb-2">Media</div>



                <table class="min-w-full bg-white border border-gray-300">
                    <thead>
                        <tr>
                            <th class="px-6 py-3 border-b-2 border-gray-300 text-left text-sm font-semibold text-gray-600">No</th>
                            <th class="px-6 py-3 border-b-2 border-gray-300 text-left text-sm font-semibold text-gray-600">Media</th>
                            <th class="px-6 py-3 border-b-2 border-gray-300 text-left text-sm font-semibold text-gray-600">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="text-gray-700">
                        @foreach ($pembinaan->file_pembinaan as $index => $media)
                            <tr>
                                <td class="px-6 py-4 border-b border-gray-300">{{ $index + 1 }}</td>
                                <td class="px-6 py-4 border-b border-gray-300">
                                    <img src="{{ asset($media->nama_file) }}" class="h-32 w-32 object-cover shadow-sm border p-1" alt="Media">
                                </td>
                                <td class="px-6 py-4 border-b border-gray-300">
                                    <a href="{{ asset($media->nama_file) }}" target="_blank" class="bg-blue-500 hover:bg-blue-600 dark:bg-dark-400 dark:hover:bg-dark-500 transition duration-300 ease-in-out text-white hover:text-blue-50 font-semibold px-2 py-3 rounded mr-2">Lihat</a>
                                    <button type="button" data-id="{{ $media->id }}" class="deleteBtn bg-red-500 hover:bg-red-600 dark:bg-dark-400 dark:hover:bg-dark-500 transition duration-300 ease-in-out text-white hover:text-red-50 font-semibold px-2 py-3 rounded">Hapus</button>
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>

            </div>

        </div>

        <div class="mt-4 flex space-x-2">
            <a href="{{ route('pembinaan.index') }}"
                class="bg-indigo-800 text-white px-4 py-4 rounded hover:bg-gray-500 hover:text-black">Kembali</a>

            <a href="{{ route('pembinaan.download-all', $pembinaan->id) }}"
                class="bg-green-600 text-white px-4 py-4 rounded hover:bg-green-700 flex items-center">
                <i class="fas fa-download mr-2"></i> Download Semua File
            </a>
        </div>



        {{-- Tabel Nilai IPS --}}

    </div>
@endsection

@push('scripts')
    <script>
        $('.deleteBtn').click(function(e) {

            var id = $(this).data('id');

            Swal.fire({
                title: 'Apakah kamu yakin?',
                text: "Anda tidak dapat mengembalikan pembinaan ini!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ya, hapus media pembinaan ini!'
            }).then((result) => {
                if (result.isConfirmed) {
                    e.preventDefault();
                    window.location.href = "{{ route('filePemb.destroy', ['filePemb' => ':id']) }}".replace(':id', id);

                }
            })
        });


        $('#delete_parent').click(function(e) {

            var id = $(this).data('id');

            Swal.fire({
                title: 'Apakah kamu yakin?',
                text: "Anda tidak dapat mengembalikan data pembinaan ini!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ya, hapus data pembinaan ini!'
            }).then((result) => {
                if (result.isConfirmed) {
                    e.preventDefault();
                    $('#form_delete').submit();

                }
            })
        });

    </script>
@endpush
