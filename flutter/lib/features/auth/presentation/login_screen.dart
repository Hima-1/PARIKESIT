import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/utils/startup_probe.dart';
import 'package:parikesit/features/auth/presentation/widgets/parikesit_login_content.dart';

import '../../../core/router/route_constants.dart';
import '../../../core/widgets/ethno_patterns.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const emailFieldKey = ParikesitLoginContent.emailFieldKey;
  static const passwordFieldKey = ParikesitLoginContent.passwordFieldKey;
  static const loginButtonKey = ParikesitLoginContent.loginButtonKey;
  static const mascotImageKey = ParikesitLoginContent.mascotImageKey;
  static const contentKey = ParikesitLoginContent.contentKey;
  static const backToPublicButtonKey = Key('login_back_to_public');

  @override
  Widget build(BuildContext context) {
    const bool disableCustomPaint = StartupProbeConfig.disableLoginCustomPaint;
    const Widget content = ParikesitLoginContent();
    const Widget background = disableCustomPaint
        ? content
        : KawungBackground(opacity: 0.03, child: content);

    return Scaffold(
      body: Stack(
        children: [
          background,
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton.filledTonal(
                  key: backToPublicButtonKey,
                  tooltip: 'Kembali ke publik',
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.surface,
                    foregroundColor: AppTheme.textStrong,
                    side: const BorderSide(color: AppTheme.borderColor),
                  ),
                  onPressed: () => context.go(RouteConstants.landing),
                  icon: const Icon(LucideIcons.arrowLeft),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
