@extends('dashboard.layout')
@section('content')
    <div class="card mt-6 p-8">

        <div class="flex justify-between mb-4">
            <h4 class="h4">Formulir</h4>


            <a href="{{ route('formulir.create') }}"
                class="py-3 px-8 bg-blue-600 rounded shadow text-white hover:text-blue-200 hover:bg-gray-800 transform duration-100 ease-in-out">Tambah
                Formulir</a>

        </div>

        <hr class="my-4 border-t-2 border-gray-300">


        <div class="grid grid-cols-4 md:grid-cols-2 gap-4">
            @foreach ($formulirs as $form)
                <div class="bg-white shadow-md rounded px-8 pt-6 pb-8">
                    <div class="flex items-center justify-between">
                        <h5 class="text-xl">{{ $form->nama_formulir }}</h5>

                    </div>

                    <p class="text-gray-600 text-sm">{{ $form->tanggal_dibuat }}</p>

                    <div class="flex mt-4 gap-1">
                        <a href="{{ route('formulir.show', $form->id) }}"
                            class="py-1 px-4 text-small bg-gray-500 rounded shadow text-dark-500 hover:text-blue-200 hover:bg-gray-800 transform duration-100 ease-in-out">Lihat</a>
                        <a href="{{ route('formulir.edit', $form->id) }}"
                            class="py-1 px-4 text-small btn btn-success text-dark rounded shadow text-dark-500 hover:text-blue-200 hover:bg-green-700 transform duration-100 ease-in-out">Edit</a>


                        <form action="{{ route('formulir.destroy', $form->id) }}" method="POST" id="form_delete">
                            @method('DELETE')
                            @csrf
                            <button type="button" data-id="{{ $form->id }}" data-nama="{{ $form->nama_formulir }}"
                                class="py-1 px-4 text-small bg-red-700 text-white rounded shadow text-dark-500 hover:text-black hover:bg-red-400 transform duration-100 ease-in-out deleteBtn"
                                data-id="{{ $form->id }}">Delete</button>
                        </form>

                    </div>

                </div>
            @endforeach
        </div>

    </div>
@endsection

@push('scripts')
    <script>
        $('.deleteBtn').click(function(e) {

            var id = $(this).data('id');

            Swal.fire({
                title: 'Apakah kamu yakin?',
                text: "Anda tidak dapat mengembalikan formulir ini!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ya, hapus formulir ini!'
            }).then((result) => {
                if (result.isConfirmed) {
                    e.preventDefault();
                    $('#form_delete').submit();

                }
            })
        });
    </script>
@endpush
