<?php

use App\Models\Formulir;
use App\Models\User;

it('shows formulir menu for opd on dashboard', function () {
    $user = User::factory()->create([
        'role' => 'opd',
    ]);

    $response = $this->actingAs($user)->get(route('dashboard'));

    $response->assertOk();
    $response->assertSeeText('Formulir');
    $response->assertSeeText('Isi Formulir');
});

it('does not show formulir creation menu for admin on dashboard', function () {
    $user = User::factory()->create([
        'role' => 'admin',
    ]);

    $response = $this->actingAs($user)->get(route('dashboard'));

    $response->assertOk();
    $response->assertDontSeeText('Kegiatan Penilaian');
    $response->assertDontSeeText('Tambah Formulir');
    $response->assertSeeText('Manajemen User');
    $response->assertSeeText('Penilaian Selesai');
});

it('allows opd to open formulir index', function () {
    $user = User::factory()->create([
        'role' => 'opd',
    ]);

    $response = $this->actingAs($user)->get(route('formulir.index'));

    $response->assertOk();
    $response->assertSeeText('Tambah');
    $response->assertSeeText('Formulir');
});

it('forbids admin from opening formulir index', function () {
    $user = User::factory()->create([
        'role' => 'admin',
    ]);

    $response = $this->actingAs($user)->get(route('formulir.index'));

    $response->assertForbidden();
});

it('creates default template children when opd stores formulir from web', function () {
    $user = User::factory()->create([
        'role' => 'opd',
    ]);

    $response = $this->actingAs($user)->post(route('formulir.store'), [
        'nama_formulir' => 'Formulir Web Default',
    ]);

    $response->assertRedirect(route('formulir.index'));

    $formulir = Formulir::where('nama_formulir', 'Formulir Web Default')->firstOrFail();

    expect($formulir->created_by_id)->toBe($user->id);
    expect($formulir->domains()->count())->toBe(5);
    expect(
        \App\Models\Aspek::whereHas('domain.formulirs', function ($query) use ($formulir) {
            $query->where('formulirs.id', $formulir->id);
        })->count()
    )->toBe(19);
    expect(
        \App\Models\Indikator::whereHas('aspek.domain.formulirs', function ($query) use ($formulir) {
            $query->where('formulirs.id', $formulir->id);
        })->count()
    )->toBe(38);
});
