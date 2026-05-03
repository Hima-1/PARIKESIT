# Port Forwarding and Device Networking

The Laravel API normally runs at:

```text
http://127.0.0.1:8000/api
```

Android devices do not always interpret `127.0.0.1` the same way your computer does. Choose the target based on where the app runs.

## Connection Matrix

| Target | Laravel Command | Flutter `API_BASE_URL` | Notes |
| --- | --- | --- | --- |
| Windows browser | `php artisan serve --host=127.0.0.1 --port=8000` | Not needed | Browser is on the host. |
| Android Studio emulator | `php artisan serve --host=0.0.0.0 --port=8000` | `http://10.0.2.2:8000` | `10.0.2.2` maps to the host. |
| Physical USB device | `php artisan serve --host=0.0.0.0 --port=8000` | `http://127.0.0.1:8000` | Requires `adb reverse tcp:8000 tcp:8000`. |
| Physical Wi-Fi device | `php artisan serve --host=0.0.0.0 --port=8000` | `http://<computer-ip>:8000` | Phone and computer must share a network. |
| Genymotion emulator | `php artisan serve --host=0.0.0.0 --port=8000` | `http://10.0.3.2:8000` | Genymotion uses a different host alias. |

## USB Reverse Commands

```powershell
adb devices
adb reverse tcp:8000 tcp:8000
adb reverse --list
```

Remove old reverse mappings:

```powershell
adb reverse --remove-all
```

## Firewall Checks

If Wi-Fi mode cannot reach Laravel:

1. Confirm Laravel is bound to `0.0.0.0`, not only `127.0.0.1`.
2. Allow PHP through Windows Defender Firewall.
3. Confirm the phone and computer are on the same subnet.
4. Test from the phone browser: `http://<computer-ip>:8000`.
5. Then run Flutter with the same base URL.

## CORS

The local `.env.example` includes:

```dotenv
CORS_ALLOWED_ORIGINS=http://localhost,http://127.0.0.1:8000,http://10.0.2.2:8000
```

For a physical Wi-Fi device, add the LAN origin when needed:

```dotenv
CORS_ALLOWED_ORIGINS=http://localhost,http://127.0.0.1:8000,http://10.0.2.2:8000,http://192.168.1.25:8000
```
