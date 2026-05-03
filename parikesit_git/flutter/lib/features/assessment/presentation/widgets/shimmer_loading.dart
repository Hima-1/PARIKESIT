import 'package:flutter/material.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';

class AssessmentSkeleton extends StatelessWidget {
  const AssessmentSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.sogan.withValues(alpha: 0.1),
      highlightColor: AppTheme.merang,
      child: ListView.separated(
        padding: AppSpacing.pAll16,
        itemCount: 5,
        separatorBuilder: (context, index) => AppSpacing.gapH12,
        itemBuilder: (context, index) => Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white),
          ),
          child: Padding(
            padding: AppSpacing.pAll16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    AppSpacing.gapW12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 150,
                            height: 16,
                            color: Colors.white,
                          ),
                          AppSpacing.gapH8,
                          Container(
                            width: 100,
                            height: 12,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(width: 80, height: 12, color: Colors.white),
                    const Spacer(),
                    Container(
                      width: 100,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailSkeleton extends StatelessWidget {
  const DetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.sogan.withValues(alpha: 0.1),
      highlightColor: AppTheme.merang,
      child: Column(
        children: [
          Container(height: 100, width: double.infinity, color: Colors.white),
          Expanded(
            child: ListView.separated(
              padding: AppSpacing.pAll16,
              itemCount: 4,
              separatorBuilder: (context, index) => AppSpacing.gapH12,
              itemBuilder: (context, index) => Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
