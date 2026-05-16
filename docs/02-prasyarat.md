# 02. Prasyarat Komputer

Dokumen ini untuk Windows. Buka PowerShell baru setelah mengubah PATH.

## 1. Tool yang Harus Terpasang

| Tool | Versi yang disarankan | Cek di terminal |
| --- | --- | --- |
| Git | Stable terbaru | `git --version` |
| PHP | 8.2 atau lebih baru | `php -v` |
| Composer | 2.x | `composer --version` |
| Node.js | 18 LTS atau lebih baru | `node -v` |
| npm | bawaan Node.js | `npm -v` |
| MySQL/MariaDB | bawaan XAMPP/Laragon cukup | `mysql --version` |
| Flutter SDK | yang membawa Dart 3.11 atau lebih baru | `flutter --version` |
| Android Studio | stable terbaru | `flutter doctor` |
| Android SDK Platform Tools | stable terbaru | `adb version` |

## 2. PATH Windows

Pastikan folder ini masuk PATH jika command belum dikenali:

- PHP XAMPP: `C:\xampp\php`
- PHP Laragon: `C:\laragon\bin\php\php-8.x.x`
- Composer: `C:\ProgramData\ComposerSetup\bin`
- Node.js: `C:\Program Files\nodejs`
- Flutter: folder `bin` di dalam Flutter SDK
- Android platform tools: `%LOCALAPPDATA%\Android\Sdk\platform-tools`

Jika `php`, `composer`, `flutter`, atau `adb` belum dikenali, masalahnya hampir selalu PATH.

## 3. Validasi Awal

Jalankan:

```powershell
git --version
php -v
composer --version
node -v
npm -v
flutter doctor
adb version
```

Selesaikan error dari `flutter doctor`, terutama bagian Android toolchain, sebelum menjalankan aplikasi mobile.

## 4. Clone Repositori

```powershell
git clone https://github.com/Hima-1/PARIKESIT.git Parikesit_Git
cd Parikesit_Git
git remote -v
```

Remote yang diharapkan:

```text
origin    https://github.com/Hima-1/PARIKESIT.git
upstream  https://github.com/selicel/PARIKESIT.git
```

Jika Anda sudah menerima folder repo dari orang lain, cukup masuk ke folder repo dan jalankan `git remote -v`.

## 5. Setelah Clone

Lanjut ke:

1. [03. Git dan File Rahasia](03-git-dan-file-rahasia.md)
2. [04. Konfigurasi Environment](04-konfigurasi-env.md)
3. [05. Setup Backend Lokal](05-setup-backend-lokal.md)
