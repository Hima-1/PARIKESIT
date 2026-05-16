# 07. Jaringan Android dan Port Forwarding

Masalah paling umum saat Flutter Android tidak bisa login adalah URL backend salah.

## 1. Kenapa `127.0.0.1` Bisa Membingungkan?

`127.0.0.1` berarti "perangkat ini sendiri".

- Di komputer Windows, `127.0.0.1` adalah komputer.
- Di emulator Android, `127.0.0.1` adalah emulator, bukan komputer.
- Di HP fisik, `127.0.0.1` adalah HP, bukan komputer.

Karena itu target API harus disesuaikan.

## 2. Matriks Koneksi

| Target | Laravel command | Flutter `API_BASE_URL` | Catatan |
| --- | --- | --- | --- |
| Browser Windows | `php artisan serve --host=127.0.0.1 --port=8000` | Tidak perlu | Browser berjalan di komputer |
| Emulator Android Studio | `php artisan serve --host=0.0.0.0 --port=8000` | `http://10.0.2.2:8000` | `10.0.2.2` mengarah ke komputer host |
| HP fisik USB | `php artisan serve --host=0.0.0.0 --port=8000` | `http://127.0.0.1:8000` | Perlu `adb reverse tcp:8000 tcp:8000` |
| HP fisik Wi-Fi | `php artisan serve --host=0.0.0.0 --port=8000` | `http://<ip-komputer>:8000` | HP dan komputer harus satu jaringan |
| Emulator Genymotion | `php artisan serve --host=0.0.0.0 --port=8000` | `http://10.0.3.2:8000` | Alias host Genymotion berbeda |

## 3. USB Reverse

```powershell
adb devices
adb reverse tcp:8000 tcp:8000
adb reverse --list
```

Hapus mapping lama:

```powershell
adb reverse --remove-all
```

## 4. Firewall Windows

Jika HP Wi-Fi tidak bisa membuka Laravel:

1. Pastikan Laravel bind ke `0.0.0.0`, bukan hanya `127.0.0.1`.
2. Izinkan PHP di Windows Defender Firewall.
3. Pastikan HP dan komputer berada di subnet yang sama.
4. Coba buka dari browser HP:

```text
http://<ip-komputer>:8000
```

Jika browser HP tidak bisa membuka URL itu, Flutter juga tidak akan bisa.

## 5. CORS

Untuk local, `.env` Laravel boleh memuat:

```dotenv
CORS_ALLOWED_ORIGINS=http://localhost,http://127.0.0.1:8000,http://10.0.2.2:8000
```

Untuk HP Wi-Fi, tambahkan IP komputer jika dibutuhkan:

```dotenv
CORS_ALLOWED_ORIGINS=http://localhost,http://127.0.0.1:8000,http://10.0.2.2:8000,http://192.168.1.25:8000
```

Setelah mengubah `.env`:

```powershell
cd laravel
php artisan config:clear
```
