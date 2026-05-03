@extends('dashboard.layout')
@section('content')
    <div class="card mt-6 p-8">
        <div class="flex justify-between mb-4">
            <h4 class="h4">{{ $formulir->nama_formulir }} </h4>
            <a href="{{ route('formulir.domain.create', $formulir->id) }}"
                class="py-3 px-8 bg-blue-600 rounded  shadow-md text-white hover:text-blue-200 hover:bg-gray-800 transform duration-100 ease-in-out">Tambah
                Domain</a>



        </div>
        <hr>
        <div class="grid grid-cols-2 md:grid-cols-2 gap-4 mt-5">

            @forelse ($formulir->domains as $domain)


                <div
                    class="bg-white border shadow-lg rounded px-8 pt-6 pb-8 mb-3 hover:bg-gray-300 transition ease-in-out duration-100">
                    <div class="flex items-center justify-between">
                        <h5 class="text-xl font-bold">{{ $domain->nama_domain }}</h5>


                        <p class="text-gray-800 text-md">
                            {{ \Carbon\Carbon::parse($domain->created_at)->locale('id')->isoFormat('dddd, D MMMM Y') }}
                        </p>



                    </div>
                    <div class="flex">
                        <ul class="list-disc pl-6">
                            <li class="text-lg">
                                <p class="font-semibold">{{ $domain->aspek->count() }} Aspek</p>
                            </li>
                            <li class="text-lg">
                                <p class="font-semibold">{{ $domain->aspek->sum(function($aspek) {
                                    return $aspek->indikator->count();
                                })}} Indikator </p>
                            </li>
                        </ul>
                    </div>


                </div>
            @empty
                <div
                    class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-3 hover:bg-gray-300 transition ease-in-out duration-100">
                    <div class="flex items-center justify-between">
                        <h5 class="text-2xl font-bold">Tidak Ada Domain</h5>

                    </div>
                </div>
            @endforelse


        </div>

    </div>
@endsection


@push('scripts')
@endpush
