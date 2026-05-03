part of '../landing_public_screen.dart';

class _PublicAboutTab extends StatelessWidget {
  const _PublicAboutTab({
    required this.onOpenResults,
    required this.onOpenLogin,
  });

  final VoidCallback onOpenResults;
  final VoidCallback onOpenLogin;

  Widget _withStagger({required int index, required Widget child}) {
    return PublicStaggeredReveal(
      key: ValueKey<String>('public_about_stagger_$index'),
      delay: Duration(milliseconds: 80 + (index * 80)),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.pPage,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _withStagger(
                index: 0,
                child: PublicHeroPanel(
                  key: LandingPublicScreen.aboutHeroKey,
                  eyebrow: 'ABOUT PARIKESIT',
                  title:
                      'Portal Informasi Evaluasi Penyelenggaraan Statistik Sektoral.',
                  description:
                      'PARIKESIT merangkum Evaluasi Penyelenggaraan Statistik Sektoral agar pengunjung bisa langsung melihat alur, hasil, dan akses login.',
                  chips: const ['EPSS', 'Publik', 'Hasil Akhir'],
                  actionsAlignment: WrapAlignment.center,
                  primaryAction: FilledButton(
                    onPressed: onOpenResults,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.gold,
                      foregroundColor: AppTheme.sogan,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.borderRadius,
                        ),
                      ),
                    ),
                    child: const Text(
                      'LIHAT HASIL PUBLIK',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                  secondaryAction: OutlinedButton(
                    onPressed: onOpenLogin,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.merang,
                      backgroundColor: AppTheme.merang.withValues(alpha: 0.08),
                      side: BorderSide(
                        color: AppTheme.gold.withValues(alpha: 0.28),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.borderRadius,
                        ),
                      ),
                    ),
                    child: const Text(
                      'BUKA LOGIN',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
              AppSpacing.gapH16,
              _withStagger(
                index: 1,
                child: PublicSectionShell(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ringkasan cepat',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.sogan,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      AppSpacing.gapH8,
                      const _AboutPoint(
                        icon: Icons.fact_check_outlined,
                        title: 'Apa itu EPSS',
                        description:
                            'Evaluasi untuk menilai kematangan penyelenggaraan statistik sektoral.',
                      ),
                      AppSpacing.gapH12,
                      const _AboutPoint(
                        icon: Icons.track_changes_outlined,
                        title: 'Tujuan utama',
                        description:
                            'Mendorong kualitas data, tata kelola, dan layanan statistik publik.',
                      ),
                      AppSpacing.gapH12,
                      const _AboutPoint(
                        icon: Icons.bar_chart_outlined,
                        title: 'Output',
                        description:
                            'Hasil evaluasi ditampilkan sebagai indeks aspek, domain, dan IPS.',
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.gapH16,
              _withStagger(
                index: 2,
                child: PublicSectionShell(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Colors.white.withValues(alpha: 0.92),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aturan EPSS untuk publik',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.sogan,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      AppSpacing.gapH8,
                      const _AboutPoint(
                        icon: Icons.balance_rounded,
                        title: 'Dasar hukum',
                        description:
                            'Peraturan Badan Pusat Statistik Nomor 3 Tahun 2022 tentang Evaluasi Penyelenggaraan Statistik Sektoral.',
                      ),
                      AppSpacing.gapH12,
                      const _AboutPoint(
                        icon: Icons.track_changes_outlined,
                        title: 'Tujuan evaluasi',
                        description:
                            'Mengukur capaian penyelenggaraan statistik sektoral serta mendorong peningkatan kualitas layanan publik statistik.',
                      ),
                      AppSpacing.gapH12,
                      const _AboutPoint(
                        icon: Icons.apartment_rounded,
                        title: 'Cakupan penilaian',
                        description:
                            'Dilaksanakan pada instansi pusat dan pemerintahan daerah provinsi serta kabupaten/kota.',
                      ),
                      AppSpacing.gapH12,
                      const _AboutPoint(
                        icon: Icons.event_repeat_rounded,
                        title: 'Frekuensi pelaksanaan',
                        description:
                            'Evaluasi dilaksanakan setiap 2 tahun sekali atau sewaktu-waktu sesuai kebutuhan.',
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.gapH16,
              _withStagger(
                index: 3,
                child: PublicSectionShell(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tahapan evaluasi',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.sogan,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      AppSpacing.gapH8,
                      const _AboutPoint(
                        icon: Icons.looks_one_rounded,
                        title: 'Penilaian mandiri',
                        description:
                            'Tim internal mengisi indikator dan melampirkan bukti dukung.',
                      ),
                      AppSpacing.gapH12,
                      const _AboutPoint(
                        icon: Icons.looks_two_rounded,
                        title: 'Verifikasi dokumen',
                        description:
                            'Tim Badan memeriksa kesesuaian dokumen dan nilai yang diajukan.',
                      ),
                      AppSpacing.gapH12,
                      const _AboutPoint(
                        icon: Icons.looks_3_rounded,
                        title: 'Interviu atau visitasi',
                        description:
                            'Dilakukan jika perlu klarifikasi untuk memastikan validitas hasil.',
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.gapH16,
              _withStagger(
                index: 4,
                child: PublicSectionShell(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hasil evaluasi dan pemanfaatan',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.sogan,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      AppSpacing.gapH8,
                      const _AboutPoint(
                        icon: Icons.analytics_outlined,
                        title: 'Bentuk hasil',
                        description:
                            'Hasil evaluasi ditetapkan dalam indeks aspek, indeks domain, dan Indeks Pembangunan Statistik (IPS).',
                      ),
                      AppSpacing.gapH12,
                      const _AboutPoint(
                        icon: Icons.insights_outlined,
                        title: 'Pemanfaatan hasil',
                        description:
                            'Menjadi acuan perencanaan, monitoring, dan perbaikan berkelanjutan penyelenggaraan statistik sektoral.',
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.gapH24,
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutPoint extends StatelessWidget {
  const _AboutPoint({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: AppTheme.gold.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Icon(icon, size: 16, color: AppTheme.sogan),
        ),
        AppSpacing.gapW12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.sogan,
                  fontWeight: FontWeight.w900,
                ),
              ),
              AppSpacing.gapH4,
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.pusaka.withValues(alpha: 0.82),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PublicResultsTab extends ConsumerWidget {
  const _PublicResultsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<PaginatedResponse<AssessmentFormModel>> state = ref.watch(
      publicCompletedActivitiesProvider,
    );
    final notifier = ref.read(publicCompletedActivitiesProvider.notifier);

    return CompletedAssessmentListView(
      role: null,
      state: state,
      query: notifier.query,
      config: CompletedAssessmentListConfig.publicLanding,
      onSearchChanged: notifier.setSearch,
      onClearSearch: () => notifier.setSearch(''),
      onSortChanged: notifier.setSort,
      onToggleSortDirection: notifier.toggleSortDirection,
      onRefresh: notifier.refreshCompletedActivities,
      onPreviousPage: notifier.previousPage,
      onNextPage: notifier.nextPage,
      onActivityTap: (activity) {
        context.push(
          RouteConstants.publicAssessmentOpdSelection.replaceFirst(
            ':activityId',
            activity.id,
          ),
          extra: activity,
        );
      },
    );
  }
}
