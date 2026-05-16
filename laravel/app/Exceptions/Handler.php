<?php

namespace App\Exceptions;

use Illuminate\Auth\Access\AuthorizationException;
use Illuminate\Auth\AuthenticationException;
use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpKernel\Exception\AccessDeniedHttpException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Throwable;

class Handler extends ExceptionHandler
{
    /**
     * A list of exception types with their corresponding custom log levels.
     *
     * @var array<class-string<\Throwable>, \Psr\Log\LogLevel::*>
     */
    protected $levels = [
        //
    ];

    /**
     * A list of the exception types that are not reported.
     *
     * @var array<int, class-string<\Throwable>>
     */
    protected $dontReport = [
        //
    ];

    /**
     * A list of the inputs that are never flashed to the session on validation exceptions.
     *
     * @var array<int, string>
     */
    protected $dontFlash = [
        'current_password',
        'password',
        'password_confirmation',
    ];

    /**
     * Register the exception handling callbacks for the application.
     */
    public function register(): void
    {
        $this->reportable(function (Throwable $e) {
            //
        });

        $this->renderable(function (Throwable $e, $request) {
            if ($request->is('api/*') || $request->expectsJson()) {
                return $this->handleApiExceptions($e, $request);
            }
        });
    }

    /**
     * Handle exceptions for API requests.
     */
    protected function handleApiExceptions(Throwable $e, $request)
    {
        if ($e instanceof NotFoundHttpException) {
            return response()->json([
                'message' => 'Data yang diminta tidak ditemukan.',
            ], 404);
        }

        if ($e instanceof AuthenticationException) {
            return response()->json([
                'message' => 'Unauthenticated',
            ], 401);
        }

        if (
            $e instanceof AccessDeniedHttpException
            || $e instanceof AuthorizationException
        ) {
            return response()->json([
                'message' => 'Anda tidak memiliki akses untuk melakukan aksi ini.',
            ], 403);
        }

        if ($e instanceof ValidationException) {
            return response()->json([
                'message' => $e->getMessage(),
                'errors' => $e->errors(),
            ], 422);
        }

        // General Fallback
        $response = [
            'message' => config('app.debug')
                ? $e->getMessage()
                : 'Server sedang mengalami gangguan. Silakan coba lagi nanti.',
        ];

        if (config('app.debug')) {
            $response['exception'] = get_class($e);
            // $response['trace'] = $e->getTrace();
        }

        return response()->json($response, 500);
    }
}
