import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/utils/input_sanitizer.dart';
import 'package:parikesit/core/utils/startup_probe.dart';
import 'package:parikesit/core/widgets/app_text_field.dart';
import 'package:parikesit/core/widgets/ethno_button.dart';
import 'package:parikesit/core/widgets/ethno_card.dart';
import 'package:parikesit/core/widgets/status_banner.dart';
import 'package:parikesit/features/auth/presentation/controller/auth_provider.dart';

class ParikesitLoginContent extends ConsumerStatefulWidget {
  const ParikesitLoginContent({
    super.key,
    this.useSafeArea = true,
    this.showVersion = true,
    this.maxWidth = 480,
    this.padding = AppSpacing.pPage,
    this.centerVertically = true,
  });

  static const emailFieldKey = Key('login_email');
  static const passwordFieldKey = Key('login_password');
  static const loginButtonKey = Key('login_submit');
  static const mascotImageKey = Key('login_mascot');
  static const contentKey = Key('login_content');

  final bool useSafeArea;
  final bool showVersion;
  final double maxWidth;
  final EdgeInsetsGeometry padding;
  final bool centerVertically;

  @override
  ConsumerState<ParikesitLoginContent> createState() =>
      _ParikesitLoginContentState();
}

class _ParikesitLoginContentState extends ConsumerState<ParikesitLoginContent> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _didScheduleFirstFrameMark = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final String email = InputSanitizer.normalizeEmail(_emailController.text);
    final String password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      ref.read(authNotifierProvider.notifier).login(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthState authState = ref.watch(authNotifierProvider);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
    final bool shouldCenterContent =
        widget.centerVertically && !keyboardVisible;

    StartupProbe.mark('ParikesitLoginContent.build', <String, Object?>{
      'auth_status': authState.status.name,
    });
    if (!_didScheduleFirstFrameMark) {
      _didScheduleFirstFrameMark = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        StartupProbe.markLoginFirstFrame();
      });
    }

    final Widget body = LayoutBuilder(
      builder: (context, constraints) {
        final double minHeight =
            shouldCenterContent && constraints.hasBoundedHeight
            ? math.max(0.0, constraints.maxHeight - 32.0)
            : 0.0;

        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: widget.padding,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: minHeight),
              child: Align(
                alignment: shouldCenterContent
                    ? Alignment.center
                    : Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: widget.maxWidth),
                  child: Column(
                    key: ParikesitLoginContent.contentKey,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const RepaintBoundary(child: _LoginBranding()),
                      AppSpacing.gapH24,
                      RepaintBoundary(
                        child: EthnoCard(
                          showBatikAccent:
                              !StartupProbeConfig.disableLoginCustomPaint,
                          padding: AppSpacing.pAll24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (authState.status ==
                                      AuthStatus.unauthenticated &&
                                  authState.errorMessage != null) ...[
                                StatusBanner(
                                  message: authState.errorMessage!,
                                  type: StatusBannerType.error,
                                ),
                                AppSpacing.gapH16,
                              ],
                              AppTextField(
                                key: ParikesitLoginContent.emailFieldKey,
                                controller: _emailController,
                                label: 'Email',
                                prefixIcon: const Icon(LucideIcons.mail),
                                keyboardType: TextInputType.emailAddress,
                                textCapitalization: TextCapitalization.none,
                              ),
                              AppSpacing.gapH16,
                              AppTextField(
                                key: ParikesitLoginContent.passwordFieldKey,
                                controller: _passwordController,
                                label: 'Password',
                                prefixIcon: const Icon(LucideIcons.lock),
                                obscureText: true,
                                onSubmitted: (_) => _login(),
                              ),
                              AppSpacing.gapH24,
                              EthnoButton(
                                key: ParikesitLoginContent.loginButtonKey,
                                onPressed: _login,
                                label: 'MASUK APLIKASI',
                                isLoading:
                                    authState.status == AuthStatus.loading,
                                isFullWidth: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (widget.showVersion) ...[
                        AppSpacing.gapH16,
                        Text(
                          'v1.0.0-stable',
                          textAlign: TextAlign.center,
                          style: textTheme.labelSmall?.copyWith(
                            color: AppTheme.sogan.withValues(alpha: 0.4),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (!widget.useSafeArea) {
      return body;
    }

    return SafeArea(child: body);
  }
}

class _LoginBranding extends StatelessWidget {
  const _LoginBranding();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Container(
          width: 180,
          height: 180,
          padding: const EdgeInsets.all(12),
          decoration: AppTheme.brandingContainerDecoration,
          child: Image.asset(
            'assets/images/maskot.png',
            key: ParikesitLoginContent.mascotImageKey,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
        AppSpacing.gapH24,
        Text(
          'PARIKESIT',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: AppTheme.sogan,
          ),
        ),
        AppSpacing.gapH4,
        Text(
          'Pemantauan Kematangan Statistik\nTerintegrasi dan Handal',
          textAlign: TextAlign.center,
          style: textTheme.labelSmall?.copyWith(
            color: AppTheme.sogan.withValues(alpha: 0.55),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
