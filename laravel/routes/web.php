<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\OpdNotificationController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\DomainController;
use App\Models\FormulirPenilaianDisposisi;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\FormulirController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\PembinaanController;
use App\Http\Controllers\PenilaianController;
use App\Http\Controllers\FilePembinaanController;
use App\Http\Controllers\FileDokumentasiController;
use App\Http\Controllers\DokumentasiKegiatanController;
use App\Http\Controllers\FormulirPenilaianDisposisiController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/


Route::middleware('auth')->group(function () {

    // Route::get('/',[DashboardController::class,'index'])->name('dashboard');

    Route::get('/', function () {
        return redirect()->route('dashboard');
    });

    Route::get('dashboard', [DashboardController::class, 'index'])->name('dashboard');

    Route::post('generate-penilaian', [DashboardController::class, 'generatePenilaian'])->name('dashboard.generate-penilaian');
    Route::resource('formulir', FormulirController::class);
    Route::get('formulir/{formulir}/set-default-children', [FormulirController::class, 'setDefaultChildren'])->name('formulir.set-default-children');

    Route::resource('formulir.domain', DomainController::class)->shallow()->only([
        'index',
        'create',
        'store',
        'edit',
        'update',
        'destroy'
    ]);


    Route::get('penilaian', [PenilaianController::class, 'index'])->name('penilaian.index');
    Route::resource('formulir.penilaian', PenilaianController::class)->shallow()->except('index');
    Route::get('formulir/{formulir}/penilaian-tersedia', [PenilaianController::class, 'penilaianTersedia'])->name('formulir.penilaianTersedia');
    Route::get('formulir/{formulir}/penilaian-tersedia/domain-penilaian', [PenilaianController::class, 'domainPenilaian'])->name('formulir.domain-penilaian');
    Route::get('formulir/{formulir}/penilaian-tersedia/domain-penilaian/{domain}', [PenilaianController::class, 'isiDomain'])->name('formulir.isi-domain');
    Route::get('formulir/{formulir}/penilaian-tersedia/domain-penilaian/{domain}/{aspek}/{indikator}', [PenilaianController::class, 'penilaianAspek'])->name('formulir.penilaianAspek');
    Route::post('formulir/{formulir}/penilaian-tersedia/domain-penilaian/{domain}/{aspek}/{indikator}/store-penilaian', [PenilaianController::class, 'store'])->name('formulir.store-penilaian');
    Route::post('formulir/{formulir}/penilaian-tersedia/domain-penilaian/{domain}/{aspek}/{indikator}/store-penilaian/{penilaian}', [PenilaianController::class, 'update'])->name('formulir.update-penilaian');

    Route::middleware('can:admin')->group(function () {
        Route::resource('pembinaan', PembinaanController::class);
        Route::get('file-pembinaan/{filePemb}/edit', [FilePembinaanController::class, 'edit'])->name('filePemb.edit');
        Route::put('file-pembinaan/{filePemb}', [FilePembinaanController::class, 'update'])->name('filePemb.update');
        Route::get('file-pembinaan/{filePemb}', [FilePembinaanController::class, 'destroy'])->name('filePemb.destroy');
        Route::get('pembinaan/{pembinaan}/download-all', [PembinaanController::class, 'downloadAll'])
            ->name('pembinaan.download-all');
    });


    Route::get('dokumentasi', [DokumentasiKegiatanController::class, 'index'])->name('dokumentasi.index');
    Route::get('dokumentasi/create', [DokumentasiKegiatanController::class, 'create'])->name('dokumentasi.create');
    Route::post('dokumentasi', [DokumentasiKegiatanController::class, 'store'])->name('dokumentasi.store');
    Route::get('dokumentasi/{dokumentasiKegiatan}/edit', [DokumentasiKegiatanController::class, 'edit'])->name('dokumentasi.edit');
    Route::put('dokumentasi/{dokumentasiKegiatan}', [DokumentasiKegiatanController::class, 'update'])->name('dokumentasi.update');
    Route::delete('dokumentasi/{dokumentasiKegiatan}', [DokumentasiKegiatanController::class, 'destroy'])->name('dokumentasi.destroy');
    Route::get('dokumentasi/{dokumentasiKegiatan}', [DokumentasiKegiatanController::class, 'show'])->name('dokumentasi.show');
    Route::get('dokumentasi/{dokumentasiKegiatan}/download-all', [DokumentasiKegiatanController::class, 'downloadAll'])
        ->name('dokumentasi.download-all');
    Route::post('dokumentasi/download-multiple', [DokumentasiKegiatanController::class, 'downloadMultiple'])
        ->name('dokumentasi.download-multiple');
    Route::get('dokumentasi/download', [DokumentasiKegiatanController::class, 'downloadPage'])
        ->name('dokumentasi.download-page');

    Route::get('file-dokumentasi/{fileDok}/edit', [FileDokumentasiController::class, 'edit'])->name('fileDok.edit');
    Route::put('file-dokumentasi/{fileDok}', [FileDokumentasiController::class, 'update'])->name('fileDok.update');
    Route::delete('file-dokumentasi/{fileDok}', [FileDokumentasiController::class, 'destroy'])->name('fileDok.destroy');


    Route::get('penilaian-selesai', [FormulirPenilaianDisposisiController::class, 'tersedia'])->name('disposisi.penilaian.tersedia');
    Route::get('penilaian-selesai/{formulir}', [FormulirPenilaianDisposisiController::class, 'detail'])->name('disposisi.penilaian.tersedia.detail');
    Route::get('penilaian-selesai/{opd}/{formulir}/koreksi-penilaian/{domain}', [FormulirPenilaianDisposisiController::class, 'koreksiIsiDomain'])->name('disposisi.koreksi.isi-domain');
    Route::get('penilaian-selesai/{opd}/{formulir}/penilaian-tersedia/domain-penilaian/{domain}/{aspek}/{indikator}/beri-koreksi', [FormulirPenilaianDisposisiController::class, 'koreksi'])->name('disposisi.koreksi.indikator.beri-koreksi');
    Route::post('penilaian-selesai/{opd}/{formulir}/penilaian-tersedia/domain-penilaian/{domain}/{aspek}/{indikator}/store/', [FormulirPenilaianDisposisiController::class, 'storeKoreksi'])->name('disposisi.koreksi.indikator.store-koreksi');
    Route::post('penilaian-selesai/{opd}/{formulir}/penilaian-tersedia/domain-penilaian/{domain}/{aspek}/{indikator}/update/', [FormulirPenilaianDisposisiController::class, 'updateEvaluasi'])->name('disposisi.koreksi.indikator.update-evaluasi');

    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');

    Route::middleware('can:admin')->group(function () {
        Route::resource('user', UserController::class);
        Route::get('notifikasi-opd', [OpdNotificationController::class, 'index'])
            ->name('opd-notifications.index');
        Route::post('user/{user}/reset-password', [UserController::class, 'resetPassword'])->name('user.reset-password');
        Route::post('user/{user}/trigger-opd-reminder', [UserController::class, 'triggerOpdReminder'])->name('user.trigger-opd-reminder');
        Route::post('user/trigger-opd-reminder/all', [UserController::class, 'triggerAllOpdReminder'])->name('user.trigger-opd-reminder.all');
        Route::post('user/trigger-opd-reminder/bulk', [UserController::class, 'triggerBulkOpdReminder'])->name('user.trigger-opd-reminder.bulk');
    });
});

require __DIR__ . '/auth.php';
