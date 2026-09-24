part of '../router.dart';

StatefulShellRoute _shellRoutes(Ref ref) {
  return StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return Consumer(
        builder: (context, ref, _) {
          return AppBottomNavBar(
            key: const ValueKey('bottom-nav'),
            navigationShell: navigationShell,
          );
        },
      );
    },
    branches: bottomBranches,
  );
}

List<StatefulShellBranch> bottomBranches = [
  // Home (Devotion)
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: Routes.homeScreen.path,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  ),
  // Chat (Habit)
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: Routes.chatScreen.path,
        builder: (context, state) => AskScreen(),
      ),
    ],
  ),
  // Community (Study)
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: Routes.communityScreen.path,
        builder: (context, state) => const CommunityScreen(),
      ),
    ],
  ),
];
