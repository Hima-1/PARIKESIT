<?php

use App\Models\Aspek;
use App\Models\Domain;
use App\Models\Formulir;
use App\Models\FormulirDomain;
use App\Models\User;

it('allows opd to add domain and aspects to owned formulir', function () {
    $user = User::factory()->create([
        'role' => 'opd',
    ]);

    $formulir = Formulir::create([
        'nama_formulir' => 'Formulir Uji',
        'created_by_id' => $user->id,
    ]);

    $response = $this->actingAs($user)->post(
        route('formulir.domain.store', ['formulir' => $formulir->id]),
        [
            'nama_domain' => 'Domain Statistik',
            'nama_aspek' => ['Aspek A', 'Aspek B'],
        ],
    );

    $domain = Domain::where('nama_domain', 'Domain Statistik')->first();

    expect($domain)->not->toBeNull();
    expect(
        FormulirDomain::where('formulir_id', $formulir->id)
            ->where('domain_id', $domain->id)
            ->exists()
    )->toBeTrue();
    expect(
        Aspek::where('domain_id', $domain->id)->pluck('nama_aspek')->all()
    )->toBe(['Aspek A', 'Aspek B']);

    $response->assertRedirect(route('formulir.show', $formulir->id));
});

it('prevents duplicate domain creation when the same payload is submitted twice for one formulir', function () {
    $user = User::factory()->create([
        'role' => 'opd',
    ]);

    $formulir = Formulir::create([
        'nama_formulir' => 'Formulir Uji',
        'created_by_id' => $user->id,
    ]);

    $payload = [
        'nama_domain' => 'Domain Statistik',
        'nama_aspek' => ['Aspek A', 'Aspek B'],
    ];

    $this->actingAs($user)->post(
        route('formulir.domain.store', ['formulir' => $formulir->id]),
        $payload,
    )->assertRedirect(route('formulir.show', $formulir->id));

    $this->actingAs($user)->from(route('formulir.domain.create', ['formulir' => $formulir->id]))->post(
        route('formulir.domain.store', ['formulir' => $formulir->id]),
        $payload,
    );

    expect(Domain::where('nama_domain', 'Domain Statistik')->count())->toBe(1);

    $domain = Domain::where('nama_domain', 'Domain Statistik')->first();

    expect($domain)->not->toBeNull();
    expect(
        FormulirDomain::where('formulir_id', $formulir->id)
            ->where('domain_id', $domain->id)
            ->count()
    )->toBe(1);
    expect(Aspek::where('domain_id', $domain->id)->count())->toBe(2);
});
