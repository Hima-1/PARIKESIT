@extends('dashboard.layout')
@section('title', 'Penilaian Indikator ' . $indikator->nama_indikator)
@section('content')
    <div class="flex justify-between items-center">
        <h4 class="text-lg font-semibold text-blue-700 text-uppercase mb-3">Aspek {{ strtoupper($aspek->nama_aspek) }}</h4>
    </div>

    <nav class="bg-white p-4 border-2 rounded-md w-full mb-4">
        <ol class="list-reset flex text-grey-dark">

            <li><a href="{{ route('penilaian.index') }}" class="text-blue-600 hover:underline">Penilaian</a></li>
            <li><span class="mx-2">&gt;</span></li>
            <li class="text-gray-700"> <a href="{{ route('formulir.penilaianTersedia', [$formulir]) }}"
                    class="text-blue-600 hover:underline">Kegiatan : {{ $formulir->nama_formulir }} </a> </li>
            <li><span class="mx-2">&gt;</span></li>
            <li class="text-gray-700">
                <a href="{{ route('formulir.domain-penilaian', [$formulir]) }}" class="text-blue-600 hover:underline">Domain
                    Kegiatan : {{ $formulir->nama_formulir }} </a>
            </li>
            <li><span class="mx-2">&gt;</span></li>
            <li class="text-gray-700">
                <a href="{{ route('formulir.isi-domain', [$formulir, $domain->nama_domain]) }}"
                    class="text-blue-600 hover:underline">Domain
                    {{ $domain->nama_domain }} </a>

            </li>
            <li><span class="mx-2">&gt;</span></li>
            <li class="text-gray-700">
                Indikator {{ $indikator->nama_indikator }}
            </li>
        </ol>
    </nav>

    <div class="p-6 bg-white shadow rounded-md space-y-6">
        <!-- Header -->
        <div class="flex justify-between items-center border-b pb-4">
            <div class="text-blue-600 font-semibold text-sm">Indikator {{ $indikator->nama_indikator }}</div>
            <div class="space-x-2">



                {{-- @if ($prev_indikator != null)
                    <a href="{{ route('formulir.penilaianAspek', [$formulir, $domain->nama_domain, $aspek->nama_aspek, $prev_indikator->nama_indikator]) }}"
                        class="text-blue-600 hover:text-blue-800">
                        ⬅️
                    </a>
                @endif

                  @if ($next_indikator != null)
                    <a href="{{ route('formulir.penilaianAspek', [$formulir, $domain->nama_domain, $aspek->nama_aspek, $next_indikator->nama_indikator]) }}"
                        class="text-blue-600 hover:text-blue-800">
                        ➡️
                    </a>
                @endif --}}
            </div>
        </div>



        <!-- Status Pemeriksaan -->

        @include('dashboard.partials.indikator-reference', [
            'domain' => $domain,
            'aspek' => $aspek,
            'indikator' => $indikator,
        ])

        @if (Auth::user()->role == 'walidata')
            @if ($dinilai)

                <form
                    action="{{ route('formulir.update-penilaian', [
                        $formulir,
                        $domain->nama_domain,
                        $aspek->nama_aspek,
                        $indikator->nama_indikator,
                        $dinilai->id,
                    ]) }}"
                    method="POST" enctype="multipart/form-data">
                    @csrf
                    <div
                        class="md:flex md:items-center md:justify-between bg-yellow-50 p-4 rounded-md border border-yellow-300">
                        <div class="mb-5">
                            <div class="text-sm font-medium text-gray-700 mb-2 md:mb-0">Status Pemeriksaan <b>(Khusus
                                    Walidata)</b>
                            </div>
                            <div>
                                <select
                                    class="border border-indigo-400 shadow text-indigo-600 bg-white rounded-md px-3 py-2 text-sm">
                                    <option value="Disetujui">Disetujui</option>
                                    <option value="Tidak Disetujui">Tidak Disetujui</option>
                                </select>
                            </div>
                        </div>


                        @if (Auth::user()->role != 'walidata')
                            <div class="mt-3 mb-2">
                                <div class="text-sm font-medium text-gray-700 mb-2 md:mb-0">Koreksi <b>(Khusus
                                        Walidata)</b>
                                </div>
                                <textarea rows="4" class="w-full border-2 border-gray-500 rounded p-2 text-sm" name="koreksi"
                                    placeholder="Koreksi dari Walidata..."></textarea>

                            </div>
                        @endif


                        <div class="space-y-2 text-sm">
                            <label for="level1_update" class="{{ $style }}">
                                <div class="flex items-start space-x-3">
                                    <input type="radio" id="level1_update" name="nilai_update" value="1"
                                        class="mt-1 accent-blue-600" {{ $nilaiTerkunci == 1 ? 'checked' : '' }}
                                        {{ $nilaiTerkunci !== null && $nilaiTerkunci != 1 ? 'disabled' : '' }}>
                                    <span>Level 1. Rintisan</span>
                                </div>
                            </label>
                            <label for="level2_update" class="{{ $style }}">
                                <div class="flex items-start space-x-3">
                                    <input type="radio" id="level2_update" name="nilai_update" value="2"
                                        class="mt-1 accent-blue-600" {{ $nilaiTerkunci == 2 ? 'checked' : '' }}
                                        {{ $nilaiTerkunci !== null && $nilaiTerkunci != 2 ? 'disabled' : '' }}>
                                    <span>Level 2. Terkelola</span>
                                </div>
                            </label>
                            <label for="level3_update" class="{{ $style }}">
                                <div class="flex items-start space-x-3">
                                    <input type="radio" id="level3_update" name="nilai_update" value="3"
                                        class="mt-1 accent-blue-600" {{ $nilaiTerkunci == 3 ? 'checked' : '' }}
                                        {{ $nilaiTerkunci !== null && $nilaiTerkunci != 3 ? 'disabled' : '' }}>
                                    <span>Level 3. Terdefinisi</span>
                                </div>
                            </label>
                            <label for="level4_update" class="{{ $style }}">
                                <div class="flex items-start space-x-3">
                                    <input type="radio" id="level4_update" name="nilai_update" value="4"
                                        class="mt-1 accent-blue-600" {{ $nilaiTerkunci == 4 ? 'checked' : '' }}
                                        {{ $nilaiTerkunci !== null && $nilaiTerkunci != 4 ? 'disabled' : '' }}>
                                    <span>Level 4. Terpadu</span>
                                </div>
                            </label>
                            <label for="level5_update" class="{{ $style }}">
                                <div class="flex items-start space-x-3">
                                    <input type="radio" id="level5_update" name="nilai_update" value="5"
                                        class="mt-1 accent-blue-600" {{ $nilaiTerkunci == 5 ? 'checked' : '' }}
                                        {{ $nilaiTerkunci !== null && $nilaiTerkunci != 5 ? 'disabled' : '' }}>
                                    <span>Level 5. Optimum</span>
                                </div>
                            </label>
                        </div>
                        <button type="submit" class="bg-indigo-500 p-2 w-40 text-white mt-4 rounded-md">Beri
                            Koreksi</button>

                    </div>


                </form>
            @endif
        @endif


        <form action="{{ route('formulir.store-penilaian', [
            $formulir,
            $domain->nama_domain,
            $aspek->nama_aspek,
            $indikator->nama_indikator,
        ]) }}" method="POST"
            enctype="multipart/form-data">
            @csrf
            <!-- Tingkat Kematangan -->
            <div class="space-y-2 mt-5 font-semibold">

                @php
                    $isLocked = $dinilai && ($dinilai->nilai_diupdate !== null || filled($dinilai->evaluasi));
                    $nilaiTerkunci = $dinilai->nilai ??  null;
                    $existingBuktiDukungFiles = $dinilai?->normalizedBuktiDukung() ?? [];
                    $style =
                        !$isLocked
                            ? 'block bg-white border rounded-md p-3 shadow-sm cursor-pointer hover:bg-blue-200 ease-in-out transition duration-100'
                            : 'block bg-gray-300 border disabled rounded-md p-3 shadow-sm cursor-pointer';
                @endphp

                <input type="hidden" name="existing_bukti_dukung" value="{{ json_encode($existingBuktiDukungFiles) }}">

                {{-- {{$nilaiTerkunci ?? 'gk'}} --}}
                <div class="font-semibold text-sm text-gray-700">{{ $indikator->nama_indikator }}</div>

                {{-- <div class="text-xl">{{$nilaiTerkunci }}</div> --}}
                <div class="space-y-2 text-sm">
                    <label for="level1" class="{{ $style }}">
                        <div class="flex items-start space-x-3">
                            <input type="radio" id="level1" name="nilai" value="1" class="mt-1 accent-blue-600"
                                {{ $nilaiTerkunci == 1 ? 'checked' : '' }}
                                {{ $isLocked ? 'disabled' : '' }}>
                            <div class="flex flex-col">
                                <span>Level 1. Rintisan</span>
                                @if(!empty($indikator->level_1_kriteria))
                                    <small class="text-xs text-gray-600 mt-1">
                                        {{ $indikator->level_1_kriteria }}
                                    </small>
                                @endif
                            </div>
                        </div>
                    </label>
                    <label for="level2" class="{{ $style }}">
                        <div class="flex items-start space-x-3">
                            <input type="radio" id="level2" name="nilai" value="2"
                                class="mt-1 accent-blue-600" {{ $nilaiTerkunci == 2 ? 'checked' : '' }}
                                {{ $isLocked ? 'disabled' : '' }}>
                            <div class="flex flex-col">
                                <span>Level 2. Terkelola</span>
                                @if(!empty($indikator->level_2_kriteria))
                                    <small class="text-xs text-gray-600 mt-1">
                                        {{ $indikator->level_2_kriteria }}
                                    </small>
                                @endif
                            </div>
                        </div>
                    </label>
                    <label for="level3" class="{{ $style }}">
                        <div class="flex items-start space-x-3">
                            <input type="radio" id="level3" name="nilai" value="3"
                                class="mt-1 accent-blue-600" {{ $nilaiTerkunci == 3 ? 'checked' : '' }}
                                {{ $isLocked ? 'disabled' : '' }}>
                            <div class="flex flex-col">
                                <span>Level 3. Terdefinisi</span>
                                @if(!empty($indikator->level_3_kriteria))
                                    <small class="text-xs text-gray-600 mt-1">
                                        {{ $indikator->level_3_kriteria }}
                                    </small>
                                @endif
                            </div>
                        </div>
                    </label>
                    <label for="level4" class="{{ $style }}">
                        <div class="flex items-start space-x-3">
                            <input type="radio" id="level4" name="nilai" value="4"
                                class="mt-1 accent-blue-600" {{ $nilaiTerkunci == 4 ? 'checked' : '' }}
                                {{ $isLocked ? 'disabled' : '' }}>
                            <div class="flex flex-col">
                                <span>Level 4. Terpadu</span>
                                @if(!empty($indikator->level_4_kriteria))
                                    <small class="text-xs text-gray-600 mt-1">
                                        {{ $indikator->level_4_kriteria }}
                                    </small>
                                @endif
                            </div>
                        </div>
                    </label>
                    <label for="level5" class="{{ $style }}">
                        <div class="flex items-start space-x-3">
                            <input type="radio" id="level5" name="nilai" value="5"
                                class="mt-1 accent-blue-600" {{ $nilaiTerkunci == 5 ? 'checked' : '' }}
                                {{ $isLocked ? 'disabled' : '' }}>
                            <div class="flex flex-col">
                                <span>Level 5. Optimum</span>
                                @if(!empty($indikator->level_5_kriteria))
                                    <small class="text-xs text-gray-600 mt-1">
                                        {{ $indikator->level_5_kriteria }}
                                    </small>
                                @endif
                            </div>
                        </div>
                    </label>
                </div>
            </div>



            <div class="mt-5">
                <label class="text-sm font-semibold text-gray-700 mb-1 block">Catatan Penjelasan</label>

                <textarea rows="4" class="w-full border rounded p-2 text-sm" name="catatan"
                    placeholder="Penjelasan indikator..." {{ $isLocked ? 'disabled' : '' }}>{{ $dinilai->catatan ?? '' }}</textarea>
            </div>

            <!-- Bukti Dukung -->
            <div class="mt-5">
                <label class="text-sm font-semibold text-gray-700 mb-1 block">Bukti Dukung</label>
                <div class="text-xs text-gray-500 mb-2">Unggah bukti dalam format PDF/JPG/JPEG/PNG/DOC/DOCX maksimal 2 MB per file</div>
                @if (!empty($existingBuktiDukungFiles))
                        @foreach ($existingBuktiDukungFiles as $buktiFile)
                            @if (substr($buktiFile, -3) == 'pdf')
                                <a href="{{ $dinilai->resolveBuktiDukungUrl($buktiFile) }}"
                                    class="block w-full text-gray-700 rounded p-5 shadow border-2 text-sm mb-4" target="_blank">
                                    Lihat PDF
                                </a>
                            @else
                                <a href="{{ $dinilai->resolveBuktiDukungUrl($buktiFile) }}" target="_blank">
                                    <img src="{{ $dinilai->resolveBuktiDukungUrl($buktiFile) }}"
                                        class="block w-40 text-gray-700 rounded p-2 shadow border-2 text-sm mb-4"
                                        alt="Bukti Dukung">
                                </a>
                            @endif
                        @endforeach
                        <div class="text-green-500 text-sm">Bukti dukung sudah diunggah</div>
                @endif
                @if (!$isLocked)
                    <div id="buktiDukungContainer">
                        <div id="inputFormRow" class="mb-3">
                            <div class="flex items-center space-x-2">
                                <input type="file" name="bukti_dukung[]"
                                    class="block w-full text-gray-700 rounded p-5 shadow border-2 text-sm"
                                    accept=".pdf,.jpg,.jpeg,.png,.doc,.docx" />
                            </div>
                        </div>
                        <div id="newBuktiDukungRow"></div>
                        <button type="button" id="addBuktiDukungRow"
                            class="btn btn-sm text-black bg-green-300 border-2 mb-4">
                            Tambah Bukti Dukung
                        </button>
                    </div>
                @endif
            </div>


            <div class="mt-10">
                @if ($isLocked)
                    <a href="{{ route('formulir.isi-domain', [$formulir, $domain->nama_domain]) }}"
                        class="bg-gray-600 shadow hover:bg-gray-800 dark:hover:bg-gray-700  p-3 w-full text-white mt-4 rounded-md text-center">Kembali</a>
                @else
                    <div class="flex justify-between">
                        <button type="submit" class="bg-indigo-500 p-3 w-50 text-white mt-4 rounded-md">Simpan</button>

                        <a href="{{ route('formulir.isi-domain', [$formulir, $domain->nama_domain]) }}"
                        class="bg-gray-600 shadow hover:bg-gray-800 dark:hover:bg-gray-700  p-3 text-white mt-4 rounded-md text-center">Kembali</a>
                    </div>
                @endif

            </div>


        </form>

    </div>
    {{-- <table class="w-full text-sm border">
                    <thead class="bg-gray-100 text-gray-700 font-semibold">
                        <tr>
                            <th class="border px-2 py-1">No.</th>
                            <th class="border px-2 py-1">Nama Berkas</th>
                            <th class="border px-2 py-1">Aksi</th>
                            <th class="border px-2 py-1">Keterangan</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                    <td class="border px-2 py-1 text-center">1</td>
                    <td class="border px-2 py-1">Bukti dukung 1.pdf</td>
                    <td class="border px-2 py-1 space-x-2">
                        <a href="#" class="text-blue-600 hover:underline">Lihat</a>
                        <button class="text-red-600 hover:underline">Hapus</button>
                    </td>
                    <td class="border px-2 py-1">Penilaian Mandiri - Operator</td>
                </tr>
                    </tbody>
                </table> --}}
@endsection
@push('scripts')
    <script>
        $(function() {
            const radios = $('input[name="nilai"]');

            function updateSelectedBackground() {
                radios.each(function() {
                    const label = $(`label[for="${this.id}"]`);
                    if (this.checked) {
                        label.addClass('bg-blue-200');
                    } else {
                        label.removeClass('bg-blue-200');
                    }
                });
            }

            // Jalankan saat load halaman untuk menyetel nilai yang tersimpan
            updateSelectedBackground();

            // Tambahkan event saat diklik
            radios.on('change', updateSelectedBackground);

            // Bukti Dukung Dynamic Rows
            let buktiDukungRowCount = 1;
            $("#addBuktiDukungRow").click(function() {
                if (buktiDukungRowCount >= 3) {
                    alert('Maksimal 3 bukti dukung');
                    return;
                }

                buktiDukungRowCount++;
                var html = `
                    <div id="inputFormRow" class="mb-3">
                        <div class="flex items-center space-x-2">
                            <input type="file" name="bukti_dukung[]"
                                class="block w-full text-gray-700 rounded p-5 shadow border-2 text-sm"
                                accept=".pdf,.jpg,.jpeg,.png,.doc,.docx" />
                            <button type="button" class="removeBuktiDukungRow text-red-600 hover:text-red-800">
                                Hapus
                            </button>
                        </div>
                    </div>
                `;

                $('#newBuktiDukungRow').append(html);
            });

            // Remove row
            $(document).on('click', '.removeBuktiDukungRow', function() {
                $(this).closest('#inputFormRow').remove();
                buktiDukungRowCount--;
            });
        });
    </script>
@endpush
