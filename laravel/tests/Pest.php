<?php

uses(
    Tests\DuskTestCase::class,
    // Illuminate\Foundation\Testing\DatabaseMigrations::class,
)->in('Browser');

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

/*
|--------------------------------------------------------------------------
| Test Case
|--------------------------------------------------------------------------
|
| The closure you provide to your test functions is always bound to a specific PHPUnit test
| case class. By default, that class is "PHPUnit\Framework\TestCase". Of course, you may
| need to change it using the "uses()" function to bind a different classes or traits.
|
*/

uses(TestCase::class, RefreshDatabase::class)->in('Feature');

/*
|--------------------------------------------------------------------------
| Expectations
|--------------------------------------------------------------------------
|
| When you're writing tests, you often need to check that values meet certain conditions. The
| "expect()" function gives you access to a set of "expectations" methods that you can use
| to assert different things. Of course, you may extend the Expectation API at any time.
|
*/

expect()->extend('toBeOne', function () {
    return $this->toBe(1);
});

/*
|--------------------------------------------------------------------------
| Functions
|--------------------------------------------------------------------------
|
| While Pest is very powerful out-of-the-box, you may have some testing code specific to your
| project that you don't want to repeat in every file. Here you can also expose helpers as
| global functions to help you to reduce the number of lines of code in your test files.
|
*/

/**
 * Set the currently authenticated user for the application.
 *
 * @return Tests\TestCase
 */
function loginAs(?User $user = null)
{
    return test()->actingAs($user ?? User::factory()->create(), 'sanctum');
}

/**
 * Set the currently authenticated admin for the application.
 *
 * @return Tests\TestCase
 */
function loginAsAdmin(?User $user = null)
{
    $user = $user ?? User::factory()->create(['role' => 'admin']);

    return test()->actingAs($user, 'sanctum');
}

/**
 * Create a browser-test user with a deterministic password and role.
 */
function duskUser(array $attributes = []): User
{
    return User::factory()->create(array_merge([
        'password' => bcrypt('password'),
        'role' => 'admin',
        'alamat' => 'Jl. Browser Test No. 1',
        'nomor_telepon' => '081234567890',
    ], $attributes));
}
