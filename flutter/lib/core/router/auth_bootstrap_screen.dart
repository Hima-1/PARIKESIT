import 'package:flutter/material.dart';
import 'package:parikesit/core/widgets/app_loading_state.dart';

class AuthBootstrapScreen extends StatelessWidget {
  const AuthBootstrapScreen({super.key});

  static const Key loadingKey = Key('auth-bootstrap-loading');

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: KeyedSubtree(
          key: loadingKey,
          child: AppLoadingState(message: 'Memuat sesi...'),
        ),
      ),
    );
  }
}
