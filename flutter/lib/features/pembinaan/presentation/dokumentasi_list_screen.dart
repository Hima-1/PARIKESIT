import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parikesit/core/auth/user_role.dart';
import 'package:parikesit/core/router/route_constants.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/app_add_icon_button.dart';
import 'package:parikesit/features/admin/presentation/widgets/dokumentasi_form.dart';

import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_pagination_footer.dart';
import '../../admin/presentation/controller/admin_dokumentasi_controller.dart';
import '../../admin/presentation/controller/admin_dokumentasi_state.dart';
import '../../admin/presentation/widgets/dokumentasi_filter_bar.dart';
import 'widgets/dokumentasi_list_item.dart';

class DokumentasiListScreen extends ConsumerStatefulWidget {
  const DokumentasiListScreen({
    super.key,
    this.initialMode = DokumentasiMode.kegiatan,
  });

  final DokumentasiMode initialMode;

  @override
  ConsumerState<DokumentasiListScreen> createState() =>
      _DokumentasiListScreenState();
}

class _DokumentasiListScreenState extends ConsumerState<DokumentasiListScreen> {
  @override
  void initState() {
    super.initState();
    // Set initial mode based on route or widget property
    Future.microtask(() {
      ref
          .read(adminDokumentasiControllerProvider.notifier)
          .setMode(widget.initialMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminDokumentasiControllerProvider);
    final notifier = ref.read(adminDokumentasiControllerProvider.notifier);
    final role = ref.watch(userRoleProvider);

    final bool isAdmin = role == UserRole.admin;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          state.mode == DokumentasiMode.kegiatan ? 'Kegiatan' : 'Pembinaan',
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (isAdmin) _buildToggle(context, state, notifier),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 6, 16, 10),
            child: DokumentasiFilterBar(),
          ),
          Expanded(
            child: _buildRefreshableContent(context, state, isAdmin, role),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() {
    return ref.read(adminDokumentasiControllerProvider.notifier).refresh();
  }

  Widget _buildScrollableState({required Widget child}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: child,
            ),
          ],
        );
      },
    );
  }

  Widget _buildRefreshableContent(
    BuildContext context,
    AdminDokumentasiState state,
    bool isAdmin,
    UserRole role,
  ) {
    if (state.isLoading && state.currentItems.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(AppTheme.sogan),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.sogan,
      child: _buildContentBody(context, state, isAdmin, role),
    );
  }

  Widget _buildContentBody(
    BuildContext context,
    AdminDokumentasiState state,
    bool isAdmin,
    UserRole role,
  ) {
    if (state.errorMessage != null) {
      return _buildScrollableState(
        child: AppErrorState(
          message: state.errorMessage!,
          onRetry: _handleRefresh,
        ),
      );
    }

    return _buildList(context, state, isAdmin, role);
  }

  Widget _buildToggle(
    BuildContext context,
    AdminDokumentasiState state,
    AdminDokumentasiController notifier,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.shellSurfaceSoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.sogan.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleItem(
              label: 'KEGIATAN',
              isSelected: state.mode == DokumentasiMode.kegiatan,
              onTap: () => notifier.setMode(DokumentasiMode.kegiatan),
            ),
          ),
          Expanded(
            child: _ToggleItem(
              label: 'PEMBINAAN',
              isSelected: state.mode == DokumentasiMode.pembinaan,
              onTap: () => notifier.setMode(DokumentasiMode.pembinaan),
            ),
          ),
        ],
      ),
    );
  }

  bool _canAdd(DokumentasiMode mode, UserRole role) {
    final isPembinaan = mode == DokumentasiMode.pembinaan;
    return !isPembinaan || role == UserRole.admin;
  }

  Widget _buildAddButton(DokumentasiMode mode, UserRole role) {
    if (!_canAdd(mode, role)) {
      return const SizedBox.shrink();
    }

    final isPembinaan = mode == DokumentasiMode.pembinaan;
    return AppAddIconButton(
      onPressed: () => _showDokumentasiForm(context, ref, isPembinaan),
      tooltip: isPembinaan ? 'Tambah pembinaan' : 'Tambah kegiatan',
    );
  }

  void _showDokumentasiForm(
    BuildContext context,
    WidgetRef ref,
    bool isPembinaan,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DokumentasiForm(
        isPembinaan: isPembinaan,
        mode: DokumentasiFormMode.add,
      ),
    );
  }

  Widget _buildPaginationFooter(AdminDokumentasiState state, UserRole role) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          AppPaginationFooter(
            currentPage: state.currentPage,
            lastPage: state.lastPage,
            hasPreviousPage: state.hasPreviousPage,
            hasNextPage: state.hasNextPage,
            onPrevious: () => ref
                .read(adminDokumentasiControllerProvider.notifier)
                .previousPage(),
            onNext: () => ref
                .read(adminDokumentasiControllerProvider.notifier)
                .nextPage(),
          ),
          const Spacer(),
          _buildAddButton(state.mode, role),
        ],
      ),
    );
  }

  Widget _buildEmptyFooter(DokumentasiMode mode, UserRole role) {
    if (!_canAdd(mode, role)) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(children: [const Spacer(), _buildAddButton(mode, role)]),
    );
  }

  Widget _buildList(
    BuildContext context,
    AdminDokumentasiState state,
    bool isAdmin,
    UserRole role,
  ) {
    final items = state.currentItems;

    if (items.isEmpty) {
      return Column(
        children: [
          Expanded(
            child: _buildScrollableState(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: AppEmptyState(
                    icon: Icons.folder_open_rounded,
                    title: state.mode == DokumentasiMode.kegiatan
                        ? 'Belum ada kegiatan.'
                        : 'Belum ada pembinaan.',
                    message: _canAdd(state.mode, role)
                        ? 'Tekan tombol tambah untuk menambahkan dokumentasi baru.'
                        : 'Dokumentasi baru belum tersedia.',
                  ),
                ),
              ),
            ),
          ),
          _buildEmptyFooter(state.mode, role),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              if (state.mode == DokumentasiMode.kegiatan) {
                final kegiatan = item as dynamic;
                return DokumentasiListItem(
                  title: kegiatan.judulDokumentasi,
                  date: kegiatan.createdAt,
                  author: kegiatan.creatorName,
                  onTap: () {
                    final path = isAdmin
                        ? '${RouteConstants.adminDokumentasi}/kegiatan/${kegiatan.id}'
                        : '/dokumentasi-kegiatan/${kegiatan.id}';
                    context.push(path);
                  },
                );
              }

              final pembinaan = item as dynamic;
              return DokumentasiListItem(
                title: pembinaan.judulPembinaan,
                date: pembinaan.createdAt,
                author: pembinaan.creatorName,
                onTap: () {
                  final path = isAdmin
                      ? '${RouteConstants.adminDokumentasi}/pembinaan/${pembinaan.id}'
                      : '/dokumentasi-pembinaan/${pembinaan.id}';
                  context.push(path);
                },
              );
            },
          ),
        ),
        _buildPaginationFooter(state, role),
      ],
    );
  }
}

class _ToggleItem extends StatelessWidget {
  const _ToggleItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.sogan : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.sogan.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: textTheme.labelSmall?.copyWith(
            color: isSelected
                ? Colors.white
                : AppTheme.sogan.withValues(alpha: 0.6),
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}
