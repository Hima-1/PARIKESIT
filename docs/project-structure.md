# Project Structure and Repository Hygiene

## Layout

```text
Parikesit_Git/
  README.md
  docs/
  parikesit_git/
    laravel/
    flutter/
```

## Laravel App

`parikesit_git/laravel` contains:

- Laravel 10 web routes in `routes/web.php`
- Laravel Sanctum API routes in `routes/api.php`
- Domain models in `app/Models`
- API and web controllers in `app/Http/Controllers`
- Repeatable seeders in `database/seeders`
- Feature and API tests in `tests`

Install-time or runtime artifacts are ignored:

- `vendor`
- `node_modules`
- `.env`
- `public/build`
- uploaded files under `public` and `storage/app/public`
- cached sessions, compiled views, logs, and keys

## Flutter App

`parikesit_git/flutter` contains:

- Android project in `android`
- app source in `lib`
- unit/widget tests in `test`
- Android integration tests in `integration_test`
- Flutter docs in `docs`

Generated or local-only files are ignored:

- `.dart_tool`
- `build`
- `.flutter-plugins-dependencies`
- Android Gradle caches
- `android/local.properties`
- `android/app/google-services.json`
- signing keys and release artifacts

## Attribution

The target repository is a fork of the upstream Parikesit repository. Keep both `origin` and `upstream` remotes so future maintainers can see and reconcile the original project history:

```powershell
git remote -v
```

Use `origin` for your fork and `upstream` for the original owner.

## Commit Strategy

Keep future migrations split by concern:

- source relocation or sync
- ignore/cleanup changes
- backend configuration
- Flutter configuration
- documentation
- tests or verification fixes

This makes review and attribution easier than a single large commit.
