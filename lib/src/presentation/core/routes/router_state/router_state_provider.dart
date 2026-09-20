import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application_state/onboarding_status_provider/onboarding_status_provider.dart';
import '../../application_state/session_status_provider/session_status_provider.dart';
import '../../application_state/startup_provider/startup_provider.dart';
import '../routes.dart';

/// The gate destination the go_router enforces, based on app startup,
/// onboarding, and session status.
///
/// The router reacts to this alone and it never reads startup or session
/// directly, and never sees a token.
/// - Splash while startup is pending or failed;
/// - onboarding until completed;
/// - then homeScreen or login by session.
/// 
/// New inputs (a force-update flag, a maintenance mode) compose here
/// without touching the router.
///
/// A pure derivation on purpose: no timers, no side effects, no
/// imperative transitions. The pages that change the underlying state
/// (login, logout, onboarding completion) invalidate the providers this
/// one watches, and the gate follows.
final routerStateProvider = Provider<Routes>((ref) {
  final startup = ref.watch(startupProvider);
  if (startup.isLoading || startup.hasError) return Routes.splash;

  if (!ref.watch(onboardingStatusProvider)) return Routes.onboarding;

  return switch (ref.watch(sessionStatusProvider)) {
    SessionStatus.authenticated => Routes.homeScreen,
    SessionStatus.unauthenticated => Routes.login,
  };
});


/// [routerStateProvider] is a pure derived state, it watches app-level
/// providers ([startupProvider], [onboardingStatusProvider], [sessionStatusProvider])
/// and whenever any of them change, go_router automatically picks up the new
/// [Routes] value and redirects accordingly. This is the essence of
/// reactive state-driven routing: no imperative navigation calls, just
/// state changes that the router observes and responds to.
