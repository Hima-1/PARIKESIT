// Component gallery entry point.
//
// Run with:
//   flutter run -t lib/widgetbook.dart
//
// Use this gallery to browse and try every shared widget in one place
// before reinventing. New components added under `lib/core/widgets/`
// should ship with at least one [WidgetbookUseCase] here.

import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import 'core/theme/app_spacing.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_empty_state.dart';
import 'core/widgets/app_error_state.dart';
import 'core/widgets/app_filter_bar.dart';
import 'core/widgets/app_form_dialog.dart';
import 'core/widgets/app_loading_state.dart';
import 'core/widgets/ethno_button.dart';
import 'core/widgets/ethno_card.dart';
import 'core/widgets/skeleton_loader.dart';

void main() {
  runApp(const _WidgetbookApp());
}

class _WidgetbookApp extends StatelessWidget {
  const _WidgetbookApp();

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        ThemeAddon<ThemeData>(
          themes: [
            WidgetbookTheme(name: 'Light', data: AppTheme.lightTheme),
            WidgetbookTheme(name: 'Dark', data: AppTheme.darkTheme),
          ],
          themeBuilder: (context, theme, child) =>
              Theme(data: theme, child: child),
        ),
        ViewportAddon(const [
          AndroidViewports.samsungGalaxyS20,
          AndroidViewports.samsungGalaxyA50,
          AndroidViewports.mediumTablet,
        ]),
      ],
      directories: [
        WidgetbookCategory(
          name: 'Action',
          children: [
            WidgetbookComponent(
              name: 'EthnoButton',
              useCases: [
                WidgetbookUseCase(
                  name: 'Variants',
                  builder: _ethnoButtonVariants,
                ),
                WidgetbookUseCase(
                  name: 'Loading',
                  builder: (_) => _padded(
                    EthnoButton(
                      onPressed: () {},
                      label: 'Menyimpan…',
                      isLoading: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        WidgetbookCategory(
          name: 'Surface',
          children: [
            WidgetbookComponent(
              name: 'EthnoCard',
              useCases: [
                WidgetbookUseCase(
                  name: 'Plain',
                  builder: (_) =>
                      _padded(const EthnoCard(child: Text('Card content'))),
                ),
                WidgetbookUseCase(
                  name: 'With batik accent',
                  builder: (_) => _padded(
                    const EthnoCard(
                      showBatikAccent: true,
                      child: SizedBox(
                        height: 120,
                        child: Center(child: Text('Highlighted card')),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        WidgetbookCategory(
          name: 'List & Filter',
          children: [
            WidgetbookComponent(
              name: 'AppFilterBar',
              useCases: [
                WidgetbookUseCase(
                  name: 'Search + filter + trailing',
                  builder: (_) => _padded(
                    AppFilterBar(
                      search: AppFilterSearchField(
                        initialValue: '',
                        hintText: 'Cari…',
                        onChanged: (_) {},
                      ),
                      filters: const [
                        InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                          ),
                          child: Text('Semua'),
                        ),
                      ],
                      trailing: IconButton(
                        icon: const Icon(Icons.tune),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        WidgetbookCategory(
          name: 'Feedback / State',
          children: [
            WidgetbookComponent(
              name: 'AppEmptyState',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (_) => const AppEmptyState(
                    title: 'Belum ada data',
                    message: 'Data akan muncul di sini setelah tersedia.',
                  ),
                ),
                WidgetbookUseCase(
                  name: 'With action',
                  builder: (_) => AppEmptyState(
                    title: 'Belum ada formulir',
                    message: 'Tambahkan formulir pertama Anda.',
                    actionLabel: 'Tambah Formulir',
                    onAction: () {},
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'AppErrorState',
              useCases: [
                WidgetbookUseCase(
                  name: 'With retry',
                  builder: (_) => AppErrorState(
                    message: 'Gagal memuat data. Silakan coba lagi.',
                    onRetry: () {},
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'AppLoadingState',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (_) => const AppLoadingState(),
                ),
                WidgetbookUseCase(
                  name: 'With message',
                  builder: (_) =>
                      const AppLoadingState(message: 'Memuat formulir…'),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'SkeletonLoader',
              useCases: [
                WidgetbookUseCase(
                  name: 'Block',
                  builder: (_) => _padded(
                    const SkeletonLoader(width: double.infinity, height: 60),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Activity card',
                  builder: (_) => _padded(const ActivityCardSkeleton()),
                ),
                WidgetbookUseCase(
                  name: 'Assessment list',
                  builder: (_) => const AssessmentListSkeleton(itemCount: 3),
                ),
              ],
            ),
          ],
        ),
        WidgetbookCategory(
          name: 'Dialog',
          children: [
            WidgetbookComponent(
              name: 'AppFormDialog',
              useCases: [
                WidgetbookUseCase(
                  name: 'Idle',
                  builder: (_) => AppFormDialog(
                    title: 'Tambah Formulir',
                    body: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: InputDecoration(labelText: 'Nama'),
                        ),
                        SizedBox(height: 12),
                        TextField(
                          decoration: InputDecoration(labelText: 'Deskripsi'),
                          maxLines: 3,
                        ),
                      ],
                    ),
                    onSubmit: () {},
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Submitting',
                  builder: (_) => AppFormDialog(
                    title: 'Tambah Formulir',
                    body: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text('Menyimpan perubahan…'),
                    ),
                    onSubmit: () {},
                    isSubmitting: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

Widget _padded(Widget child) => Padding(
  padding: AppSpacing.pAll16,
  child: Center(child: child),
);

Widget _ethnoButtonVariants(BuildContext context) => _padded(
  Wrap(
    spacing: 12,
    runSpacing: 12,
    alignment: WrapAlignment.center,
    children: [
      EthnoButton(onPressed: () {}, label: 'Primary'),
      EthnoButton(
        onPressed: () {},
        label: 'Secondary',
        style: EthnoButtonStyle.secondary,
      ),
      EthnoButton(
        onPressed: () {},
        label: 'Success',
        style: EthnoButtonStyle.success,
      ),
      EthnoButton(
        onPressed: () {},
        label: 'Danger',
        style: EthnoButtonStyle.danger,
      ),
      EthnoButton(
        onPressed: () {},
        label: 'Outlined',
        style: EthnoButtonStyle.outlined,
      ),
      EthnoButton(
        onPressed: () {},
        label: 'Text',
        style: EthnoButtonStyle.text,
      ),
    ],
  ),
);
