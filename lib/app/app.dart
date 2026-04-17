import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/screens/sign_in_screen.dart';
import '../features/shell/presentation/screens/app_shell_screen.dart';
import 'di/providers.dart';
import 'flavor_config.dart';

class SummerhackApp extends ConsumerWidget {
  const SummerhackApp({super.key, required this.flavorConfig});

  final FlavorConfig flavorConfig;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    if (!authState.isBootstrapped) {
      ref.read(authControllerProvider.notifier).bootstrap();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: flavorConfig.name,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
        useMaterial3: true,
      ),
      home: authState.isBootstrapped
          ? (authState.isAuthenticated
                ? AppShellScreen(flavorConfig: flavorConfig)
                : const SignInScreen())
          : const _SplashScreen(),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
