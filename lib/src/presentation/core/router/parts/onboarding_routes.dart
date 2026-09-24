part of "../router.dart";

List<GoRoute> _onboardingRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.splash.path,
      name: Routes.splash.name,
      pageBuilder: (context, state) => NoTransitionPage(child: SplashScreen()),
    ),
    GoRoute(
      path: Routes.onboarding.path,
      name: Routes.onboarding.name,
      pageBuilder: (context, state) => MaterialPage(child: StartTodayScreen()),
    ),
  ];
}
