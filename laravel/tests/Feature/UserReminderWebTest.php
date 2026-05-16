<?php

use App\Models\User;
use App\Services\OpdFormReminderService;

afterEach(function () {
    \Mockery::close();
});

test('admin can trigger opd reminder from web', function () {
    $admin = User::factory()->create(['role' => 'admin']);
    $opd = User::factory()->create(['role' => 'opd']);

    $service = \Mockery::mock(OpdFormReminderService::class);
    $service->shouldReceive('sendManualReminderForUser')
        ->once()
        ->withArgs(fn (User $user, int $adminId) => $user->is($opd) && $adminId === $admin->id)
        ->andReturn([
            'sent' => 1,
            'skipped' => 0,
            'incomplete_form_count' => 2,
            'message' => 'Reminder manual berhasil diproses untuk 2 formulir yang belum lengkap.',
        ]);
    app()->instance(OpdFormReminderService::class, $service);

    $response = $this
        ->actingAs($admin)
        ->post(route('user.trigger-opd-reminder', $opd));

    $response->assertRedirect(route('opd-notifications.index'));
    $response->assertSessionHas('success', 'Reminder manual berhasil diproses untuk 2 formulir yang belum lengkap.');
});

test('admin can open user management index from web', function () {
    $admin = User::factory()->create(['role' => 'admin']);

    $response = $this
        ->actingAs($admin)
        ->get(route('user.index'));

    $response->assertOk();
    $response->assertSee('User', false);
});

test('non admin cannot access user management get routes', function () {
    $managedUser = User::factory()->create(['role' => 'opd']);

    foreach (['opd', 'walidata'] as $role) {
        $user = User::factory()->create(['role' => $role]);

        $this->actingAs($user)
            ->get(route('user.index'))
            ->assertForbidden();

        $this->actingAs($user)
            ->get(route('user.create'))
            ->assertForbidden();

        $this->actingAs($user)
            ->get(route('user.show', $managedUser))
            ->assertForbidden();

        $this->actingAs($user)
            ->get(route('user.edit', $managedUser))
            ->assertForbidden();
    }
});

test('non admin cannot access user management write routes', function () {
    $managedUser = User::factory()->create(['role' => 'opd']);

    $payload = [
        'name' => 'Managed User',
        'email' => 'managed@example.com',
        'password' => 'password123',
        'role' => 'opd',
        'alamat' => 'Alamat Managed',
        'nomor_telepon' => '081234567890',
    ];

    foreach (['opd', 'walidata'] as $role) {
        $user = User::factory()->create(['role' => $role]);

        $this->actingAs($user)
            ->post(route('user.store'), $payload)
            ->assertForbidden();

        $this->actingAs($user)
            ->put(route('user.update', $managedUser), [
                ...$payload,
                'email' => 'updated@example.com',
            ])
            ->assertForbidden();

        $this->actingAs($user)
            ->delete(route('user.destroy', $managedUser))
            ->assertForbidden();

        $this->actingAs($user)
            ->post(route('user.reset-password', $managedUser))
            ->assertForbidden();

        $this->actingAs($user)
            ->post(route('user.trigger-opd-reminder', $managedUser))
            ->assertForbidden();

        $this->actingAs($user)
            ->post(route('user.trigger-opd-reminder.bulk'), [
                'user_ids' => [$managedUser->id],
            ])
            ->assertForbidden();

        $this->actingAs($user)
            ->post(route('user.trigger-opd-reminder.all'))
            ->assertForbidden();
    }
});

test('admin cannot trigger opd reminder from web for non opd user', function () {
    $admin = User::factory()->create(['role' => 'admin']);
    $walidata = User::factory()->create(['role' => 'walidata']);

    $service = \Mockery::mock(OpdFormReminderService::class);
    $service->shouldNotReceive('sendManualReminderForUser');
    app()->instance(OpdFormReminderService::class, $service);

    $response = $this
        ->actingAs($admin)
        ->post(route('user.trigger-opd-reminder', $walidata));

    $response->assertRedirect(route('opd-notifications.index'));
    $response->assertSessionHas('error', 'Reminder hanya dapat dikirim ke user OPD.');
});

test('admin can trigger bulk opd reminder from web', function () {
    $admin = User::factory()->create(['role' => 'admin']);
    $opdOne = User::factory()->create(['role' => 'opd']);
    $opdTwo = User::factory()->create(['role' => 'opd']);
    $walidata = User::factory()->create(['role' => 'walidata']);

    $service = \Mockery::mock(OpdFormReminderService::class);
    $service->shouldReceive('sendManualReminderForUser')
        ->once()
        ->withArgs(fn (User $user, int $adminId) => $user->is($opdOne) && $adminId === $admin->id)
        ->andReturn([
            'sent' => 1,
            'skipped' => 0,
            'incomplete_form_count' => 2,
            'message' => 'Reminder diproses.',
        ]);
    $service->shouldReceive('sendManualReminderForUser')
        ->once()
        ->withArgs(fn (User $user, int $adminId) => $user->is($opdTwo) && $adminId === $admin->id)
        ->andReturn([
            'sent' => 0,
            'skipped' => 1,
            'incomplete_form_count' => 0,
            'message' => 'Semua formulir OPD ini sudah lengkap.',
        ]);
    app()->instance(OpdFormReminderService::class, $service);

    $response = $this
        ->actingAs($admin)
        ->post(route('user.trigger-opd-reminder.bulk'), [
            'user_ids' => [$opdOne->id, $opdTwo->id, $walidata->id, 999999],
        ]);

    $response->assertRedirect(route('opd-notifications.index'));
    $response->assertSessionHas('success', 'Reminder bulk diproses untuk 2 user OPD. Berhasil: 1. Dilewati: 3.');
});

test('admin can trigger reminder for all opd users from web', function () {
    $admin = User::factory()->create(['role' => 'admin']);
    $opdOne = User::factory()->create(['role' => 'opd']);
    $opdTwo = User::factory()->create(['role' => 'opd']);
    User::factory()->create(['role' => 'walidata']);

    $service = \Mockery::mock(OpdFormReminderService::class);
    $service->shouldReceive('sendManualReminderForUser')
        ->once()
        ->withArgs(fn (User $user, int $adminId) => $user->is($opdOne) && $adminId === $admin->id)
        ->andReturn([
            'sent' => 1,
            'skipped' => 0,
            'incomplete_form_count' => 2,
            'message' => 'Reminder diproses.',
        ]);
    $service->shouldReceive('sendManualReminderForUser')
        ->once()
        ->withArgs(fn (User $user, int $adminId) => $user->is($opdTwo) && $adminId === $admin->id)
        ->andReturn([
            'sent' => 0,
            'skipped' => 1,
            'incomplete_form_count' => 0,
            'message' => 'Semua formulir OPD ini sudah lengkap.',
        ]);
    app()->instance(OpdFormReminderService::class, $service);

    $response = $this
        ->actingAs($admin)
        ->post(route('user.trigger-opd-reminder.all'));

    $response->assertRedirect(route('opd-notifications.index'));
    $response->assertSessionHas('success', 'Reminder semua OPD diproses untuk 2 user OPD. Berhasil: 1. Dilewati: 1.');
});

test('bulk opd reminder requires selected users', function () {
    $admin = User::factory()->create(['role' => 'admin']);

    $response = $this
        ->from(route('opd-notifications.index'))
        ->actingAs($admin)
        ->post(route('user.trigger-opd-reminder.bulk'), []);

    $response->assertRedirect(route('opd-notifications.index'));
    $response->assertSessionHasErrors(['user_ids']);
});

test('admin can open opd notifications page and only see opd users', function () {
    $admin = User::factory()->create(['role' => 'admin']);
    $opd = User::factory()->create(['role' => 'opd', 'name' => 'OPD Satu']);
    User::factory()->create(['role' => 'walidata', 'name' => 'Walidata Satu']);

    $response = $this
        ->actingAs($admin)
        ->get(route('opd-notifications.index'));

    $response->assertOk();
    $response->assertSee('Notifikasi OPD');
    $response->assertSee('Kirim Notifikasi Semua OPD');
    $response->assertSee('Kirim ke yang Dicentang');
    $response->assertSee('title="Pilih semua OPD di halaman ini"', false);
    $response->assertDontSee('<span>Pilih semua OPD di halaman ini</span>', false);
    $response->assertDontSee('Kirim Reminder Terpilih');
    $response->assertSee($opd->name);
    $response->assertDontSee('Walidata Satu');
});

test('non admin cannot open opd notifications page', function () {
    $opd = User::factory()->create(['role' => 'opd']);

    $this->actingAs($opd)
        ->get(route('opd-notifications.index'))
        ->assertForbidden();
});

test('opd notifications page shows pagination for additional opd users', function () {
    $admin = User::factory()->create(['role' => 'admin']);

    for ($i = 1; $i <= 16; $i++) {
        User::factory()->create([
            'role' => 'opd',
            'name' => sprintf('OPD %02d', $i),
        ]);
    }

    $firstPage = $this
        ->actingAs($admin)
        ->get(route('opd-notifications.index', [
            'sort' => 'name',
            'direction' => 'asc',
        ]));

    $firstPage->assertOk();
    $firstPage->assertSee('Menampilkan 1 sampai 15 dari 16 user OPD');
    $firstPage->assertSee('sort=name&amp;direction=asc&amp;page=2', false);

    $secondPage = $this
        ->actingAs($admin)
        ->get(route('opd-notifications.index', [
            'sort' => 'name',
            'direction' => 'asc',
            'page' => 2,
        ]));

    $secondPage->assertOk();
    $secondPage->assertSee('Menampilkan 16 sampai 16 dari 16 user OPD');
    $secondPage->assertSee('OPD 16');
});
