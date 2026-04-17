import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../shared/models/conversation.dart';

class ConversationsScreen extends ConsumerWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversations = ref.watch(conversationsProvider);
    final selectedConversationId = ref.watch(selectedConversationIdProvider);
    final isWide = MediaQuery.sizeOf(context).width >= 1100;

    final activeConversation = conversations.where((item) {
      return item.id == selectedConversationId;
    }).firstOrNull;

    final fallbackConversation = conversations.isNotEmpty ? conversations.first : null;
    final resolvedConversation = activeConversation ?? fallbackConversation;

    return SafeArea(
      child: isWide
          ? Row(
              children: [
                SizedBox(
                  width: 360,
                  child: _ConversationList(
                    conversations: conversations,
                    selectedConversationId: resolvedConversation?.id,
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: resolvedConversation == null
                      ? const Center(child: Text('No conversations yet'))
                      : _ConversationTimeline(conversationId: resolvedConversation.id),
                ),
              ],
            )
          : _ConversationList(
              conversations: conversations,
              selectedConversationId: resolvedConversation?.id,
            ),
    );
  }
}

class _ConversationList extends StatelessWidget {
  const _ConversationList({
    required this.conversations,
    required this.selectedConversationId,
  });

  final List<Conversation> conversations;
  final String? selectedConversationId;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return _ConversationListTile(
          conversation: conversation,
          isSelected: selectedConversationId == conversation.id,
        );
      },
    );
  }
}

class _ConversationListTile extends ConsumerWidget {
  const _ConversationListTile({required this.conversation, required this.isSelected});

  final Conversation conversation;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      child: ListTile(
        onTap: () {
          ref.read(selectedConversationIdProvider.notifier).state = conversation.id;
        },
        title: Text(conversation.title),
        subtitle: Text(conversation.lastMessagePreview),
        trailing: Text(_friendlyTime(conversation.updatedAt)),
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

class _ConversationTimeline extends ConsumerWidget {
  const _ConversationTimeline({required this.conversationId});

  final String conversationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(conversationMessagesProvider(conversationId));

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemBuilder: (context, index) {
        final message = messages[index];
        final isUser = message.role == 'user';
        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              color: isUser
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(message.text),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: messages.length,
    );
  }
}
