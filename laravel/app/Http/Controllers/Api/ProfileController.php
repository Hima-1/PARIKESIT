<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use App\Support\InputSanitizer;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;

class ProfileController extends Controller
{
    /**
     * Get the authenticated user's profile.
     */
    public function show(Request $request)
    {
        return new UserResource($request->user());
    }

    /**
     * Update the authenticated user's profile.
     */
    public function update(Request $request)
    {
        $user = $request->user();

        $request->merge([
            'name' => InputSanitizer::plainText($request->input('name'), 255),
            'email' => InputSanitizer::email($request->input('email')),
            'alamat' => InputSanitizer::nullablePlainText($request->input('alamat'), 1000),
            'nomor_telepon' => InputSanitizer::nullablePhone($request->input('nomor_telepon')),
        ]);

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users,email,'.$user->id,
            'alamat' => 'nullable|string|max:1000',
            'nomor_telepon' => ['nullable', 'string', 'max:20', 'regex:/^[0-9+()\-\s]{6,20}$/'],
            'current_password' => 'nullable|required_with:password|current_password',
            'password' => ['nullable', 'confirmed', Password::defaults()],
        ]);

        $user->fill([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'alamat' => $validated['alamat'] ?? $user->alamat,
            'nomor_telepon' => $validated['nomor_telepon'] ?? $user->nomor_telepon,
        ]);

        if ($request->filled('password')) {
            $user->password = Hash::make($validated['password']);
        }

        $user->save();

        return (new UserResource($user))->additional([
            'message' => 'Profil berhasil diperbarui',
        ]);
    }
}
