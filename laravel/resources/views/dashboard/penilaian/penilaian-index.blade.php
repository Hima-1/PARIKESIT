@extends('dashboard.layout')
@section('title', 'Daftar Kegiatan Penilaian')
@section('content')
    <div class="card p-8">
        <div class="flex justify-between mb-4">
            <h4 class="h4">Daftar Kegiatan Penilaian</h4>
        </div>

        <hr class="my-4 border-t-2 border-gray-300">

        {{-- Tambahkan pesan info jika tidak ada kegiatan --}}
        @if(isset($pesan_info))
            <div class="bg-yellow-100 border border-yellow-400 text-yellow-700 px-4 py-3 rounded relative mb-4" role="alert">
                <strong class="font-bold">Informasi!</strong>
                <span class="block sm:inline">{{ $pesan_info }}</span>
            </div>
        @endif

        <div class="grid grid-cols-2 sm:grid-cols-1 md:grid-cols-1 gap-4">
            @if($kegiatanPenilaian->isNotEmpty())
                @foreach ($kegiatanPenilaian as $form)
                    @php
                        if ($form->persentase <= 20 && $form->persentase > 0) {
                            $warna = 'bg-red-500';
                        } elseif ($form->persentase > 20 && $form->persentase <= 40) {
                            $warna = 'bg-yellow-500';
                        } elseif ($form->persentase > 40 && $form->persentase <= 60) {
                            $warna = 'bg-orange-500';
                        } elseif ($form->persentase > 60 && $form->persentase <= 80) {
                            $warna = 'bg-green-500';
                        } elseif ($form->persentase > 80 && $form->persentase <= 99) {
                            $warna = 'bg-blue-500';
                        } elseif ($form->persentase == 100) {
                            $warna = 'bg-indigo-500';
                        } else {
                            $warna = 'bg-gray-500';
                        }
                    @endphp
                    <div
                        class="bg-white border shadow-lg pb-1 mb-3 hover:bg-gray-300 transition ease-in-out duration-100 border-indigo-400 rounded-lg">
                        <div class="w-full h-2 {{ $warna }} rounded-t-md "></div>

                        <div class="px-6 py-6">
                            <div class="flex items-center justify-between">
                                <h5 class="text-xl font-bold">{{ $form->nama_formulir }}</h5>

                                <p class="text-gray-800 text-md">
                                    {{ \Carbon\Carbon::parse($form->created_at)->locale('id')->isoFormat('dddd, D MMMM Y') }}
                                </p>
                            </div>
                            <div class="flex">
                                <ul class="list-disc pl-6 mt-2">
                                    <li class="text-lg">
                                        <p class="font-semibold text-blue-700">{{ $form->domains->count() }} Aspek</p>
                                    </li>
                                    <li class="text-lg">
                                        <p class="font-semibold text-blue-700">
                                            {{ $form->domains->sum(function ($domain) {
                                                return $domain->aspek->count();
                                            }) }}
                                            Aspek</p>
                                    </li>
                                    <li class="text-lg">
                                        <p class="font-semibold text-blue-700">
                                            {{ $form->domains->sum(function ($domain) {
                                                return $domain->aspek->sum(function ($aspek) {
                                                    return $aspek->indikator->count();
                                                });
                                            }) }}
                                            Indikator </p>
                                    </li>
                                </ul>
                            </div>
                            <div class="flex justify-end mt-4 gap-3">
                                <a href="{{ route('formulir.penilaianTersedia', ['formulir' => $form->id]) }}"
                                    class="py-1 px-4 text-small bg-gray-900 rounded shadow-md text-white hover:text-blue-100 hover:bg-gray-800 transform duration-100 ease-in-out">
                                    <i class="fad fa-edit mr-2"></i> Lakukan Penilaian</a>
                            </div>
                        </div>
                    </div>
                @endforeach
            @else
                <div class="col-span-2 sm:col-span-1 md:col-span-1 bg-yellow-100 border border-yellow-400 text-yellow-700 px-4 py-3 rounded relative" role="alert">
                    <strong class="font-bold">Informasi!</strong>
                    <span class="block sm:inline">Belum ada kegiatan penilaian yang tersedia.</span>
                </div>
            @endif
        </div>
    </div>
@endsection
@push('scripts')
@endpush
