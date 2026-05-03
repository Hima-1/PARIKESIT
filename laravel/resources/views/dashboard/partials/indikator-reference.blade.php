<div class="rounded-md border border-blue-100 bg-blue-50/60 p-4 space-y-4">
    <div class="grid gap-3 md:grid-cols-3">
        <div>
            <div class="text-xs font-semibold uppercase tracking-wide text-gray-500">Kode Indikator</div>
            <div class="text-sm font-semibold text-gray-900">{{ $indikator->kode_indikator ?? '-' }}</div>
        </div>
        <div>
            <div class="text-xs font-semibold uppercase tracking-wide text-gray-500">Domain</div>
            <div class="text-sm font-semibold text-gray-900">{{ $domain->nama_domain }}</div>
        </div>
        <div>
            <div class="text-xs font-semibold uppercase tracking-wide text-gray-500">Aspek</div>
            <div class="text-sm font-semibold text-gray-900">{{ $aspek->nama_aspek }}</div>
        </div>
    </div>

    <div>
        <h5 class="text-sm font-semibold uppercase tracking-wide text-blue-700">Tingkat Kriteria</h5>
        <div class="mt-3 space-y-3">
            @foreach ([1, 2, 3, 4, 5] as $level)
                @php
                    $criteriaField = 'level_' . $level . '_kriteria';
                @endphp
                <div class="rounded-md border border-gray-200 bg-white p-3">
                    <div class="text-sm font-semibold text-gray-900">Level {{ $level }}</div>
                    <div class="mt-1 text-sm leading-6 text-gray-700">
                        {{ $indikator->{$criteriaField} ?: 'Kriteria belum tersedia.' }}
                    </div>
                </div>
            @endforeach
        </div>
    </div>
</div>
