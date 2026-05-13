import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/app_state.dart';

/// Approved full-screen artwork before language selection or the rest of the gate.
class MiniSplashScreen extends StatefulWidget {
  const MiniSplashScreen({super.key});

  @override
  State<MiniSplashScreen> createState() => _MiniSplashScreenState();
}

class _MiniSplashScreenState extends State<MiniSplashScreen> {
  static const String _miniSplashAsset = 'assets/images/mini_splash.png';

  @override
  void initState() {
    super.initState();
    _scheduleNavigation();
  }

  Future<void> _scheduleNavigation() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    if (!mounted) return;
    final app = AppStateProvider.of(context);
    if (app.language == null) {
      context.go('/language');
      return;
    }
    if (!app.onboardingCompleted) {
      context.go('/splash');
      return;
    }
    context.go('/deals');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        _miniSplashAsset,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
