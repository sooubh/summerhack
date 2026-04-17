import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../app/flavor_config.dart';
import '../../../conversations/presentation/screens/conversations_screen.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../live_ai/presentation/screens/live_ai_screen.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../uploads/presentation/screens/uploads_screen.dart';

class AppShellScreen extends ConsumerWidget {
  const AppShellScreen({super.key, required this.flavorConfig});

  final FlavorConfig flavorConfig;

  static const _tabItems = <({ShellTab tab, String label, IconData icon})>[
    (tab: ShellTab.home, label: 'Home', icon: Icons.home_outlined),
    (tab: ShellTab.conversations, label: 'Conversations', icon: Icons.forum_outlined),
    (tab: ShellTab.liveAi, label: 'Live AI', icon: Icons.graphic_eq_outlined),
    (tab: ShellTab.uploads, label: 'Uploads', icon: Icons.upload_file_outlined),
    (tab: ShellTab.notifications, label: 'Alerts', icon: Icons.notifications_none),
    (tab: ShellTab.profile, label: 'Profile', icon: Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);
    final index = _tabItems.indexWhere((element) => element.tab == selectedTab);
    final safeIndex = index < 0 ? 0 : index;
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    final content = switch (selectedTab) {
      ShellTab.home => HomeScreen(flavorConfig: flavorConfig),
      ShellTab.conversations => const ConversationsScreen(),
      ShellTab.liveAi => const LiveAiScreen(),
      ShellTab.uploads => const UploadsScreen(),
      ShellTab.notifications => const NotificationsScreen(),
      ShellTab.profile => const ProfileScreen(),
    };

    return Scaffold(
      body: isWide
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: safeIndex,
                  onDestinationSelected: (value) {
                    ref.read(selectedTabProvider.notifier).state = _tabItems[value].tab;
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: _tabItems
                      .map(
                        (item) => NavigationRailDestination(
                          icon: Icon(item.icon),
                          label: Text(item.label),
                        ),
                      )
                      .toList(),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: content),
              ],
            )
          : content,
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: safeIndex,
              onDestinationSelected: (value) {
                ref.read(selectedTabProvider.notifier).state = _tabItems[value].tab;
              },
              destinations: _tabItems
                  .map(
                    (item) => NavigationDestination(
                      icon: Icon(item.icon),
                      label: item.label,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
