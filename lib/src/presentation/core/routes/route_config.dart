part of 'part_of.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final navigatorKey = ref.watch(navigatorKeyProvider);
  final refresh = ref.asListenable(routerStateProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    refreshListenable: refresh,
    initialLocation: Routes.splash.path,
    redirect: (context, state) =>
        RedirectGate.redirect(state.uri.path, ref.read(routerStateProvider)),
    errorBuilder: (context, state) => NotFoundScreen(uri: state.uri),
    routes: <RouteBase>[
      ..._onboardingRoutes(ref),
      ..._authenticationRoutes(ref),
      _shellRoutes(ref),
    ],
  );
});
