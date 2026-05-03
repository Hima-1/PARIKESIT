<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $user = User::where('email', $request->email)->first();

        if (! $user || ! Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['Kredensial yang diberikan salah.'],
            ]);
        }

        $expiration = (int) config('sanctum.expiration');
        $token = $user->createToken(
            'mobile-token',
            ['*'],
            now()->addMinutes($expiration > 0 ? $expiration : 120),
        )->plainTextToken;

        return response()->json([
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => new UserResource($user),
        ]);
    }

    public function logout(Request $request)
    {
        $currentToken = $request->user()->currentAccessToken();
        if ($currentToken) {
            $request->user()
                ->deviceTokens()
                ->where('personal_access_token_id', $currentToken->id)
                ->update([
                    'is_active' => false,
                ]);

            $currentToken->delete();
        }

        return response()->json([
            'message' => 'Berhasil logout'
        ]);
    }
}
