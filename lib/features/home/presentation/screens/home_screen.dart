import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../app/flavor_config.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, required this.flavorConfig});

  final FlavorConfig flavorConfig;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final kpis = ref.watch(homeKpisProvider);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Hi ${user?.displayName ?? 'there'}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Environment: ${flavorConfig.name}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _KpiCard(title: 'Conversations', value: '${kpis.conversations}'),
              _KpiCard(title: 'Live messages', value: '${kpis.liveMessages}'),
              _KpiCard(title: 'Uploads', value: '${kpis.uploads}'),
              _KpiCard(title: 'Unread alerts', value: '${kpis.unreadAlerts}'),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Feature status',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Text('• Auth + shell flow ready'),
                  Text('• Conversations + timeline mock ready'),
                  Text('• Live AI text session state ready'),
                  Text('• Upload and notifications mock states ready'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              const SizedBox(height: 10),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
