@extends('dashboard.layout')
@section('title', 'Tambah Dokumentasi Kegiatan')
{{-- <link href="https://cdn.jsdelivr.net/npm/flowbite@3.1.2/dist/flowbite.min.css" rel="stylesheet" /> --}}

@section('content')
    <div class="card mt-6 p-8">
        <h4 class="h4 mb-4">Tambah Dokumentasi Kegiatan</h4>

        <form action="{{ route('dokumentasi.store') }}" method="POST" enctype="multipart/form-data">

            @csrf

            <div class="flex flex-col my-4">
                <label class="font-semibold">Nama Dokumentasi Kegiatan</label>
                <input type="text"
                    class="p-2 rounded border border-gray-400 shadow focus:outline-none focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500 focus:bg-gray-200"
                    name="judul_dokumentasi" value="{{ old('judul_dokumentasi') }}" required>
            </div>
            <div class="flex flex-col my-4">
                <label class="font-semibold">Undangan</label>
                <input type="file"
                    class="p-2 rounded border border-gray-400 shadow focus:outline-none focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500 focus:bg-gray-200"
                    name="bukti_dukung_undangan" required accept=".pdf">
                <p class="text-xs font-semibold text-red-600 mt-2">*File undangan harus pdf</p>
            </div>

            <div class="flex flex-col my-4">
                <label class="font-semibold">Daftar Hadir</label>
                <input type="file"
                    class="p-2 rounded border border-gray-400 shadow focus:outline-none focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500 focus:bg-gray-200"
                    name="daftar_hadir" required accept=".pdf">
                <p class="text-xs font-semibold text-red-600 mt-2">*File daftar hadir harus pdf</p>
            </div>

            <div class="flex flex-col my-4">
                <label class="font-semibold">Materi</label>
                <input type="file"
                    class="p-2 rounded border border-gray-400 shadow focus:outline-none focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500 focus:bg-gray-200"
                    name="materi" required accept=".pdf">
                <p class="text-xs font-semibold text-red-600 mt-2">*File materi harus pdf</p>
            </div>

            <div class="flex flex-col my-4">
                <label class="font-semibold">Notula</label>
                <input type="file"
                    class="p-2 rounded border border-gray-400 shadow focus:outline-none focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500 focus:bg-gray-200"
                    name="notula" required accept=".pdf">
                <p class="text-xs font-semibold text-red-600 mt-2">*File notula harus pdf</p>
            </div>

            <div class="grid grid-cols-1 my-4">
                <div class="col-span-1">
                    <div id="inputFormRow">
                        <div class="input-group mb-3">
                            <label class="block mb-2 font-semibold text-gray-900 dark:text-white" for="file_input">File Media</label>
                            <div class="flex">
                                <input
                                    class="block p-2 w-full text-gray-900 border border-gray-300 rounded-lg cursor-pointer bg-gray-50 dark:text-gray-400 focus:outline-none dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400"
                                    id="file_input" type="file" name="files[]" accept="image/*,video/*">
                                <div class="input-group-append">
                                    <button id="removeRow" type="button" class="btn btn-danger">Kurangi</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="newRow"></div>
                    <button id="addRow" type="button" class="btn btn-sm text-black bg-green-300 border-2 mb-4">Tambah Input Media File</button>
                </div>
            </div>

            <div class="flex justify-end space-x-4 mt-6">
                <a href="{{ route('dokumentasi.index') }}"
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
                            window.location.href = "{{ route('dokumentasi.index') }}";
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
