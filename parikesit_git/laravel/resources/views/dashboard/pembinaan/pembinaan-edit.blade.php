@extends('dashboard.layout')
@section('title', 'Edit Pembinaan')
{{-- <link href="https://cdn.jsdelivr.net/npm/flowbite@3.1.2/dist/flowbite.min.css" rel="stylesheet" /> --}}

@section('content')
    <div class="card mt-6 p-8">
        <h4 class="h4 mb-4">Update Pembinaan</h4>

        <form action="{{ route('pembinaan.update', $pembinaan->id) }}" method="POST" enctype="multipart/form-data">
            @method('PUT')
            @csrf

            <div class="flex flex-col my-4">
                <label class="font-semibold">Nama Pembinaan</label>
                <input type="text"
                    class="p-2 rounded border border-gray-400 shadow focus:outline-none focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500 focus:bg-gray-200"
                    name="judul_pembinaan" value="{{ $pembinaan->judul_pembinaan }}" required readonly>
            </div>
            <div class="grid grid-cols-2 md:grid-cols-1 sm:grid-cols-1 lg:grid-cols-1 gap-4">
                <div class="col-span-1 border border-gray-300 bg-white p-4 rounded-md shadow-sm mt-4">
                    <div class="text-md font-bold text-gray-800 mb-4">Undangan</div>
                    <div class="flex items-center justify-between p-4 border rounded-md bg-white shadow-sm">
                        <div class="flex items-center">
                            <i class="fas fa-envelope text-blue-500 text-xl mr-3"></i>
                            <div>
                                <div class="font-semibold text-sm text-gray-800">Undangan</div>
                                {{-- <div class="text-xs text-gray-600 truncate">undangan_penilaian_mandiri.pdf</div> --}}
                            </div>
                        </div>
                        <a href="{{ asset($pembinaan->bukti_dukung_undangan_pembinaan) }}"
                            class="flex items-center text-gray-700 hover:text-black text-sm">
                            <i class="fas fa-eye mr-1"></i> Lihat File
                        </a>
                    </div>
                    <input type="file"
                        class="w-full p-2 rounded border border-gray-400 shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500 focus:bg-gray-200 mt-4"
                        name="bukti_dukung_undangan" accept=".pdf">
                    <p class="text-xs font-semibold text-red-600 mt-2">*File bukti dukung undangan harus pdf</p>
                </div>

                <div class="col-span-1 border border-gray-300 bg-white p-4 rounded-md shadow-sm mt-4">
                    <div class="text-md font-bold text-gray-800 mb-4">Daftar Hadir</div>
                    <div class="flex items-center justify-between p-4 border rounded-md bg-white shadow-sm">
                        <div class="flex items-center">
                            <i class="fas fa-users text-green-600 text-xl mr-3"></i>
                            <div>
                                <div class="font-semibold text-sm text-gray-800">Daftar Hadir</div>
                                {{-- <div class="text-xs text-gray-600 truncate">daftar_hadir_april.pdf</div> --}}
                            </div>
                        </div>
                        <a href="{{ asset($pembinaan->daftar_hadir_pembinaan) }}"
                            class="flex items-center text-gray-700 hover:text-black text-sm">
                            <i class="fas fa-eye mr-1"></i> Lihat File
                        </a>
                    </div>
                    <input type="file"
                        class="w-full p-2 rounded border border-gray-400 shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500 focus:bg-gray-200 mt-4"
                        name="daftar_hadir" accept=".pdf">
                    <p class="text-xs font-semibold text-red-600 mt-2">*File daftar hadir harus pdf</p>
                </div>

                <div class="col-span-1 border border-gray-300 bg-white p-4 rounded-md shadow-sm mt-4">
                    <div class="text-md font-bold text-gray-800 mb-4">Materi</div>
                    <div class="flex items-center justify-between p-4 border rounded-md bg-white shadow-sm">
                        <div class="flex items-center">
                            <i class="fas fa-file-alt text-orange-500 text-xl mr-3"></i>
                            <div>
                                <div class="font-semibold text-sm text-gray-800">Materi</div>
                                {{-- <div class="text-xs text-gray-600 truncate">notula_rapat_evaluasi.pdf</div> --}}
                            </div>
                        </div>
                        <a href="{{ asset($pembinaan->materi_pembinaan) }}"
                            class="flex items-center text-gray-700 hover:text-black text-sm">
                            <i class="fas fa-eye mr-1"></i> Lihat File
                        </a>
                    </div>
                    <input type="file"
                        class="w-full p-2 rounded border border-gray-400 shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500 focus:bg-gray-200 mt-4"
                        name="materi" accept=".pdf">
                    <p class="text-xs font-semibold text-red-600 mt-2">*File materi harus pdf</p>
                </div>

                <div class="col-span-1 border border-gray-300 bg-white p-4 rounded-md shadow-sm mt-4">
                    <div class="text-md font-bold text-gray-800 mb-4">Notula</div>
                    <div class="flex items-center justify-between p-4 border rounded-md bg-white shadow-sm">
                        <div class="flex items-center">
                            <i class="fas fa-file-alt text-gray-800 text-xl mr-3"></i>
                            <div>
                                <div class="font-semibold text-sm text-gray-800">Notula</div>
                                {{-- <div class="text-xs text-gray-600 truncate">notula_rapat_evaluasi.pdf</div> --}}
                            </div>
                        </div>
                        <a href="{{ asset($pembinaan->notula_pembinaan) }}"
                            class="flex items-center text-gray-700 hover:text-black text-sm">
                            <i class="fas fa-eye mr-1"></i> Lihat File
                        </a>
                    </div>
                    <input type="file"
                        class="w-full p-2 rounded border border-gray-400 shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500 focus:bg-gray-200 mt-4"
                        name="notula" accept=".pdf">
                    <p class="text-xs font-semibold text-red-600 mt-2">*File notula harus pdf</p>
                </div>
            </div>




            <div class="flex justify-end">
                <a href="{{ route('pembinaan.show', $pembinaan->id) }}"
                    class="mt-5 p-2 px-8 mr-4 bg-gray-300 text-gray-800 hover:bg-gray-400 ease-in-out transition duration-100 border rounded-md">Batal</a>
                <button type="submit"
                    class="mt-5 p-2 px-8 bg-blue-500 text-white hover:bg-blue-900 hover:text-white ease-in-out transition duration-100 border rounded-md">Perbarui</button>
            </div>

        </form>

    </div>
@endsection


@push('scripts')
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
                            window.location.href = "{{ route('pembinaan.index') }}";
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




        $("#addRow").click(function() {

            // Get the JSON data as an array

            // Create the options HTML using a loop
            var html = '';
            html += '<div id="inputFormRow">';
            html += '<div class="input-group mb-3">';
            html +=
                '<label class="block mb-2  font-semibold text-gray-900 dark:text-white" for="file_input">File Media</label>';
            html += '<div class="flex">';
            html +=
                '<input class="block p-2 w-full  text-gray-900 border border-gray-300 rounded-lg cursor-pointer bg-gray-50 dark:text-gray-400 focus:outline-none dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400" id="file_input" type="file" name="files[]" accept="image/*,video/*">';
            html += '<div class="input-group-append">';
            html += '<button id="removeRow" type="button" class="btn btn-danger">Kurangi</button>';
            html += '</div>';
            html += '</div>';
            html += '</div>';
            html += '</div>';

            // Append the new row to #newRow

            $('#newRow').append(html);
            // $('.livesearch').select2();
        });

        // remove row
        $(document).on('click', '#removeRow', function() {
            $(this).closest('#inputFormRow').remove();
            $(this).closest('#media').remove();
        });


        $('#gambar').change(function() {
            var reader = new FileReader();
            reader.onload = function(e) {
                $('#previewMakanan').attr('src', e.target.result);
            }
            reader.readAsDataURL(this.files[0]);
        });
    </script>
@endpush
