# 05. Port Forwarding dan Jaringan Perangkat

API Laravel biasanya berjalan di:

```text
http://127.0.0.1:8000/api
```

Perangkat Android tidak selalu menafsirkan `127.0.0.1` seperti komputer host. Pilih target berdasarkan tempat aplikasi berjalan.

## 1. Matriks Koneksi

| Target | Perintah Laravel | Flutter `API_BASE_URL` | Catatan |
| --- | --- | --- | --- |
| Browser Windows | `php artisan serve --host=127.0.0.1 --port=8000` | Tidak perlu | Browser berjalan di host. |
| Emulator Android Studio | `php artisan serve --host=0.0.0.0 --port=8000` | `http://10.0.2.2:8000` | `10.0.2.2` mengarah ke host. |
| Perangkat fisik USB | `php artisan serve --host=0.0.0.0 --port=8000` | `http://127.0.0.1:8000` | Perlu `adb reverse tcp:8000 tcp:8000`. |
| Perangkat fisik Wi-Fi | `php artisan serve --host=0.0.0.0 --port=8000` | `http://<ip-komputer>:8000` | Ponsel dan komputer harus satu jaringan. |
| Emulator Genymotion | `php artisan serve --host=0.0.0.0 --port=8000` | `http://10.0.3.2:8000` | Genymotion memakai alias host berbeda. |

## 2. Perintah USB Reverse

```powershell
adb devices
adb reverse tcp:8000 tcp:8000
adb reverse --list
```

Hapus mapping reverse lama:

```powershell
adb reverse --remove-all
```

## 3. Cek Firewall

Jika mode Wi-Fi tidak bisa menjangkau Laravel:

1. Pastikan Laravel bind ke `0.0.0.0`, bukan hanya `127.0.0.1`.
2. Izinkan PHP lewat Windows Defender Firewall.
3. Pastikan ponsel dan komputer berada di subnet yang sama.
4. Tes dari browser ponsel: `http://<ip-komputer>:8000`.
5. Jalankan Flutter dengan base URL yang sama.

## 4. CORS

`.env.example` lokal memuat:

```dotenv
CORS_ALLOWED_ORIGINS=http://localhost,http://127.0.0.1:8000,http://10.0.2.2:8000
```

Untuk perangkat fisik lewat Wi-Fi, tambahkan origin LAN jika dibutuhkan:

```dotenv
CORS_ALLOWED_ORIGINS=http://localhost,http://127.0.0.1:8000,http://10.0.2.2:8000,http://192.168.1.25:8000
```
