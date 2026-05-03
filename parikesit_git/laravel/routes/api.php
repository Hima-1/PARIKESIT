<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\DeviceTokenController;
use App\Http\Controllers\Api\DokumentasiKegiatanController;
use App\Http\Controllers\Api\FileDokumentasiController;
use App\Http\Controllers\Api\FilePembinaanController;
use App\Http\Controllers\Api\FormulirController;
use App\Http\Controllers\Api\FormulirPenilaianDisposisiController;
use App\Http\Controllers\Api\NotificationController;
use App\Http\Controllers\Api\PembinaanController;
use App\Http\Controllers\Api\PenilaianController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\UserManagementController;
use App\Http\Resources\UserResource;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::post('/login', [AuthController::class, 'login']);

Route::get('public/penilaian-selesai', [FormulirPenilaianDisposisiController::class, 'publicTersedia']);
Route::get('public/penilaian-selesai/{formulir}/opds', [FormulirPenilaianDisposisiController::class, 'publicOpds']);
Route::get('public/penilaian-selesai/{formulir}/opd/{user}', [FormulirPenilaianDisposisiController::class, 'publicOpdDetail']);

if (app()->environment('testing')) {
    Route::get('/test-500', function () {
        throw new \Exception('Test 500 error');
    });
}

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', function (Request $request) {
        // Keep the response shape backward compatible (raw user object)
        // while still using the sanitized UserResource contract.
        return response()->json((new UserResource($request->user()))->resolve($request));
    });

    // Profile Routes
    Route::get('/profile', [ProfileController::class, 'show']);
    Route::patch('/profile', [ProfileController::class, 'update']);
    Route::post('/profile/update', [ProfileController::class, 'update']); // Fallback for multipart formData
    Route::post('/me/devices/fcm-token', [DeviceTokenController::class, 'store']);
    Route::delete('/me/devices/fcm-token', [DeviceTokenController::class, 'deactivate']);
    Route::get('/notifications', [NotificationController::class, 'index']);
    Route::delete('/notifications/read', [NotificationController::class, 'hideRead']);
    Route::patch('/notifications/read-all', [NotificationController::class, 'markAllAsRead']);
    Route::patch('/notifications/{notification}/read', [NotificationController::class, 'markAsRead']);
    Route::delete('/notifications/{notification}', [NotificationController::class, 'destroy']);

    // Pembinaan Routes
    Route::get('pembinaan/download-batch', [PembinaanController::class, 'downloadBatch']);
    Route::apiResource('pembinaan', PembinaanController::class);
    Route::post('pembinaan/{pembinaan}', [PembinaanController::class, 'update']); // Override patch/put for multipart formData
    Route::get('pembinaan/{pembinaan}/download', [PembinaanController::class, 'download']);
    Route::delete('file-pembinaan/{filePemb}', [FilePembinaanController::class, 'destroy']);

    // Dokumentasi Routes
    Route::get('dokumentasi/download-batch', [DokumentasiKegiatanController::class, 'downloadBatch']);
    Route::apiResource('dokumentasi', DokumentasiKegiatanController::class);
    Route::post('dokumentasi/{dokumentasi}', [DokumentasiKegiatanController::class, 'update']); // Override patch/put for multipart formData
    Route::get('dokumentasi/{dokumentasi}/download', [DokumentasiKegiatanController::class, 'download']);
    Route::delete('file-dokumentasi/{fileDok}', [FileDokumentasiController::class, 'destroy']);

    // Disposisi (Penilaian Selesai) Routes
    Route::get('penilaian-selesai', [FormulirPenilaianDisposisiController::class, 'tersedia']);
    Route::get('penilaian-selesai/{formulir}/opds', [FormulirPenilaianDisposisiController::class, 'getOpds']);
    Route::get('penilaian-selesai/{formulir}/summary', [FormulirPenilaianDisposisiController::class, 'getSummary']);
    Route::get('penilaian-selesai/{formulir}/opd/{user}/stats', [FormulirPenilaianDisposisiController::class, 'getOpdStats']);
    Route::get('penilaian-selesai/{formulir}/opd/{user}/domains', [FormulirPenilaianDisposisiController::class, 'getOpdDomainStats']);
    Route::post('penilaian-selesai/koreksi', [FormulirPenilaianDisposisiController::class, 'storeKoreksi']);
    Route::post('penilaian-selesai/evaluasi', [FormulirPenilaianDisposisiController::class, 'updateEvaluasi']);

    // Formulir Routes
    Route::get('/formulir', [FormulirController::class, 'index']);
    Route::post('/formulir', [FormulirController::class, 'store']);
    Route::get('/formulir/{formulir}', [FormulirController::class, 'show']);
    Route::patch('/formulir/{formulir}', [FormulirController::class, 'update']);
    Route::delete('/formulir/{formulir}', [FormulirController::class, 'destroy']);
    Route::post('/formulir/{formulir}/set-default-children', [FormulirController::class, 'setDefaultChildren']);
    Route::post('/formulir/{formulir}/domains', [FormulirController::class, 'storeDomain']);

    // Dashboard & Analytics Routes
    Route::get('dashboard/stats', [DashboardController::class, 'getStats']);
    Route::get('dashboard/performa-opd', [DashboardController::class, 'getOPDPerformance']);
    Route::get('dashboard/progress-penilaian', [DashboardController::class, 'getAssessmentProgress']);

    // Penilaian Routes
    Route::get('/formulir/{formulir}/indicators', [PenilaianController::class, 'getIndicators']);
    Route::post('/formulir/{formulir}/indikator/{indikator}/penilaian', [PenilaianController::class, 'store']);

    // Admin Only Routes
    Route::middleware('can:admin')->group(function () {
        // User Management
        Route::get('users', [UserManagementController::class, 'index']);
        Route::post('users', [UserManagementController::class, 'store']);
        Route::get('users/{user}', [UserManagementController::class, 'show']);
        Route::patch('users/{user}', [UserManagementController::class, 'update']);
        Route::delete('users/{user}', [UserManagementController::class, 'destroy']);
        Route::post('users/{user}/reset-password', [UserManagementController::class, 'resetPassword']);
        Route::post('users/{user}/trigger-opd-reminder', [UserManagementController::class, 'triggerOpdReminder']);
    });
});
