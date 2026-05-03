import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/core/auth/app_user.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/app_sort_dropdown_field.dart';
import 'package:parikesit/core/widgets/ethno_button.dart';
import 'package:parikesit/core/widgets/ethno_card.dart';

import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_pagination_footer.dart';
import '../data/admin_user_repository.dart';
import '../domain/admin_user_query.dart';
import 'controller/user_admin_controller.dart';
import 'user_detail_screen.dart';
import 'widgets/user_form_dialog.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userAdminControllerProvider);
    final notifier = ref.read(userAdminControllerProvider.notifier);
    final query = notifier.query;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Manajemen User'),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.pPage,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchField(),
              AppSpacing.gapH16,
              _buildSortControls(query),
              AppSpacing.gapH16,
              _buildAddButton(),
              AppSpacing.gapH16,
              Expanded(
                child: userState.when(
                  data: _buildContent,
                  loading: _buildLoadingState,
                  error: (error, stackTrace) => _buildErrorState(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    final textTheme = Theme.of(context).textTheme;
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _searchController,
      builder: (context, value, child) {
        return TextField(
          key: const Key('admin-user-search'),
          controller: _searchController,
          onChanged: _onSearchChanged,
          textInputAction: TextInputAction.search,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: 'Cari nama atau email user',
            hintStyle: textTheme.bodyMedium?.copyWith(
              color: AppTheme.sogan.withValues(alpha: 0.35),
            ),
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(
                    onPressed: _clearSearch,
                    icon: const Icon(Icons.close_rounded),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildAddButton() {
    return EthnoButton(
      key: const Key('admin-user-add'),
      onPressed: _showUserForm,
      icon: Icons.person_add_alt_1_rounded,
      label: 'TAMBAH USER BARU',
      isFullWidth: true,
    );
  }

  Widget _buildSortControls(AdminUserQuery query) {
    return Row(
      children: [
        Expanded(
          child: AppSortDropdownField<UserSortField>(
            fieldKey: const Key('admin-user-sort-field'),
            label: 'Urutkan',
            value: query.sort,
            items: UserSortField.values
                .map(
                  (value) => DropdownMenuItem<UserSortField>(
                    value: value,
                    child: Text(value.label),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                ref.read(userAdminControllerProvider.notifier).setSort(value);
              }
            },
          ),
        ),
        AppSpacing.gapW12,
        IconButton(
          key: const Key('admin-user-toggle-sort-direction'),
          onPressed: () {
            ref
                .read(userAdminControllerProvider.notifier)
                .toggleSortDirection();
          },
          tooltip: query.direction == SortDirection.asc
              ? 'Urutan naik'
              : 'Urutan turun',
          icon: Icon(
            query.direction == SortDirection.asc
                ? Icons.arrow_upward_rounded
                : Icons.arrow_downward_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(PaginatedResponse<AppUser> page) {
    final users = page.items;
    if (users.isEmpty) {
      final isSearching = _searchController.text.trim().isNotEmpty;
      return AppEmptyState(
        icon: isSearching
            ? Icons.search_off_rounded
            : Icons.people_alt_outlined,
        title: isSearching
            ? 'Tidak ada user yang cocok.'
            : 'Belum ada pengguna.',
        message: isSearching
            ? 'Coba ubah kata kunci pencarian untuk menemukan pengguna.'
            : 'Tambahkan akun baru untuk Admin, Walidata, atau OPD.',
      );
    }

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () =>
                ref.read(userAdminControllerProvider.notifier).refreshUsers(),
            color: AppTheme.sogan,
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: users.length,
              separatorBuilder: (_, _) => AppSpacing.gapH8,
              itemBuilder: (context, index) {
                final user = users[index];
                return _UserCard(
                  key: Key('admin-user-card-${user.id}'),
                  user: user,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => UserDetailScreen(user: user),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        AppPaginationFooter(
          currentPage: page.meta.currentPage,
          lastPage: page.meta.lastPage,
          hasPreviousPage: page.hasPreviousPage,
          hasNextPage: page.hasNextPage,
          onPrevious: () {
            ref.read(userAdminControllerProvider.notifier).previousPage();
          },
          onNext: () {
            ref.read(userAdminControllerProvider.notifier).nextPage();
          },
        ),
        AppSpacing.gapH8,
      ],
    );
  }

  Widget _buildLoadingState() {
    return ListView.separated(
      key: const Key('admin-user-loading'),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      separatorBuilder: (_, _) => AppSpacing.gapH12,
      itemBuilder: (context, index) =>
          _LoadingUserCard(key: Key('admin-user-loading-card-$index')),
    );
  }

  Widget _buildErrorState() {
    return AppEmptyState(
      icon: Icons.cloud_off_rounded,
      title: 'Gagal memuat data pengguna.',
      message: 'Periksa koneksi lalu coba lagi untuk mengambil daftar user.',
      actionIcon: Icons.refresh_rounded,
      actionLabel: 'Coba Lagi',
      onAction: () =>
          ref.read(userAdminControllerProvider.notifier).refreshUsers(),
    );
  }

  void _onSearchChanged(String value) {
    setState(() {});
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(userAdminControllerProvider.notifier).setSearch(value);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
  }

  void _showUserForm() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const UserFormDialog(useBottomSheetStyle: true),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({super.key, required this.user, required this.onTap});

  final AppUser user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final normalizedRole = _normalizeRoleLabel(user.role);
    final roleColor = _getRoleColor(user.role);
    final textTheme = Theme.of(context).textTheme;

    return EthnoCard(
      isFlat: true,
      onTap: onTap,
      padding: AppSpacing.pAll16,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _UserAvatar(name: user.name, roleColor: roleColor),
          AppSpacing.gapW16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        user.name,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppTheme.sogan,
                        ),
                      ),
                    ),
                    AppSpacing.gapW8,
                    _RoleBadge(role: normalizedRole, color: roleColor),
                  ],
                ),
                AppSpacing.gapH8,
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 14,
                      color: AppTheme.sogan.withValues(alpha: 0.4),
                    ),
                    AppSpacing.gapW8,
                    Expanded(
                      child: Text(
                        user.email,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppTheme.sogan.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                if (user.nomorTelepon != null &&
                    user.nomorTelepon!.trim().isNotEmpty) ...[
                  AppSpacing.gapH4,
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 14,
                        color: AppTheme.sogan.withValues(alpha: 0.4),
                      ),
                      AppSpacing.gapW8,
                      Expanded(
                        child: Text(
                          user.nomorTelepon!,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppTheme.sogan.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                AppSpacing.gapH12,
                Row(
                  children: [
                    Text(
                      'LIHAT PROFIL',
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppTheme.gold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    AppSpacing.gapW4,
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: AppTheme.gold,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingUserCard extends StatelessWidget {
  const _LoadingUserCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      decoration: BoxDecoration(
        color: AppTheme.shellSurface,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius * 1.5),
        border: Border.all(color: AppTheme.sogan.withValues(alpha: 0.08)),
      ),
      child: Padding(
        padding: AppSpacing.pAll16,
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppTheme.sogan.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
            AppSpacing.gapW12,
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LoadingBar(width: 120),
                  AppSpacing.gapH12,
                  _LoadingBar(width: 180, height: 12),
                  AppSpacing.gapH12,
                  _LoadingBar(width: 88, height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingBar extends StatelessWidget {
  const _LoadingBar({required this.width, this.height = 14});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.sogan.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.name, required this.roleColor});

  final String name;
  final Color roleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            roleColor.withValues(alpha: 0.15),
            roleColor.withValues(alpha: 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: roleColor.withValues(alpha: 0.1), width: 1),
      ),
      alignment: Alignment.center,
      child: Text(
        name.isEmpty ? '?' : name[0].toUpperCase(),
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w900,
          color: roleColor.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role, required this.color});

  final String role;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        role.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
          color: color,
          fontSize: EthnoTextTheme.of(context).labelTiny.fontSize,
        ),
      ),
    );
  }
}

Color _getRoleColor(String role) {
  switch (role) {
    case 'admin':
      return AppTheme.sogan;
    case 'walidata':
      return AppTheme.gold;
    case 'opd':
      return AppTheme.success;
    default:
      return AppTheme.warning;
  }
}

String _normalizeRoleLabel(String role) {
  switch (role) {
    case 'admin':
    case 'walidata':
    case 'opd':
      return role;
    default:
      return 'role tidak valid';
  }
}
