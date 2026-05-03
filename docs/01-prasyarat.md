# 01. Prasyarat

Project ini paling mudah dijalankan di Windows dengan XAMPP atau Laragon untuk MySQL, serta Android Studio untuk emulator dan Android SDK.

## 1. Tools yang Dibutuhkan

| Tool | Versi yang Disarankan | Perintah Cek |
| --- | --- | --- |
| Git | Stable terbaru | `git --version` |
| PHP | 8.2 atau lebih baru | `php -v` |
| Composer | 2.x | `composer --version` |
| Node.js | 18 LTS atau lebih baru | `node -v` |
| npm | Bawaan Node.js | `npm -v` |
| MySQL atau MariaDB | Versi bawaan XAMPP/Laragon cukup | `mysql --version` |
| Flutter SDK | Versi yang memuat Dart 3.11 atau lebih baru | `flutter --version` |
| Android Studio | Stable terbaru | `flutter doctor` |
| Android SDK Platform Tools | Stable terbaru | `adb version` |

## 2. PATH Windows

Pastikan folder berikut bisa diakses dari terminal PowerShell baru:

- PHP dari XAMPP: `C:\xampp\php`
- PHP dari Laragon: biasanya `C:\laragon\bin\php\php-8.x.x`
- Composer: biasanya `C:\ProgramData\ComposerSetup\bin`
- Node.js: biasanya `C:\Program Files\nodejs`
- Flutter: folder `bin` di dalam Flutter SDK
- Android platform tools: biasanya `%LOCALAPPDATA%\Android\Sdk\platform-tools`

Setelah mengubah PATH, tutup dan buka ulang PowerShell.

## 3. Validasi

Jalankan:

```powershell
php -v
composer --version
node -v
npm -v
flutter doctor
adb version
```

Selesaikan error Android toolchain dari `flutter doctor` sebelum menjalankan aplikasi mobile.

## 4. Clone Repositori

```powershell
git clone https://github.com/Hima-1/PARIKESIT.git Parikesit_Git
cd Parikesit_Git
git remote -v
```

Remote yang diharapkan untuk atribusi:

```text
origin    https://github.com/Hima-1/PARIKESIT.git
upstream  https://github.com/selicel/PARIKESIT.git
```
