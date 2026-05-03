<?php

namespace App\Contracts;

interface PushNotificationSender
{
    public function sendToTokens(array $tokens, array $notification, array $data = []): array;
}
