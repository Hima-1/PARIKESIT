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
      delay: Duration(milliseconds: 80 + (index * 70)),
      child: child,
    );
  }

  Widget _sectionTitle(BuildContext context, String text) => Text(
    text,
    style: Theme.of(context).textTheme.titleLarge?.copyWith(
      color: AppTheme.textStrong,
      fontWeight: FontWeight.w700,
    ),
  );

  Widget _sectionSubtitle(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSubtle),
    ),
  );

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
                  actionsAlignment: WrapAlignment.start,
                  primaryAction: FilledButton.icon(
                    onPressed: onOpenResults,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.soganDeep,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                    ),
                    icon: const Icon(LucideIcons.arrowRight, size: 16),
                    label: const Text('Lihat hasil publik'),
                  ),
                  secondaryAction: OutlinedButton.icon(
                    onPressed: onOpenLogin,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white.withValues(alpha: 0.06),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.32),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                    ),
                    icon: const Icon(LucideIcons.logIn, size: 16),
                    label: const Text('Buka login'),
                  ),
                ),
              ),
              AppSpacing.gapH24,
              _withStagger(
                index: 1,
                child: PublicSectionShell(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(context, 'Ringkasan cepat'),
                      _sectionSubtitle(
                        context,
                        'Inti dari PARIKESIT dalam tiga poin.',
                      ),
                      AppSpacing.gapH16,
                      const _AboutPoint(
                        icon: LucideIcons.fileCheck2,
                        title: 'Apa itu EPSS',
                        description:
                            'Evaluasi untuk menilai kematangan penyelenggaraan statistik sektoral.',
                      ),
                      const _AboutDivider(),
                      const _AboutPoint(
                        icon: LucideIcons.target,
                        title: 'Tujuan utama',
                        description:
                            'Mendorong kualitas data, tata kelola, dan layanan statistik publik.',
                      ),
                      const _AboutDivider(),
                      const _AboutPoint(
                        icon: LucideIcons.barChart3,
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
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(context, 'Aturan EPSS untuk publik'),
                      _sectionSubtitle(
                        context,
                        'Dasar regulasi, tujuan, dan cakupan evaluasi.',
                      ),
                      AppSpacing.gapH16,
                      const _AboutPoint(
                        icon: LucideIcons.scale,
                        title: 'Dasar hukum',
                        description:
                            'Peraturan Badan Pusat Statistik Nomor 3 Tahun 2022 tentang Evaluasi Penyelenggaraan Statistik Sektoral.',
                      ),
                      const _AboutDivider(),
                      const _AboutPoint(
                        icon: LucideIcons.target,
                        title: 'Tujuan evaluasi',
                        description:
                            'Mengukur capaian penyelenggaraan statistik sektoral serta mendorong peningkatan kualitas layanan publik statistik.',
                      ),
                      const _AboutDivider(),
                      const _AboutPoint(
                        icon: LucideIcons.building2,
                        title: 'Cakupan penilaian',
                        description:
                            'Dilaksanakan pada instansi pusat dan pemerintahan daerah provinsi serta kabupaten/kota.',
                      ),
                      const _AboutDivider(),
                      const _AboutPoint(
                        icon: LucideIcons.calendarClock,
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
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(context, 'Tahapan evaluasi'),
                      _sectionSubtitle(
                        context,
                        'Tiga langkah utama dari pengisian sampai validasi.',
                      ),
                      AppSpacing.gapH16,
                      const _AboutPoint(
                        icon: LucideIcons.clipboardEdit,
                        index: '01',
                        title: 'Penilaian mandiri',
                        description:
                            'Tim internal mengisi indikator dan melampirkan bukti dukung.',
                      ),
                      const _AboutDivider(),
                      const _AboutPoint(
                        icon: LucideIcons.fileSearch,
                        index: '02',
                        title: 'Verifikasi dokumen',
                        description:
                            'Tim Badan memeriksa kesesuaian dokumen dan nilai yang diajukan.',
                      ),
                      const _AboutDivider(),
                      const _AboutPoint(
                        icon: LucideIcons.messagesSquare,
                        index: '03',
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
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(context, 'Hasil evaluasi dan pemanfaatan'),
                      _sectionSubtitle(
                        context,
                        'Bagaimana hasil dipublikasikan dan dimanfaatkan.',
                      ),
                      AppSpacing.gapH16,
                      const _AboutPoint(
                        icon: LucideIcons.lineChart,
                        title: 'Bentuk hasil',
                        description:
                            'Hasil evaluasi ditetapkan dalam indeks aspek, indeks domain, dan Indeks Pembangunan Statistik (IPS).',
                      ),
                      const _AboutDivider(),
                      const _AboutPoint(
                        icon: LucideIcons.lightbulb,
                        title: 'Pemanfaatan hasil',
                        description:
                            'Menjadi acuan perencanaan, monitoring, dan perbaikan berkelanjutan penyelenggaraan statistik sektoral.',
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.gapH32,
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutDivider extends StatelessWidget {
  const _AboutDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Divider(height: 1),
    );
  }
}

class _AboutPoint extends StatelessWidget {
  const _AboutPoint({
    required this.icon,
    required this.title,
    required this.description,
    this.index,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? index;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.cream,
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            border: AppTheme.hairlineBorder,
          ),
          child: Icon(icon, size: 18, color: AppTheme.terracotta),
        ),
        AppSpacing.gapW16,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: textTheme.titleSmall?.copyWith(
                        color: AppTheme.textStrong,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (index != null)
                    Text(
                      index!,
                      style: textTheme.labelSmall?.copyWith(
                        color: AppTheme.soganSoft,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                ],
              ),
              AppSpacing.gapH4,
              Text(description, style: textTheme.bodyMedium),
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
