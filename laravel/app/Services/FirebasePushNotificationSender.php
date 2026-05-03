<?php

namespace App\Services;

use App\Contracts\PushNotificationSender;
use App\Models\DeviceToken;
use GuzzleHttp\Client;
use GuzzleHttp\ClientInterface;
use GuzzleHttp\Exception\RequestException;
use Illuminate\Support\Facades\Log;
use RuntimeException;

class FirebasePushNotificationSender implements PushNotificationSender
{
    public function __construct(
        private readonly ?ClientInterface $http = null,
    ) {
    }

    public function sendToTokens(array $tokens, array $notification, array $data = []): array
    {
        $tokens = array_values(array_unique(array_filter($tokens)));
        if ($tokens === []) {
            return ['success_count' => 0, 'failure_count' => 0];
        }

        if (!$this->isConfigured()) {
            Log::warning('Firebase sender skipped because configuration is incomplete.');
            return ['success_count' => 0, 'failure_count' => count($tokens)];
        }

        $accessToken = $this->fetchAccessToken();
        $projectId = config('services.firebase.project_id');
        $client = $this->http ?? new Client([
            'base_uri' => 'https://fcm.googleapis.com',
            'timeout' => 15,
        ]);

        $successCount = 0;
        $failureCount = 0;

        foreach ($tokens as $token) {
            try {
                $client->post("/v1/projects/{$projectId}/messages:send", [
                    'headers' => [
                        'Authorization' => "Bearer {$accessToken}",
                        'Content-Type' => 'application/json',
                    ],
                    'json' => [
                        'message' => [
                            'token' => $token,
                            'notification' => $notification,
                            'data' => array_map(static fn ($value) => (string) $value, $data),
                            'android' => [
                                'priority' => 'high',
                            ],
                        ],
                    ],
                ]);
                $successCount++;
            } catch (\Throwable $e) {
                $failureCount++;
                $this->deactivateTokenIfUnregistered($token, $e);
                Log::warning('Failed sending FCM message.', [
                    'token' => $token,
                    'error' => $e->getMessage(),
                ]);
            }
        }

        return [
            'success_count' => $successCount,
            'failure_count' => $failureCount,
        ];
    }

    private function isConfigured(): bool
    {
        $credentials = $this->resolveCredentials();

        return filled($credentials['project_id'] ?? null)
            && filled($credentials['client_email'] ?? null)
            && filled($credentials['private_key'] ?? null);
    }

    private function fetchAccessToken(): string
    {
        $credentials = $this->resolveCredentials();
        $now = time();

        $header = $this->base64UrlEncode(json_encode([
            'alg' => 'RS256',
            'typ' => 'JWT',
        ], JSON_THROW_ON_ERROR));
        $payload = $this->base64UrlEncode(json_encode([
            'iss' => $credentials['client_email'],
            'scope' => 'https://www.googleapis.com/auth/firebase.messaging',
            'aud' => 'https://oauth2.googleapis.com/token',
            'iat' => $now,
            'exp' => $now + 3600,
        ], JSON_THROW_ON_ERROR));

        $unsignedJwt = "{$header}.{$payload}";
        $privateKey = openssl_pkey_get_private(str_replace('\n', "\n", $credentials['private_key']));
        if ($privateKey === false) {
            throw new RuntimeException('Invalid Firebase private key.');
        }

        $signature = '';
        openssl_sign($unsignedJwt, $signature, $privateKey, OPENSSL_ALGO_SHA256);
        $jwt = "{$unsignedJwt}.{$this->base64UrlEncode($signature)}";

        $client = $this->http ?? new Client([
            'base_uri' => 'https://oauth2.googleapis.com',
            'timeout' => 15,
        ]);
        $response = $client->post('/token', [
            'form_params' => [
                'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
                'assertion' => $jwt,
            ],
        ]);

        $payload = json_decode((string) $response->getBody(), true, 512, JSON_THROW_ON_ERROR);
        $accessToken = $payload['access_token'] ?? null;

        if (!is_string($accessToken) || $accessToken === '') {
            throw new RuntimeException('Firebase access token was not returned.');
        }

        return $accessToken;
    }

    private function resolveCredentials(): array
    {
        $configured = config('services.firebase.credentials');
        if (is_string($configured) && $configured !== '') {
            if (is_file($configured)) {
                return json_decode((string) file_get_contents($configured), true, 512, JSON_THROW_ON_ERROR);
            }

            $decoded = json_decode($configured, true);
            if (is_array($decoded)) {
                return $decoded;
            }
        }

        return [
            'project_id' => config('services.firebase.project_id'),
            'client_email' => config('services.firebase.client_email'),
            'private_key' => config('services.firebase.private_key'),
        ];
    }

    private function base64UrlEncode(string $value): string
    {
        return rtrim(strtr(base64_encode($value), '+/', '-_'), '=');
    }

    private function deactivateTokenIfUnregistered(string $token, \Throwable $error): void
    {
        if (! $error instanceof RequestException) {
            return;
        }

        $response = $error->getResponse();
        if ($response === null) {
            return;
        }

        $body = (string) $response->getBody();
        if (! str_contains($body, 'NotRegistered')) {
            return;
        }

        DeviceToken::query()
            ->where('token', $token)
            ->update([
                'is_active' => false,
            ]);
    }
}
