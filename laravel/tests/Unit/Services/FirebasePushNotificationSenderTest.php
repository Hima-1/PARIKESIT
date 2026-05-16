<?php

uses(Tests\TestCase::class, Illuminate\Foundation\Testing\RefreshDatabase::class);

use App\Models\DeviceToken;
use App\Models\User;
use App\Services\FirebasePushNotificationSender;
use GuzzleHttp\ClientInterface;
use GuzzleHttp\Exception\ClientException;
use GuzzleHttp\Psr7\Request;
use GuzzleHttp\Psr7\Response;

test('sender deactivates device token when firebase reports not registered', function () {
    app('config')->set('services.firebase.project_id', 'parikesit-fef3a');
    app('config')->set('services.firebase.client_email', 'firebase-adminsdk@example.com');
    app('config')->set('services.firebase.private_key', testPrivateKey());

    $user = User::factory()->create(['role' => 'opd']);
    DeviceToken::create([
        'user_id' => $user->id,
        'token' => 'token-not-registered',
        'platform' => 'android',
        'is_active' => true,
    ]);

    $http = new class implements ClientInterface
    {
        public function send(\Psr\Http\Message\RequestInterface $request, array $options = []): \Psr\Http\Message\ResponseInterface
        {
            throw new BadMethodCallException('Not used in this test.');
        }

        public function sendAsync(\Psr\Http\Message\RequestInterface $request, array $options = []): \GuzzleHttp\Promise\PromiseInterface
        {
            throw new BadMethodCallException('Not used in this test.');
        }

        public function request(string $method, $uri = '', array $options = []): \Psr\Http\Message\ResponseInterface
        {
            throw new BadMethodCallException('Not used in this test.');
        }

        public function requestAsync(string $method, $uri = '', array $options = []): \GuzzleHttp\Promise\PromiseInterface
        {
            throw new BadMethodCallException('Not used in this test.');
        }

        public function getConfig(?string $option = null): mixed
        {
            return null;
        }

        public function post($uri, array $options = []): \Psr\Http\Message\ResponseInterface
        {
            if ($uri === '/token') {
                return new Response(200, [], json_encode(['access_token' => 'test-access-token']));
            }

            throw new ClientException(
                'Not registered',
                new Request('POST', (string) $uri),
                new Response(404, [], json_encode([
                    'error' => [
                        'code' => 404,
                        'message' => 'NotRegistered',
                        'status' => 'NOT_FOUND',
                    ],
                ])),
            );
        }
    };

    $sender = new FirebasePushNotificationSender($http);
    $result = $sender->sendToTokens(
        ['token-not-registered'],
        ['title' => 'Reminder', 'body' => 'Test'],
        ['type' => 'incomplete_form_summary'],
    );

    expect($result['success_count'])->toBe(0);
    expect($result['failure_count'])->toBe(1);
    expect(DeviceToken::query()->where('token', 'token-not-registered')->value('is_active'))->toBeFalse();
});

test('sender includes android notification options for background notification bar delivery', function () {
    app('config')->set('services.firebase.project_id', 'parikesit-fef3a');
    app('config')->set('services.firebase.client_email', 'firebase-adminsdk@example.com');
    app('config')->set('services.firebase.private_key', testPrivateKey());

    $http = new CapturingFcmClient();
    $sender = new FirebasePushNotificationSender($http);

    $result = $sender->sendToTokens(
        ['active-token'],
        ['title' => 'Reminder', 'body' => 'Test'],
        ['type' => 'incomplete_form_summary', 'target_route' => '/penilaian-kegiatan'],
    );

    expect($result['success_count'])->toBe(1);
    expect($result['failure_count'])->toBe(0);
    expect($http->sentMessages)->toHaveCount(1);

    $message = $http->sentMessages[0];
    expect($message['token'])->toBe('active-token');
    expect($message['notification'])->toBe([
        'title' => 'Reminder',
        'body' => 'Test',
    ]);
    expect($message['data'])->toBe([
        'type' => 'incomplete_form_summary',
        'target_route' => '/penilaian-kegiatan',
    ]);
    expect(data_get($message, 'android.priority'))->toBe('high');
    expect(data_get($message, 'android.notification.channel_id'))->toBe('high_importance_channel');
    expect(data_get($message, 'android.notification.sound'))->toBe('default');
    expect(data_get($message, 'android.notification.default_sound'))->toBeTrue();
    expect(data_get($message, 'android.notification.notification_priority'))->toBe('PRIORITY_HIGH');
    expect(data_get($message, 'android.notification.visibility'))->toBe('PUBLIC');
});

function testPrivateKey(): string
{
    return <<<'KEY'
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDAdqvUWCuzjM6f
nxfsA4c5eB2E+iT/ZvY4Fk4pJ9in8NOH6ItL9Bd6JoY8kfi9hlAD5vYJoD8YVWK8
gVszQ3yY0lXv4Nmw3T9LK8Lm5qK1i0pDqT96UvDK5mU3xWMz8B4ZKp5s0x9W1Z5v
77UZ2TAiKrJL2W6yI2MPWqkhkU5AXQkK3zVOVQ2fJY0h+frPF9rP9u2BmR4KKw6w
tMkeTNk4P5h8R1mvsMGoVQwRYwJCuq8fM0YgBZ9dOqjZfi8iLk0u4JvIZ2WjlwmU
v5Vf/L6S0pCDRrM08P/5pJSksPOIxQ2lPQ9L8E0wZqkJ17fow2wsvWWs2Ik0Pwpg
Ybf1LjGXAgMBAAECggEAD3Qcq33U/9UNmWuxH60oxPz6H+/RQ3GpjGQtM5o69G+Q
3SDe6UVAeMtFtQRVQfVM2gTeV7rjwqKcHh2Gj3ztD2MwuE+W+E4JojFoLjJjHyCU
dD4tn2ukppx3cvIUS8qjlpvnidQ0dw1AcDvVvKgvSTeUegbXx0ca/2VjAKM8yuPk
es4jC/0urMlN+xk+IdSxSnC8F9fGpcbkJBHMTtZ3/l8nIdQUv8oSV5MoVOXzHk8q
zvlTTFwHIwhKy+vI9vj6y/uQ8aNcQdAris1L2N/S0Hn0lW1fyNx7N2hIPx6JaH6Q
ce2cMa75dr5W8zE2ArZ6+Gt9ZVrmANlNhJnC3usGSQKBgQD55BND0kxlw0xQRlfk
dLw3n6l/0OJvJ3GfJQ2lr64cIQ8vTBxjJf3biDe0q2Ij0pTxsmlnEhl0esZQnfAr
aDk4CK+0GA5xbApWnp+J0gV6BWdrmVJ8F01AJx7CAalUlW0U4Z2Kk9uFo2tZrc1M
W3j6M48a2WJkcQ02kZ/l/C7+5QKBgQDFpO6PC1NhNWCcn9cau4oKb1NT4U1E7h/G
zQXYM7Hj2sJ7SVobYgn91SQ3anJJB3OKYxygSJ8h0sylG9NJP3yQkBIxWmNPY2MW
8GS+Dr+zmQXNs1Oz+M76f1Y8z+T5M8Kjicb9blKpP5U+FCL4t6r9SP6dhDHdyAdE
Lx65rHL0HwKBgQDHF3lwNhR9QJ7WvTV3k8I0Y2gATul50p8o7jz4QrqS1zUoM8qS
tF7Iv/ah6eumVgrRk5h6H7JcQzVpBOWk4AEGUHwHoz5YyLg7A4qD8QyXhCHVwnPx
aQ2MDb7Ik3aGj/q+uhAnNsq0EHV7PzEZrKzFpaXOLAz4xJYrbzb8v5g9WQKBgFCV
q2Ea1uN0toIfM0/ctyvVsYgFYhxvf8E1CyizT5Dw4+LhrJ4Gfr/vkVbVW6xH5yBP
hppSe1kJtlgYVqfJWW8vbf+Pm0Bk9WU4J6b6BnQDf4OL+tCjlwmMmtnK0oL5XGoP
feJFL53X1U6GELnrb9gx4Wx+Y7J7DW0gY8mzckmJAoGABaTnFm7VTHXsuQ2HpD90
Ycvm4w+ZZ2N73lVEkflS4o0i2LYzl3HUhjrDAX7rnx6k+K1okqlS1v4w+pWmL6qW
5s7f8fQmqjU5Wjk3nwe+9Cbhmq5RWdyeKjEz2xC0sDKdqFu43N6MyATslOSxszU7
L/KtU+NLTQjRnS0bZR0NLvM=
-----END PRIVATE KEY-----
KEY;
}

class CapturingFcmClient implements ClientInterface
{
    public array $sentMessages = [];

    public function send(\Psr\Http\Message\RequestInterface $request, array $options = []): \Psr\Http\Message\ResponseInterface
    {
        throw new BadMethodCallException('Not used in this test.');
    }

    public function sendAsync(\Psr\Http\Message\RequestInterface $request, array $options = []): \GuzzleHttp\Promise\PromiseInterface
    {
        throw new BadMethodCallException('Not used in this test.');
    }

    public function request(string $method, $uri = '', array $options = []): \Psr\Http\Message\ResponseInterface
    {
        throw new BadMethodCallException('Not used in this test.');
    }

    public function requestAsync(string $method, $uri = '', array $options = []): \GuzzleHttp\Promise\PromiseInterface
    {
        throw new BadMethodCallException('Not used in this test.');
    }

    public function getConfig(?string $option = null): mixed
    {
        return null;
    }

    public function post($uri, array $options = []): \Psr\Http\Message\ResponseInterface
    {
        if ($uri === '/token') {
            return new Response(200, [], json_encode(['access_token' => 'test-access-token']));
        }

        $this->sentMessages[] = $options['json']['message'] ?? [];

        return new Response(200, [], json_encode(['name' => 'projects/parikesit-fef3a/messages/test-message']));
    }
}
