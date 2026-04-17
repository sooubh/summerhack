import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/constants/ai_constants.dart';

class LiveAiScreen extends ConsumerStatefulWidget {
  const LiveAiScreen({super.key});

  @override
  ConsumerState<LiveAiScreen> createState() => _LiveAiScreenState();
}

class _LiveAiScreenState extends ConsumerState<LiveAiScreen> {
  final _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final liveState = ref.watch(liveAiControllerProvider);

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 12,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Chip(label: Text(AiConstants.model)),
                DropdownButton<String>(
                  value: liveState.thinkingLevel,
                  items: AiConstants.allowedThinkingLevels
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text('Thinking: $item'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    ref.read(liveAiControllerProvider.notifier).setThinkingLevel(value);
                  },
                ),
                liveState.isSessionActive
                    ? OutlinedButton.icon(
                        onPressed: () {
                          ref.read(liveAiControllerProvider.notifier).endSession();
                        },
                        icon: const Icon(Icons.stop_circle_outlined),
                        label: const Text('End Session'),
                      )
                    : FilledButton.icon(
                        onPressed: () {
                          ref.read(liveAiControllerProvider.notifier).startSession();
                        },
                        icon: const Icon(Icons.play_circle_outline),
                        label: const Text('Start Session'),
                      ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final item = liveState.messages[index];
                final isUser = item.role == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: Card(
                      color: isUser
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surfaceContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(item.text),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemCount: liveState.messages.length,
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    enabled: liveState.isSessionActive,
                    decoration: InputDecoration(
                      hintText: liveState.isSessionActive
                          ? 'Type a message to stream to Gemini Live...'
                          : 'Start a session first',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: liveState.isSessionActive
                      ? () async {
                          final text = _inputController.text;
                          _inputController.clear();
                          await ref
                              .read(liveAiControllerProvider.notifier)
                              .sendTextMessage(text);
                        }
                      : null,
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
