# 06. Menjalankan Flutter Android

Aplikasi Flutter membaca target backend dari `API_BASE_URL`. Nilai ini harus berbeda tergantung target Android.

## 1. Siapkan Flutter

```powershell
cd flutter
flutter pub get
flutter doctor
```

Jika file generated model perlu diperbarui:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

## 2. Jalankan Backend Dulu

Di terminal Laravel:

```powershell
cd laravel
php artisan serve --host=0.0.0.0 --port=8000
```

Backend harus tetap berjalan selama Flutter dipakai.

## 3. Emulator Android Studio

Jalankan emulator:

```powershell
cd flutter
flutter emulators
flutter emulators --launch <emulator_id>
```

Jalankan aplikasi:

```powershell
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

`10.0.2.2` adalah alamat khusus dari emulator Android Studio untuk mengakses komputer host.

## 4. HP Fisik dengan USB Debugging

1. Aktifkan Developer Options di HP.
2. Aktifkan USB debugging.
3. Hubungkan HP ke komputer.
4. Setujui prompt otorisasi di HP.
5. Cek perangkat:

```powershell
adb devices
```

Teruskan port:

```powershell
adb reverse tcp:8000 tcp:8000
adb reverse --list
```

Jalankan aplikasi:

```powershell
cd flutter
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000
```

## 5. HP Fisik lewat Wi-Fi

Gunakan cara ini jika USB reverse tidak tersedia.

1. Komputer dan HP harus berada di jaringan Wi-Fi yang sama.
2. Laravel harus berjalan dengan `--host=0.0.0.0`.
3. Cari IPv4 komputer:

```powershell
ipconfig
```

4. Jalankan Flutter dengan IP komputer:

```powershell
cd flutter
flutter run --dart-define=API_BASE_URL=http://192.168.1.25:8000
```

Ganti `192.168.1.25` dengan IPv4 komputer Anda.

## 6. Firebase Optional untuk Development

Clone baru tetap bisa build tanpa `flutter/android/app/google-services.json` karena Google Services plugin hanya aktif ketika file tersedia.

Jika ingin menguji FCM:

1. Unduh `google-services.json` dari Firebase Console.
2. Simpan ke `flutter/android/app/google-services.json`.
3. Pastikan env Firebase di Laravel sudah diisi jika backend perlu mengirim push notification.
4. Jalankan ulang:

```powershell
flutter clean
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

Detailnya ada di [08. Firebase dan FCM](08-firebase-fcm.md).
