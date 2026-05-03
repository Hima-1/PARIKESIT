<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class UserService
{
    /**
     * Get list of users with filtering and sorting
     */
    public function getAllUsers($search = '', $sortBy = 'created_at', $sortDirection = 'desc', $perPage = 15)
    {
        $query = User::query();

        if (!empty($search)) {
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                    ->orWhere('email', 'like', "%{$search}%")
                    ->orWhere('role', 'like', "%{$search}%");
            });
        }

        return $query->orderBy($sortBy, $sortDirection)->paginate($perPage);
    }

    /**
     * Create a new user
     */
    public function createUser(array $data)
    {
        return User::create([
            'name' => $data['name'],
            'email' => $data['email'],
            'password' => Hash::make($data['password']),
            'role' => $data['role'],
            'alamat' => $data['alamat'] ?? null,
            'nomor_telepon' => $data['nomor_telepon'] ?? null,
        ]);
    }

    /**
     * Update an existing user
     */
    public function updateUser(User $user, array $data)
    {
        if (isset($data['password']) && !empty($data['password'])) {
            $data['password'] = Hash::make($data['password']);
        } else {
            unset($data['password']);
        }

        $user->update($data);

        return $user;
    }

    /**
     * Delete a user
     */
    public function deleteUser(User $user)
    {
        return $user->delete();
    }

    /**
     * Generate a temporary password, revoke active access, and return it once.
     */
    public function resetPassword(User $user): string
    {
        $temporaryPassword = Str::password(16, true, true, true, false);

        $user->tokens()->delete();
        $user->deviceTokens()->update([
            'is_active' => false,
            'personal_access_token_id' => null,
        ]);

        $user->forceFill([
            'password' => Hash::make($temporaryPassword),
        ])->save();

        return $temporaryPassword;
    }
}
