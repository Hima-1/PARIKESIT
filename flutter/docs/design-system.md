# Parikesit Design System

Source of truth for visual & component conventions in the Flutter app. Read before adding UI.

The visual style is **Javanese Modern Heritage** — Sogan brown brand on cream/white surfaces, 1px hairline borders, minimal shadows (shadcn-inspired).

---

## 1. Tokens

All design values live under `lib/core/theme/tokens/`. Code outside that folder must consume tokens (or `Theme.of(context)`) — never write raw `Color(0xFF...)`, magic radius numbers, or duration literals in screens.

| File | Exposes | Use |
|------|---------|-----|
| `colors.dart` | `AppColors.soganBrown`, `.terracotta`, `.cream`, `.success/.error/.warning/.info`, `.textStrong/.textMuted/.textSubtle` | Brand + semantic + text colors |
| `typography.dart` | `AppTypography.display(...)`, `.body(...)`, `.labelTiny(...)` | Both font families pre-wired (Philosopher / Plus Jakarta Sans) |
| `radii.dart` | `AppRadii.sm/md/lg/rPill` + `.rrSm/.rrMd/.rrLg/.rrPill` (BorderRadius) | Component corners |
| `spacing.dart` | re-exports `AppSpacing` from `app_spacing.dart` | 4-pt grid, gaps, padding helpers |
| `elevation.dart` | `AppElevation.e0/e1/e2/e3` | Shadow lists. Most surfaces use `e0` (hairline border instead) |
| `motion.dart` | `AppMotion.instant/fast/base/slow` + curves | Animation durations |
| `breakpoints.dart` | `AppBreakpoint.compact/medium/expanded` + `AppBreakpoints.of(context)` | Responsive decisions |
| `tokens.dart` | barrel | `import 'package:parikesit/core/theme/tokens/tokens.dart';` |

`AppTheme.lightTheme` / `AppTheme.darkTheme` assemble tokens into `ThemeData`. Backward-compat aliases (`AppTheme.sogan`, `.gold`, …) still resolve to tokens — kept so existing code compiles, but **new code must use tokens or the theme directly**.

### Themes
- **Light** — active everywhere (`MaterialApp(themeMode: ThemeMode.light)`).
- **Dark** — minimal viable, mirrors light. Flip `themeMode` to enable; tested only at the structural level so far.

---

## 2. Components — what to use when

Browse the live gallery: `flutter run -t lib/widgetbook.dart`.

### Action
| Need | Component | Notes |
|------|-----------|-------|
| Any button | `EthnoButton` | Variants: `primary`/`secondary`/`success`/`outlined`/`text`/`danger`. Sizes: `small`/`medium`. Pass `isLoading: true` for the spinner state. |
| Icon-only "+" affordance | `AppAddIconButton` | Used as the pagination footer's add button. |

### Surface
| Need | Component | Notes |
|------|-----------|-------|
| Card | `EthnoCard` | Default white, hairline border. `showBatikAccent: true` adds a subtle Kawung pattern. |
| Inline status | `StatusBanner` | Banner with semantic color. |
| Divider | `EthnoDivider` | Theme-aware horizontal divider. |

### Input
`AppTextField`, `AppDropdownField`, `AppSortDropdownField`, `FileUploadField`, `MaturitySelector`. All consume the global `inputDecorationTheme` so they look consistent.

### List & filter
| Need | Component | Notes |
|------|-----------|-------|
| Search + filters + trailing action row | `AppFilterBar` | Slot-based (`search` / `filters` / `trailing`). Adapts at `narrowWidth`. |
| Debounced search field | `AppFilterSearchField` | Drop into `AppFilterBar.search`. |
| Paginated list (loading + empty + error + footer) | `PagedListView<T>` | Takes `AsyncValue<PaginatedResponse<T>>`. |
| Pagination footer only | `AppPaginationFooter` | When you build the list yourself but want the standard prev/next chrome. |

### Feedback / state
| Need | Component | Notes |
|------|-----------|-------|
| Empty state | `AppEmptyState` | Takes `title`, `message`, optional `actionLabel`. |
| Error state | `AppErrorState` | Takes `message`, optional `onRetry`. |
| Spinner placeholder | `AppLoadingState` | Use as quick fallback; prefer skeleton when layout is known. |
| Skeleton | `SkeletonLoader`, `ActivityCardSkeleton`, `AssessmentListSkeleton`, `DetailScreenSkeleton`, `StatsCardSkeleton` | Single shimmer source — do not add new shimmer files in features. |
| Toast | `ScaffoldMessenger.showSnackBar(...)` | (No custom toast wrapper yet — vanilla works.) |

### Dialog
| Need | Component | Notes |
|------|-----------|-------|
| Modal form | `AppFormDialog` | Header + scrollable body + cancel/submit footer. Pass `isSubmitting` to disable + show loading on submit. |

### Navigation / layout
`MainLayout` (mobile bottom nav vs. tablet sidebar), `AppHeader`, `AppSidebar`, `AppBottomNav`, `AppBreadcrumb`, `AppShortcutGrid`.

### Charts
`EthnoDonutChart`, `EthnoRadarChart`, `EthnoProgressBar`. Built on `fl_chart`.

### Helpers
`asyncView<T>(async, data: ...)` from `lib/core/helpers/async_view.dart` — render any `AsyncValue<T>` with the standard loading/error widgets. Variant: `asyncSliver<T>(...)` for `CustomScrollView`.

---

## 3. Conventions checklist

When reviewing or writing UI code, verify:

- [ ] No `Color(0xFF...)` outside `tokens/colors.dart`.
- [ ] No raw `BorderRadius.circular(<n>)` outside `tokens/radii.dart` (use `AppRadii.rr*`).
- [ ] No raw `EdgeInsets.all(<n>)` outside `tokens/spacing.dart` (use `AppSpacing.pAll*` / `pH*` / `pV*`).
- [ ] No `TextStyle(...)` literal in screens — read from `Theme.of(context).textTheme.*` or `EthnoTextTheme.of(context)`.
- [ ] No `Color(...).withOpacity(...)` — use `withValues(alpha: ...)` (already enforced by Flutter).
- [ ] Spacing widgets prefer `Gap(x)` (any flex) over bare `SizedBox`.
- [ ] `AsyncValue<T>` is rendered via `asyncView` or a domain wrapper — not by reimplementing `.when(loading:, error:, data:)`.
- [ ] Lists with `PaginatedResponse<T>` use `PagedListView<T>`.
- [ ] Domain widgets (e.g. `AssessmentStatusBadge`) live under `features/<x>/presentation/widgets/`, **not** in `core/widgets/`.
- [ ] Each new shared component has at least one use-case in `lib/widgetbook.dart`.

---

## 4. Adding a new component

1. **Check the gallery** — `flutter run -t lib/widgetbook.dart`. If something covers ≥80% of your case, extend it.
2. **Choose a home** — `core/widgets/` only if usable across ≥2 features. Otherwise `features/<x>/presentation/widgets/`.
3. **Consume tokens, not `AppTheme.<color>`.** Either read the `colorScheme` (preferred for brand-aware colors) or import from `tokens/`.
4. **No magic numbers.** If you need a new spacing/radius value, add it to the token file with a name; don't sprinkle literals.
5. **Add a Widgetbook use-case** in `lib/widgetbook.dart` covering the default state + at least one variant.
6. **Run `flutter analyze`** — must pass with zero errors. Info-level hints from new lints (e.g. `use_decorated_box`) should be fixed in your widget.

---

## 6. Legacy color migration

Around 300 call sites still reference legacy aliases on `AppTheme` (`AppTheme.sogan`, `.gold`, …). These aliases work today but **must not be used in new code**. Replace them per-file as you touch each screen, using this mapping:

| Legacy alias | Replacement (in widgets) | Notes |
|--------------|--------------------------|-------|
| `AppTheme.sogan`, `AppTheme.pusaka` | `AppColors.soganDeep` | Strong text / dark surface |
| `AppTheme.soganBrown`, `AppTheme.navy` | `Theme.of(context).colorScheme.primary` | Primary brand |
| `AppTheme.terracotta`, `AppTheme.gold`, `AppTheme.orange` | `Theme.of(context).colorScheme.secondary` | Accent (terracotta) |
| `AppTheme.info`, `AppTheme.cyan` | `AppColors.info` | Supporting accent |
| `AppTheme.merang` | `Theme.of(context).scaffoldBackgroundColor` or `AppColors.cream` | Page background |
| `AppTheme.lightBlue` | `AppColors.softWash` | Soft brown wash |
| `AppTheme.success`, `AppTheme.jatiGreen` | `AppColors.success` | OR `Theme.of(context).colorScheme.tertiaryContainer` if available |
| `AppTheme.error`, `AppTheme.sogaRed` | `Theme.of(context).colorScheme.error` | |
| `AppTheme.warning`, `AppTheme.kunyit` | `AppColors.warning` | |
| `AppTheme.neutral` | `AppColors.neutral` | |
| `AppTheme.borderColor`, `AppTheme.neutralGrey` | `Theme.of(context).colorScheme.outline` | Hairline border |
| `AppTheme.surface` | `Theme.of(context).colorScheme.surface` | Card / sheet |
| `AppTheme.textStrong` | `AppColors.textStrong` (or read from `textTheme`) | |
| `AppTheme.textMuted`, `AppTheme.textSubtle` | `AppColors.textMuted` / `.textSubtle` | |
| `AppTheme.radiusSm/Md/Lg`, `.borderRadius` | `AppRadii.sm/md/lg` (raw) or `AppRadii.rrSm/rrMd/rrLg` (BorderRadius) | |
| `AppTheme.hairlineBorder` | `Border.all(color: scheme.outline)` | |

**Why prefer `colorScheme.*` over `AppColors.*`?** `colorScheme` flips automatically between light/dark themes. Use raw `AppColors` only when the value is brand-stable (e.g. status badges, semantic colors that don't invert).

**Reference examples** (already migrated): [`app_empty_state.dart`](../lib/core/widgets/app_empty_state.dart), [`app_error_state.dart`](../lib/core/widgets/app_error_state.dart), [`ethno_button.dart`](../lib/core/widgets/ethno_button.dart), [`ethno_card.dart`](../lib/core/widgets/ethno_card.dart). Use these as a template when you migrate other widgets.

**Rule of thumb when touching a file:** if you're already editing it, replace any legacy `AppTheme.<alias>` you see while you're there. Don't open files just to migrate — let the changes happen organically.

---

## 7. Sprint history

The current state was reached over three sprints — see [`design.md`](../design.md) for the original analysis and roadmap.

- **Sprint 1** — Token folder, dark theme, domain widgets moved out of core, `gap` package adopted.
- **Sprint 2** — `EthnoButton`/`EthnoCard` consume tokens, skeletons consolidated, `AppFilterBar` / `PagedListView` / `AppFormDialog` / `asyncView` built.
- **Sprint 3** — Widgetbook gallery, additional lint rules, this document.
- **Sprint 4** — Breakpoint formalization, `cached_network_image`, entrance animations on feedback widgets, accessibility pass (tooltips + Semantics).
- **Sprint 5** — `dokumentasi_filter_bar` migrated to `AppFilterBar`; `app_empty_state` / `app_error_state` migrated to tokens as reference; legacy alias deprecation notice + migration mapping (§6).
