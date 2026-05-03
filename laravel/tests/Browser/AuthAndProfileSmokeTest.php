<?php

use App\Models\User;
use Illuminate\Foundation\Testing\DatabaseMigrations;
use Laravel\Dusk\Browser;

uses(DatabaseMigrations::class);

beforeEach(function () {
    $this->artisan('migrate:fresh');
});

test('admin can sign in through the browser and see admin shortcuts on dashboard', function () {
    $user = duskUser([
        'name' => 'Admin Browser',
        'email' => 'admin.browser@example.com',
        'role' => 'admin',
    ]);

    $this->browse(function (Browser $browser) use ($user) {
        $browser->visit('/login')
            ->assertPresent('@login-form')
            ->type('@login-email', $user->email)
            ->type('@login-password', 'password')
            ->press('@login-submit')
            ->waitFor('@dashboard-page')
            ->assertPathIs('/dashboard')
            ->assertSeeIn('@dashboard-user-name', 'Admin Browser')
            ->assertPresent('@shortcut-penilaian-selesai')
            ->assertPresent('@shortcut-dokumentasi-admin')
            ->assertPresent('@shortcut-pembinaan-admin')
            ->assertMissing('@shortcut-penilaian');
    });
});

test('opd can update profile through the browser', function () {
    $user = duskUser([
        'name' => 'OPD Browser',
        'email' => 'opd.browser@example.com',
        'role' => 'opd',
    ]);

    $this->browse(function (Browser $browser) use ($user) {
        $browser->loginAs($user)
            ->visit('/profile')
            ->waitFor('@profile-page')
            ->type('@profile-name', 'OPD Browser Updated')
            ->type('@profile-email', 'opd.browser.updated@example.com')
            ->type('@profile-alamat', 'Jl. Dusk Update No. 2')
            ->type('@profile-phone', '081111111111')
            ->press('@profile-save')
            ->waitFor('@profile-updated-alert')
            ->assertInputValue('@profile-name', 'OPD Browser Updated')
            ->assertInputValue('@profile-email', 'opd.browser.updated@example.com')
            ->assertSee('Profil berhasil diperbarui.');
    });

    expect(User::where('email', 'opd.browser.updated@example.com')->first())
        ->not->toBeNull()
        ->name->toBe('OPD Browser Updated');
});

test('walidata sees review shortcuts and can log out from the browser', function () {
    $user = duskUser([
        'name' => 'Walidata Browser',
        'email' => 'walidata.browser@example.com',
        'role' => 'walidata',
    ]);

    $this->browse(function (Browser $browser) use ($user) {
        $browser->loginAs($user)
            ->visit('/dashboard')
            ->waitFor('@dashboard-page')
            ->assertPresent('@shortcut-penilaian-selesai')
            ->assertPresent('@shortcut-dokumentasi')
            ->assertMissing('@shortcut-pembinaan-admin')
            ->click('@user-menu-toggle')
            ->waitFor('@user-menu-logout')
            ->press('@user-menu-logout')
            ->assertPathIs('/login')
            ->assertPresent('@login-form');
    });
});
