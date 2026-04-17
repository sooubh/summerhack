import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../shared/models/notification_item.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationItemsProvider);
    final unreadCount = ref.watch(unreadNotificationsCountProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Notifications',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Unread: $unreadCount • Total: ${notifications.length}'),
            ),
          ),
          const SizedBox(height: 12),
          ...notifications.map((item) => _NotificationCard(item: item)),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item});

  final AppNotification item;

  @override
  Widget build(BuildContext context) {
    final cardColor = item.isRead
        ? Theme.of(context).colorScheme.surfaceContainerLow
        : Theme.of(context).colorScheme.primaryContainer;

    return Card(
      color: cardColor,
      child: ListTile(
        leading: Icon(item.isRead ? Icons.mark_email_read_outlined : Icons.mark_email_unread),
        title: Text(item.title),
        subtitle: Text(item.body),
        trailing: Text(_friendlyTime(item.createdAt)),
      ),
    );
  }

  String _friendlyTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
