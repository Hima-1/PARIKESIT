# Dokumentasi Parikesit Flutter

Dokumentasi publik proyek diringkas menjadi beberapa file inti saja:

- `docs/architecture.md`: konteks sistem, modul, alur bisnis, dan catatan implementasi Flutter
- `docs/api.md`: kontrak API yang dipakai mobile, termasuk auth, notifikasi, dan endpoint per role
- `docs/ui.md`: peta screen per role dan relasi screen ke endpoint
- `docs/deployment.md`: overview deployment stack saat ini, termasuk hubungan Flutter Android, Laravel API, storage, cron, dan Firebase
- `docs/firebase-fcm.md`: setup Firebase/FCM end-to-end untuk Android client dan Laravel server
- `docs/mobile-production.md`: input build Android production, `--dart-define`, dan checklist validasi release
- `docs/reference/schema.md`: ringkasan struktur data backend yang dikonsumsi mobile

Dokumen internal dipisahkan dari dokumentasi publik:

- `docs/internal/`: catatan kerja internal, plan, atau artefak agent
- `docs/reference/`: referensi teknis yang bersifat lampiran

Urutan baca untuk deployment:

1. `docs/deployment.md`
2. `../../parikesit_laravel/docs/hosting-cpanel.md`
3. `docs/firebase-fcm.md`
4. `docs/mobile-production.md`
5. `../../parikesit_laravel/docs/operations-postdeploy.md`
