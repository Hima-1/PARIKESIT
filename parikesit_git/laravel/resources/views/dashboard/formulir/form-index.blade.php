@extends('dashboard.layout')
@section('title','Formulir')
@section('content')
    <div class="card p-8">

        <div class="flex justify-between mb-4">
            <h4 class="h4">Formulir</h4>


            <a href="{{ route('formulir.create') }}"
                class="py-3 px-8 bg-blue-600 rounded shadow text-white hover:text-blue-200 hover:bg-gray-800 transform duration-100 ease-in-out">Tambah
                Formulir</a>

        </div>

        <hr class="my-4 border-t-2 border-gray-300">


        <div class="grid grid-cols-3 lg:grid-cols-2 md:grid-cols-1 sm:grid-cols-1 gap-6">
            @foreach ($formulirs as $form)
                <div class="border rounded-lg shadow p-6 bg-white hover:bg-gray-50 transition ease-in-out duration-150">
                    @if ($form->domains->count() == 0)
                        <div
                            class="border border-red-500 p-2 mb-2 rounded-md hover:border-red-700 hover:bg-red-100 transition ease-in-out duration-150">
                            <i class="fas fa-exclamation-triangle text-red-500 mr-2"></i>
                            <span class="text-red-500">Belum ada domain. </span>
                            <a href="{{ route('formulir.set-default-children', $form->id) }}"
                                class="text-red-500 hover:text-red-700 hover:underline underline font-semibold">Klik Untuk menambah domain secara
                                otomatis.</a>
                        </div>
                    @else
                        {{-- <i class="fas fa-check-circle text-green-500 mr-2"></i> <span>Domain tersedia</span> --}}
                    @endif
                    <div class="flex xl:flex md:flex-none justify-between mt-4">
                        <h2 class="text-lg font-semibold mb-2">{{ $form->nama_formulir }}</h2>
                        <div class="flex gap-2">
                            <a href="{{ route('formulir.edit', $form->id) }}"
                                class="text-green-600 hover:text-green-800 border rounded-md p-2">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                                </svg>
                            </a>
                            <form action="{{ route('formulir.destroy', $form->id) }}" method="POST" id="form_delete"
                                class="inline">
                                @csrf
                                @method('DELETE')
                                <button type="button"
                                    class="text-red-600 hover:text-red-800 border rounded-md p-2 deleteBtn"
                                    data-id="{{ $form->id }}" data-nama="{{ $form->nama_formulir }}">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                    </svg>
                                </button>
                            </form>
                        </div>
                    </div>
                    <div class="text-sm text-gray-500 flex items-center mb-2">
                        <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                            <path
                                d="M6 2a1 1 0 011 1v1h6V3a1 1 0 112 0v1h1a2 2 0 012 2v1H3V6a2 2 0 012-2h1V3a1 1 0 011-1zM3 9h14v7a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                        </svg>
                        {{ \Carbon\Carbon::parse($form->tanggal_dibuat)->locale('id')->isoFormat('dddd, D MMMM Y') }}
                    </div>
                    <p class="text-sm text-gray-700 mb-3">{{ Str::limit($form->deskripsi ?? '-', 100) }}</p>
                    <div class="flex space-x-2">
                        <a href="{{ route('formulir.show', $form->id) }}"
                            class="bg-gray-800 text-white text-sm px-4 py-2 rounded hover:bg-gray-600">Lihat</a>
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
