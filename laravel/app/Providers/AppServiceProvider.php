<?php

namespace App\Providers;

use App\Contracts\PushNotificationSender;
use App\Services\FirebasePushNotificationSender;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        $this->app->bind(
            PushNotificationSender::class,
            FirebasePushNotificationSender::class,
        );
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        //
    }
}
