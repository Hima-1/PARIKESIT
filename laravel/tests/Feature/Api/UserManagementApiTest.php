<?php

use App\Contracts\PushNotificationSender;
use App\Models\AuditLog;
use App\Models\DeviceToken;
use App\Models\Domain;
use App\Models\Formulir;
use App\Models\FormulirDomain;
use App\Models\Indikator;
use App\Models\Penilaian;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

test('admin can list users', function () {
    User::factory()->count(5)->create();

    $response = loginAsAdmin()->getJson('/api/users');

    $response->assertStatus(200)
        ->assertJsonCount(6, 'data');
});

test('user management endpoints return 401 when unauthenticated', function () {
    $user = User::factory()->create();

    $this->getJson('/api/users')->assertStatus(401);
    $this->postJson('/api/users', [])->assertStatus(401);
    $this->getJson("/api/users/{$user->id}")->assertStatus(401);
    $this->patchJson("/api/users/{$user->id}", [])->assertStatus(401);
    $this->deleteJson("/api/users/{$user->id}")->assertStatus(401);
    $this->postJson("/api/users/{$user->id}/reset-password", [])->assertStatus(401);
    $this->postJson("/api/users/{$user->id}/trigger-opd-reminder", [])->assertStatus(401);
});

test('non-admin cannot list users', function () {
    loginAs()->getJson('/api/users')->assertStatus(403);
});

test('non-admin cannot update user', function () {
    $user = User::factory()->create();

    loginAs()->patchJson("/api/users/{$user->id}", [
        'name' => 'Updated Name',
    ])->assertStatus(403);
});

test('non-admin cannot delete user', function () {
    $user = User::factory()->create();

    loginAs()->deleteJson("/api/users/{$user->id}")->assertStatus(403);
});

test('non-admin cannot reset user password', function () {
    $user = User::factory()->create();

    loginAs()->postJson("/api/users/{$user->id}/reset-password")->assertStatus(403);
});

test('non-admin cannot trigger opd reminder', function () {
    $user = User::factory()->create(['role' => 'opd']);

    loginAs()->postJson("/api/users/{$user->id}/trigger-opd-reminder")->assertStatus(403);
});

test('admin can create user', function () {
    $response = loginAsAdmin()->postJson('/api/users', [
        'name' => 'New User',
        'email' => 'newuser@example.com',
        'password' => 'password123',
        'role' => 'opd',
        'alamat' => 'Test Address',
        'nomor_telepon' => '08123456789',
    ]);

    $response->assertStatus(201)
        ->assertJsonPath('data.name', 'New User');

    $this->assertDatabaseHas('users', ['email' => 'newuser@example.com']);
});

test('create user returns 422 when payload invalid', function () {
    $response = loginAsAdmin()->postJson('/api/users', [
        'name' => 'New User',
        'email' => 'not-an-email',
        'password' => 'short',
        'role' => 'invalid-role',
        'alamat' => '',
        'nomor_telepon' => '',
    ]);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['email', 'role', 'alamat', 'nomor_telepon']);
});

test('admin cannot create user with short password', function () {
    $response = loginAsAdmin()->postJson('/api/users', [
        'name' => 'Short Password User',
        'email' => 'short-password@example.com',
        'password' => 'short',
        'role' => 'opd',
        'alamat' => 'Test Address',
        'nomor_telepon' => '08123456789',
    ]);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['password']);

    $this->assertDatabaseMissing('users', [
        'email' => 'short-password@example.com',
    ]);
});

test('admin user create strips html and normalizes text fields', function () {
    $response = loginAsAdmin()->postJson('/api/users', [
        'name' => '  <b>New</b>   User  ',
        'email' => '  SANITIZED@example.COM ',
        'password' => 'password123',
        'role' => 'opd',
        'alamat' => "  Jalan\tStatistik  ",
        'nomor_telepon' => ' 0812-3456<script>bad</script> ',
    ]);

    $response->assertCreated()
        ->assertJsonPath('data.name', 'New User')
        ->assertJsonPath('data.email', 'sanitized@example.com');

    $this->assertDatabaseHas('users', [
        'name' => 'New User',
        'email' => 'sanitized@example.com',
        'alamat' => 'Jalan Statistik',
        'nomor_telepon' => '0812-3456',
    ]);
});

test('admin user list sanitizes invalid sort and clamps per page', function () {
    User::factory()->count(60)->create();

    loginAsAdmin()
        ->getJson('/api/users?sort=not_a_column&direction=drop&per_page=9999')
        ->assertOk()
        ->assertJsonCount(50, 'data')
        ->assertJsonPath('meta.per_page', 50);
});

test('create user returns 422 when email already exists', function () {
    $existing = User::factory()->create(['email' => 'dup@example.com']);

    $response = loginAsAdmin()->postJson('/api/users', [
        'name' => 'New User',
        'email' => $existing->email,
        'password' => 'password123',
        'role' => 'opd',
    ]);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['email']);
});

test('create user returns 422 when alamat missing', function () {
    $response = loginAsAdmin()->postJson('/api/users', [
        'name' => 'New User',
        'email' => 'newuser2@example.com',
        'password' => 'password123',
        'role' => 'admin',
        'nomor_telepon' => '08123456789',
    ]);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['alamat']);
});

test('create user returns 422 when nomor telepon missing', function () {
    $response = loginAsAdmin()->postJson('/api/users', [
        'name' => 'New User',
        'email' => 'newuser3@example.com',
        'password' => 'password123',
        'role' => 'walidata',
        'alamat' => 'Alamat Test',
    ]);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['nomor_telepon']);
});

test('non-admin cannot create user', function () {
    $response = loginAs()->postJson('/api/users', [
        'name' => 'Unauthorized User',
        'email' => 'unauth@example.com',
        'password' => 'password123',
        'role' => 'opd',
    ]);

    $response->assertStatus(403);
});

test('admin can update user', function () {
    $user = User::factory()->create(['name' => 'Old Name']);

    $response = loginAsAdmin()->patchJson("/api/users/{$user->id}", [
        'name' => 'Updated Name',
        'email' => $user->email,
        'role' => $user->role ?? 'opd',
        'alamat' => $user->alamat,
        'nomor_telepon' => $user->nomor_telepon,
    ]);

    $response->assertStatus(200);
    $this->assertDatabaseHas('users', ['id' => $user->id, 'name' => 'Updated Name']);
});

test('update user rejects partial payload like web user management', function () {
    $user = User::factory()->create();

    $response = loginAsAdmin()->patchJson("/api/users/{$user->id}", [
        'name' => 'Updated Name',
    ]);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['email', 'role', 'alamat', 'nomor_telepon']);
});

test('update user returns 422 when payload invalid', function () {
    $user = User::factory()->create();

    $response = loginAsAdmin()->patchJson("/api/users/{$user->id}", [
        'email' => 'not-an-email',
    ]);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['email']);
});

test('update user returns 422 when alamat or nomor telepon empty', function () {
    $user = User::factory()->create();

    $response = loginAsAdmin()->patchJson("/api/users/{$user->id}", [
        'alamat' => '',
        'nomor_telepon' => '',
    ]);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['alamat', 'nomor_telepon']);
});

test('admin can show user detail', function () {
    $user = User::factory()->create();

    $response = loginAsAdmin()->getJson("/api/users/{$user->id}");

    $response->assertStatus(200)
        ->assertJsonPath('data.id', $user->id);
});

test('non-admin cannot show user detail', function () {
    $user = User::factory()->create();

    loginAs()->getJson("/api/users/{$user->id}")->assertStatus(403);
});

test('admin can delete user', function () {
    $user = User::factory()->create();

    $response = loginAsAdmin()->deleteJson("/api/users/{$user->id}");

    $response->assertStatus(200);
    $this->assertDatabaseMissing('users', ['id' => $user->id]);
});

test('admin can reset user password with random temporary password', function () {
    $user = User::factory()->create();
    $token = $user->createToken('mobile-token');
    DeviceToken::create([
        'user_id' => $user->id,
        'personal_access_token_id' => $token->accessToken->id,
        'token' => 'token-reset',
        'platform' => 'android',
        'is_active' => true,
    ]);

    $response = loginAsAdmin()->postJson("/api/users/{$user->id}/reset-password");

    $temporaryPassword = $response->json('data.temporary_password');

    $response->assertStatus(200)
        ->assertJsonPath(
            'message',
            'Password sementara berhasil dibuat dan seluruh token aktif telah dicabut.',
        )
        ->assertJsonStructure(['message', 'data' => ['temporary_password']]);

    expect($temporaryPassword)->toBeString();
    expect(strlen($temporaryPassword))->toBe(16);
    expect($temporaryPassword)->not->toBe('password');
    expect($temporaryPassword)->not->toBe('password123');

    $user->refresh();
    expect(Hash::check($temporaryPassword, $user->password))->toBeTrue();
    $this->assertDatabaseMissing('personal_access_tokens', [
        'id' => $token->accessToken->id,
    ]);
    $this->assertDatabaseHas('device_tokens', [
        'user_id' => $user->id,
        'token' => 'token-reset',
        'is_active' => false,
        'personal_access_token_id' => null,
    ]);
});

test('admin reset password returns a new random temporary password on each reset', function () {
    $user = User::factory()->create();

    $first = loginAsAdmin()
        ->postJson("/api/users/{$user->id}/reset-password")
        ->json('data.temporary_password');

    $second = loginAsAdmin()
        ->postJson("/api/users/{$user->id}/reset-password")
        ->json('data.temporary_password');

    expect($first)->not->toBe($second);
});

test('admin can trigger reminder for opd user', function () {
    $sender = new class implements PushNotificationSender
    {
        public function sendToTokens(array $tokens, array $notification, array $data = []): array
        {
            return ['success_count' => count($tokens), 'failure_count' => 0];
        }
    };
    app()->instance(PushNotificationSender::class, $sender);

    $admin = User::factory()->create(['role' => 'admin']);
    $opd = User::factory()->create(['role' => 'opd']);
    DeviceToken::create([
        'user_id' => $opd->id,
        'token' => 'token-opd',
        'platform' => 'android',
        'is_active' => true,
    ]);
    $formulir = Formulir::factory()->create(['created_by_id' => $opd->id]);
    $domain = Domain::factory()->create();
    FormulirDomain::query()->create([
        'formulir_id' => $formulir->id,
        'domain_id' => $domain->id,
    ]);
    $domain->aspek()->create(['nama_aspek' => 'Aspek A']);
    $aspek = $domain->fresh()->aspek()->first();
    $indikatorA = Indikator::factory()->create(['aspek_id' => $aspek->id]);
    $indikatorB = Indikator::factory()->create(['aspek_id' => $aspek->id]);
    Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'indikator_id' => $indikatorA->id,
        'user_id' => $opd->id,
        'nilai' => 4,
    ]);

    $response = $this
        ->actingAs($admin, 'sanctum')
        ->postJson("/api/users/{$opd->id}/trigger-opd-reminder");

    $response->assertOk()
        ->assertJsonPath('data.incomplete_form_count', 1)
        ->assertJsonPath('data.sent', 1);
    $this->assertDatabaseHas('inbox_notifications', [
        'user_id' => $opd->id,
        'type' => 'incomplete_form_summary',
    ]);
});

test('admin cannot trigger reminder for non-opd user', function () {
    $user = User::factory()->create(['role' => 'walidata']);

    $response = loginAsAdmin()->postJson("/api/users/{$user->id}/trigger-opd-reminder");

    $response->assertStatus(422)
        ->assertJsonPath('message', 'Reminder hanya dapat dikirim ke user OPD.');

    expect(AuditLog::query()->count())->toBe(0);
    expect(\App\Models\InboxNotification::query()->count())->toBe(0);
});

test('trigger reminder returns informative message when opd has no incomplete forms', function () {
    $opd = User::factory()->create(['role' => 'opd']);

    $response = loginAsAdmin()->postJson("/api/users/{$opd->id}/trigger-opd-reminder");

    $response->assertOk()
        ->assertJsonPath('message', 'Semua formulir OPD ini sudah lengkap.')
        ->assertJsonPath('data.sent', 0)
        ->assertJsonPath('data.incomplete_form_count', 0);

    expect(AuditLog::query()->count())->toBe(0);
    expect(\App\Models\InboxNotification::query()->count())->toBe(0);
});

test('trigger reminder returns informative message when opd has no active device token', function () {
    $opd = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $opd->id]);
    $domain = Domain::factory()->create();
    FormulirDomain::query()->create([
        'formulir_id' => $formulir->id,
        'domain_id' => $domain->id,
    ]);
    $domain->aspek()->create(['nama_aspek' => 'Aspek A']);
    $aspek = $domain->fresh()->aspek()->first();
    $indikatorA = Indikator::factory()->create(['aspek_id' => $aspek->id]);
    $indikatorB = Indikator::factory()->create(['aspek_id' => $aspek->id]);
    Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'indikator_id' => $indikatorA->id,
        'user_id' => $opd->id,
        'nilai' => 4,
    ]);

    $response = loginAsAdmin()->postJson("/api/users/{$opd->id}/trigger-opd-reminder");

    $response->assertOk()
        ->assertJsonPath('message', 'Reminder dicatat ke inbox, tetapi user belum memiliki token device aktif.')
        ->assertJsonPath('data.sent', 0)
        ->assertJsonPath('data.incomplete_form_count', 1);
    $this->assertDatabaseHas('inbox_notifications', [
        'user_id' => $opd->id,
        'type' => 'incomplete_form_summary',
    ]);
});

test('admin trigger reminder locks summary payload for multiple incomplete forms', function () {
    $sender = new class implements PushNotificationSender
    {
        public array $messages = [];

        public function sendToTokens(array $tokens, array $notification, array $data = []): array
        {
            $this->messages[] = compact('tokens', 'notification', 'data');

            return ['success_count' => count($tokens), 'failure_count' => 0];
        }
    };
    app()->instance(PushNotificationSender::class, $sender);

    $admin = User::factory()->create(['role' => 'admin']);
    $opd = User::factory()->create(['role' => 'opd']);
    DeviceToken::create([
        'user_id' => $opd->id,
        'token' => 'token-opd',
        'platform' => 'android',
        'is_active' => true,
    ]);

    $firstForm = createIncompleteReminderFormForUser($opd, 'Form A');
    $secondForm = createIncompleteReminderFormForUser($opd, 'Form B');

    $response = $this
        ->actingAs($admin, 'sanctum')
        ->postJson("/api/users/{$opd->id}/trigger-opd-reminder");

    $response->assertOk()
        ->assertJsonPath('message', 'Reminder manual berhasil diproses untuk 2 formulir yang belum lengkap.')
        ->assertJsonPath('data.incomplete_form_count', 2)
        ->assertJsonPath('data.sent', 1);

    expect($sender->messages)->toHaveCount(1);
    expect($sender->messages[0]['data']['type'])->toBe('incomplete_form_summary');
    expect($sender->messages[0]['data']['target_route'])->toBe('/penilaian-mandiri');
    $formulirIds = json_decode($sender->messages[0]['data']['formulir_ids'], true);
    sort($formulirIds);
    expect($formulirIds)->toBe([
        (string) $firstForm->id,
        (string) $secondForm->id,
    ]);
});

function createIncompleteReminderFormForUser(User $opd, string $formName): Formulir
{
    $formulir = Formulir::factory()->create([
        'created_by_id' => $opd->id,
        'nama_formulir' => $formName,
    ]);
    $domain = Domain::factory()->create();
    FormulirDomain::query()->create([
        'formulir_id' => $formulir->id,
        'domain_id' => $domain->id,
    ]);
    $domain->aspek()->create(['nama_aspek' => 'Aspek A']);
    $aspek = $domain->fresh()->aspek()->first();
    $indikatorA = Indikator::factory()->create(['aspek_id' => $aspek->id]);
    $indikatorB = Indikator::factory()->create(['aspek_id' => $aspek->id]);
    Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'indikator_id' => $indikatorA->id,
        'user_id' => $opd->id,
        'nilai' => 4,
    ]);

    return $formulir;
}
