import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/constants/ai_constants.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final selectedThinking = user?.defaultThinkingLevel ?? 'low';

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Profile',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${user?.displayName ?? 'Unknown'}'),
                  const SizedBox(height: 8),
                  Text('Email: ${user?.email ?? 'Unknown'}'),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: selectedThinking,
                    items: AiConstants.allowedThinkingLevels
                        .map(
                          (level) => DropdownMenuItem(
                            value: level,
                            child: Text('Default thinking: $level'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      ref
                          .read(authControllerProvider.notifier)
                          .updateThinkingLevel(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed: () {
                      ref.read(authControllerProvider.notifier).signOut();
                    },
                    child: const Text('Sign out'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
