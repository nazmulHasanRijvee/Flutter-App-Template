part of 'part_of.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final navigatorKey = ref.watch(navigatorKeyProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: RouteConst.splash,
    routes: <RouteBase>[
      GoRoute(
        path: RouteConst.splash,
        builder: (context, state) => const StartTodayScreen(),
      ),
      GoRoute(
        path: RouteConst.login,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: RouteConst.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteConst.forgotPassScreen,
        builder: (context, state) => const ForgotPassScreen(),
      ),
      GoRoute(
        path: RouteConst.verifyEmailScreen,
        builder: (context, state) => const VerifyEmailScreen(),
      ),
      GoRoute(
        path: RouteConst.createNewPassScreen,
        builder: (context, state) => const CreateNewPassScreen(),
      ),
      StatefulShellRoute.indexedStack(
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
      ),
    ],
  );
});

List<StatefulShellBranch> bottomBranches = [
  // Home (Devotion)
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: RouteConst.homeScreen,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  ),
  // Chat (Habit)
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: RouteConst.chatScreen,
        builder: (context, state) => AskScreen(),
      ),
    ],
  ),
  // Community (Study)
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: RouteConst.communityScreen,
        builder: (context, state) => const CommunityScreen(),
      ),
    ],
  ),
];
