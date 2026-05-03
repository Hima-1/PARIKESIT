@extends('dashboard.layout')
@section('title', 'Domain Penilaian Kegiatan : '.$formulir->nama_formulir)
@section('content')
    <div class="space-y-6">

  <div class="flex justify-between items-center">
            <h4 class="text-xl font-semibold text-gray-700">PENILAIAN MANDIRI PER DOMAIN</h4>
        </div>
        <nav class="bg-white p-4 border-2 rounded-md w-full mb-4">
            <ol class="list-reset flex text-grey-dark">

                <li><a href="{{ route('penilaian.index') }}" class="text-blue-600 hover:underline">Penilaian</a></li>
                <li><span class="mx-2">&gt;</span></li>
                <li class="text-gray-700"> <a href="{{route('formulir.penilaianTersedia',[$formulir])}}" class="text-blue-600 hover:underline">Kegiatan : {{ $formulir->nama_formulir }} </a> </li>
                 <li><span class="mx-2">&gt;</span></li>
                <li class="text-gray-700">Domain Kegiatan : {{ $formulir->nama_formulir }}</li>
            </ol>
        </nav>
        {{-- Judul --}}


        <div class="grid grid-cols-2 md:grid-cols-2 lg:grid-cols-3 gap-6">
            @foreach ($formulir->domains as $domain)
                <div
                    class="bg-white border border-gray-300 shadow-lg rounded-mdpb-8 mb-3 hover:bg-gray-300 transition ease-in-out duration-100">
                    <div class="w-full h-3 bg-gray-800 rounded-t-md "></div>

                    <div class="px-8 py-6">
                        <div class="flex items-center justify-between">

                            <h5 class="text-md font-bold text-blue-700">{{ $domain->nama_domain }}</h5>






                        </div>
                        <div class="flex bg-blue-100 rounded-md p-4 mt-4">
                            <ul class="list-disc pl-6">
                                <li class="text-lg">
                                    <p class="font-semibold text-blue-700">{{ $domain->aspek->count() }} Aspek</p>
                                </li>
                                <li class="text-lg">
                                    <p class="font-semibold text-blue-700">
                                        {{ $domain->aspek->sum(function ($aspek) {
                                            return $aspek->indikator->count();
                                        }) }}
                                        Indikator </p>
                                </li>
                            </ul>
                        </div>

                        <div class="w-full">
                            <a href="{{ route('formulir.isi-domain', [$formulir, $domain->nama_domain]) }}"
                                class="block text-center bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded w-full transition mt-4">Mulai
                                Penilaian</a>
                        </div>
                    </div>



                </div>
            @endforeach
        </div>

    </div>
@endsection

@push('scripts')
@endpush
