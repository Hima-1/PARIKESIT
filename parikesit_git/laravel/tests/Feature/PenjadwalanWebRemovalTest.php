<?php

use App\Models\User;

test('penjadwalan routes are removed while pembinaan index remains available for admin', function () {
    $admin = User::factory()->create(['role' => 'admin']);

    $this->actingAs($admin)
        ->get('/penjadwalan')
        ->assertNotFound();

    $this->actingAs($admin)
        ->getJson('/api/penjadwalan')
        ->assertNotFound();

    expect(app('router')->getRoutes()->getByName('penjadwalan.index'))->toBeNull();
    expect(app('router')->getRoutes()->getByName('penjadwalan.pembinaan.show'))->toBeNull();
    expect(collect(app('router')->getRoutes()->getRoutes())->pluck('uri'))
        ->not->toContain('api/penjadwalan')
        ->not->toContain('api/penjadwalan/{penjadwalan}');

    $this->actingAs($admin)
        ->get(route('pembinaan.index'))
        ->assertOk();
});
