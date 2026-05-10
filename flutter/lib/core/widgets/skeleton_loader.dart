import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_spacing.dart';
import '../theme/tokens/colors.dart';
import '../theme/tokens/radii.dart';

/// Single shimmer wrapper used across the app. All skeleton widgets are
/// composed from [SkeletonLoader] blocks placed inside a Material card or
/// list to mimic the real layout while data loads.
class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppRadii.r8,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: AppColors.cream,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class ActivityCardSkeleton extends StatelessWidget {
  const ActivityCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: AppSpacing.pV8,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.rrMd,
        side: const BorderSide(color: AppColors.border),
      ),
      child: const Padding(
        padding: AppSpacing.pAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SkeletonLoader(width: 40, height: 40, borderRadius: 8),
                AppSpacing.gapW12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLoader(width: double.infinity, height: 16),
                      AppSpacing.gapH8,
                      SkeletonLoader(width: 100, height: 12),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.gapH16,
            Divider(height: 1),
            AppSpacing.gapH12,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLoader(width: 80, height: 14),
                SkeletonLoader(width: 100, height: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatsCardSkeleton extends StatelessWidget {
  const StatsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.pAll24,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.rrMd,
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLoader(width: 150, height: 20),
          AppSpacing.gapH24,
          Row(
            children: [
              SkeletonLoader(width: 60, height: 60, borderRadius: 30),
              AppSpacing.gapW24,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLoader(width: double.infinity, height: 12),
                    AppSpacing.gapH8,
                    SkeletonLoader(width: 80, height: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Skeleton list for assessment-style cards. Migrated from the deleted
/// `features/assessment/.../shimmer_loading.dart` so the whole app shares
/// one shimmer implementation.
class AssessmentListSkeleton extends StatelessWidget {
  const AssessmentListSkeleton({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: AppSpacing.pAll16,
      itemCount: itemCount,
      separatorBuilder: (_, _) => AppSpacing.gapH12,
      itemBuilder: (_, _) => const ActivityCardSkeleton(),
    );
  }
}

/// Header + list skeleton used while loading detail screens.
class DetailScreenSkeleton extends StatelessWidget {
  const DetailScreenSkeleton({super.key, this.rowCount = 4});

  final int rowCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: AppSpacing.pAll16,
          child: SkeletonLoader(width: double.infinity, height: 80),
        ),
        Expanded(
          child: ListView.separated(
            padding: AppSpacing.pAll16,
            itemCount: rowCount,
            separatorBuilder: (_, _) => AppSpacing.gapH12,
            itemBuilder: (_, _) =>
                const SkeletonLoader(width: double.infinity, height: 60),
          ),
        ),
      ],
    );
  }
}
