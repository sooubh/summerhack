import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/ai_constants.dart';
import '../../shared/models/app_user.dart';
import '../../shared/models/conversation.dart';
import '../../shared/models/notification_item.dart';
import '../../shared/models/upload_item.dart';

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
final selectedConversationIdProvider = StateProvider<String?>((_) => 'conv_1');

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
  final baseMessages = <ConversationMessage>[
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

  if (conversationId == 'conv_2') {
    return <ConversationMessage>[
      ...baseMessages,
      ConversationMessage(
        id: '${conversationId}_m3',
        role: 'assistant',
        text: 'Model locked to ${AiConstants.model}.',
        createdAt: now.subtract(const Duration(minutes: 9)),
      ),
    ];
  }

  if (conversationId == 'conv_3') {
    return <ConversationMessage>[
      ...baseMessages,
      ConversationMessage(
        id: '${conversationId}_m3',
        role: 'user',
        text: 'Please attach the latest wireframes and notes.',
        createdAt: now.subtract(const Duration(minutes: 7)),
      ),
    ];
  }

  return baseMessages;
});

final uploadItemsProvider = Provider<List<UploadItem>>((ref) {
  final now = DateTime.now();
  return <UploadItem>[
    UploadItem(
      id: 'up_1',
      fileName: 'homepage_wireframe.png',
      category: 'image',
      status: UploadStatus.ready,
      progress: 100,
      updatedAt: now.subtract(const Duration(minutes: 22)),
      sizeBytes: 920000,
    ),
    UploadItem(
      id: 'up_2',
      fileName: 'requirements_v3.pdf',
      category: 'document',
      status: UploadStatus.uploading,
      progress: 62,
      updatedAt: now.subtract(const Duration(minutes: 2)),
      sizeBytes: 2400000,
    ),
    UploadItem(
      id: 'up_3',
      fileName: 'voice_note_intro.m4a',
      category: 'audio',
      status: UploadStatus.failed,
      progress: 34,
      updatedAt: now.subtract(const Duration(hours: 1)),
      sizeBytes: 1500000,
    ),
  ];
});

final notificationItemsProvider = Provider<List<AppNotification>>((ref) {
  final now = DateTime.now();
  return <AppNotification>[
    AppNotification(
      id: 'noti_1',
      title: 'Live session ready',
      body: 'Your latest Gemini Live session has been archived.',
      createdAt: now.subtract(const Duration(minutes: 5)),
      isRead: false,
      route: '/live',
    ),
    AppNotification(
      id: 'noti_2',
      title: 'Upload complete',
      body: 'requirements_v3.pdf is now available in conversation context.',
      createdAt: now.subtract(const Duration(minutes: 45)),
      isRead: true,
      route: '/uploads',
    ),
    AppNotification(
      id: 'noti_3',
      title: 'New message',
      body: 'Project Planning received a new assistant summary.',
      createdAt: now.subtract(const Duration(hours: 2)),
      isRead: false,
      route: '/conversations',
    ),
  ];
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationItemsProvider);
  return notifications.where((item) => !item.isRead).length;
});

class HomeKpis {
  const HomeKpis({
    required this.conversations,
    required this.liveMessages,
    required this.uploads,
    required this.unreadAlerts,
  });

  final int conversations;
  final int liveMessages;
  final int uploads;
  final int unreadAlerts;
}

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

final homeKpisProvider = Provider<HomeKpis>((ref) {
  final conversationCount = ref.watch(conversationsProvider).length;
  final uploadCount = ref.watch(uploadItemsProvider).length;
  final unreadAlerts = ref.watch(unreadNotificationsCountProvider);
  final liveMessages = ref.watch(liveAiControllerProvider).messages.length;

  return HomeKpis(
    conversations: conversationCount,
    liveMessages: liveMessages,
    uploads: uploadCount,
    unreadAlerts: unreadAlerts,
  );
});
