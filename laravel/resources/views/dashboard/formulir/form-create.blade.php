@extends('dashboard.layout')
@section('content')
    <div class="card mt-6 p-8">
        <h4 class="h4 mb-4">Tambah Formulir</h4>


        <form action="{{ route('formulir.store') }}" method="POST" id="form_create">

            @csrf

            <div class="flex flex-col gap">
                <label class="font-semibold">Nama Formulir</label>
                <input type="text"
                    class="p-2 rounded border border-gray-400 shadow focus:outline-none focus:ring-2 focus:ring-indigo-200 focus:border-indigo-500 focus:bg-gray-200"
                    name="nama_formulir" required>

            </div>


            <button
                class="mt-5 p-2 px-8 bg-blue-500 text-white hover:bg-blue-900 hover:text-white ease-in-out transition duration-100 border rounded-md">Tambahkan</button>
        </form>


    </div>
@endsection



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
