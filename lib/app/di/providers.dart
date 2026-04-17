import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/ai_constants.dart';
import '../../shared/models/app_user.dart';
import '../../shared/models/conversation.dart';

enum ShellTab { home, conversations, liveAi, uploads, notifications, profile }

class AuthState {
  const AuthState({
    required this.isBootstrapped,
    this.user,
  });

  final bool isBootstrapped;
  final AppUser? user;

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    bool? isBootstrapped,
    AppUser? user,
    bool clearUser = false,
  }) {
    return AuthState(
      isBootstrapped: isBootstrapped ?? this.isBootstrapped,
      user: clearUser ? null : (user ?? this.user),
    );
  }
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState(isBootstrapped: false);

  Future<void> bootstrap() async {
    if (state.isBootstrapped) return;
    await Future<void>.delayed(const Duration(milliseconds: 700));
    state = state.copyWith(isBootstrapped: true, clearUser: true);
  }

  Future<void> signInWithEmail({
    required String email,
    required String displayName,
  }) async {
    state = state.copyWith(
      isBootstrapped: true,
      user: AppUser(
        uid: 'local-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        displayName: displayName,
        defaultThinkingLevel: 'low',
      ),
    );
  }

  Future<void> signOut() async {
    state = state.copyWith(clearUser: true);
  }

  Future<void> updateThinkingLevel(String thinkingLevel) async {
    final current = state.user;
    if (current == null) return;
    if (!AiConstants.allowedThinkingLevels.contains(thinkingLevel)) return;

    state = state.copyWith(
      user: AppUser(
        uid: current.uid,
        email: current.email,
        displayName: current.displayName,
        defaultThinkingLevel: thinkingLevel,
      ),
    );
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

final selectedTabProvider = StateProvider<ShellTab>((ref) => ShellTab.home);

final conversationsProvider = Provider<List<Conversation>>((ref) {
  final now = DateTime.now();
  return <Conversation>[
    Conversation(
      id: 'conv_1',
      title: 'Project Planning',
      lastMessagePreview: 'Let\'s define Phase 1 milestones.',
      updatedAt: now.subtract(const Duration(minutes: 8)),
    ),
    Conversation(
      id: 'conv_2',
      title: 'Gemini Live Session',
      lastMessagePreview: 'Thinking level set to medium.',
      updatedAt: now.subtract(const Duration(hours: 1)),
    ),
    Conversation(
      id: 'conv_3',
      title: 'Design Review',
      lastMessagePreview: 'Upload wireframes for web layout.',
      updatedAt: now.subtract(const Duration(hours: 5)),
    ),
  ];
});

final conversationMessagesProvider = Provider.family<List<ConversationMessage>, String>((
  ref,
  conversationId,
) {
  final now = DateTime.now();
  return <ConversationMessage>[
    ConversationMessage(
      id: '${conversationId}_m1',
      role: 'user',
      text: 'Can you summarize today\'s priorities?',
      createdAt: now.subtract(const Duration(minutes: 12)),
    ),
    ConversationMessage(
      id: '${conversationId}_m2',
      role: 'assistant',
      text: 'Ship auth shell, conversation list, and live AI text mode.',
      createdAt: now.subtract(const Duration(minutes: 11)),
    ),
  ];
});

class LiveAiState {
  const LiveAiState({
    required this.isSessionActive,
    required this.thinkingLevel,
    required this.messages,
  });

  final bool isSessionActive;
  final String thinkingLevel;
  final List<ConversationMessage> messages;

  LiveAiState copyWith({
    bool? isSessionActive,
    String? thinkingLevel,
    List<ConversationMessage>? messages,
  }) {
    return LiveAiState(
      isSessionActive: isSessionActive ?? this.isSessionActive,
      thinkingLevel: thinkingLevel ?? this.thinkingLevel,
      messages: messages ?? this.messages,
    );
  }
}

class LiveAiController extends Notifier<LiveAiState> {
  @override
  LiveAiState build() {
    final authState = ref.watch(authControllerProvider);
    return LiveAiState(
      isSessionActive: false,
      thinkingLevel: authState.user?.defaultThinkingLevel ?? 'low',
      messages: const <ConversationMessage>[],
    );
  }

  void setThinkingLevel(String level) {
    if (!AiConstants.allowedThinkingLevels.contains(level)) return;
    state = state.copyWith(thinkingLevel: level);
    ref.read(authControllerProvider.notifier).updateThinkingLevel(level);
  }

  void startSession() {
    state = state.copyWith(isSessionActive: true);
  }

  void endSession() {
    state = state.copyWith(isSessionActive: false);
  }

  Future<void> sendTextMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || !state.isSessionActive) return;

    final userMessage = ConversationMessage(
      id: 'u_${DateTime.now().microsecondsSinceEpoch}',
      role: 'user',
      text: trimmed,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(messages: <ConversationMessage>[...state.messages, userMessage]);

    await Future<void>.delayed(const Duration(milliseconds: 500));

    final assistantMessage = ConversationMessage(
      id: 'a_${DateTime.now().microsecondsSinceEpoch}',
      role: 'assistant',
      text:
          '[$AiConstants.model • ${state.thinkingLevel}] Response to: "$trimmed"',
      createdAt: DateTime.now(),
    );

    state = state.copyWith(messages: <ConversationMessage>[...state.messages, assistantMessage]);
  }
}

final liveAiControllerProvider = NotifierProvider<LiveAiController, LiveAiState>(
  LiveAiController.new,
);
