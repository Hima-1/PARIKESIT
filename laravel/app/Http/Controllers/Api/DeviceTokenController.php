<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\DeactivateFcmTokenRequest;
use App\Http\Requests\RegisterFcmTokenRequest;
use App\Models\DeviceToken;

class DeviceTokenController extends Controller
{
    public function store(RegisterFcmTokenRequest $request)
    {
        $user = $request->user();

        $deviceToken = DeviceToken::updateOrCreate(
            ['token' => $request->string('token')->toString()],
            [
                'user_id' => $user->id,
                'personal_access_token_id' => $user->currentAccessToken()?->id,
                'platform' => $request->string('platform')->toString(),
                'device_name' => $request->input('device_name'),
                'app_version' => $request->input('app_version'),
                'last_seen_at' => now(),
                'is_active' => true,
            ],
        );

        return response()->json([
            'message' => 'FCM token tersimpan',
            'data' => [
                'id' => $deviceToken->id,
                'token' => $deviceToken->token,
                'platform' => $deviceToken->platform,
                'device_name' => $deviceToken->device_name,
                'app_version' => $deviceToken->app_version,
                'is_active' => $deviceToken->is_active,
            ],
        ]);
    }

    public function deactivate(DeactivateFcmTokenRequest $request)
    {
        $request->user()
            ->deviceTokens()
            ->where('token', $request->string('token')->toString())
            ->update([
                'is_active' => false,
            ]);

        return response()->json([
            'message' => 'FCM token dinonaktifkan',
        ]);
    }
}
