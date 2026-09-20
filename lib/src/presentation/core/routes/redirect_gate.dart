import 'routes.dart';

/// Defines the app's redirect/gating policy for go_router.
/// Has no dependency on `Ref` or `BuildContext`, making the entire
/// policy independently unit-testable.
abstract final class RedirectGate {
  /// Determines whether the user should be redirected away from [path]
  /// based on the current [gate] (the destination enforced by [routerStateProvider]).
  ///
  /// Returns the redirect path if a redirect is needed, or `null` to allow
  /// the current navigation to proceed.
  ///
  /// **Gate behaviors:**
  /// - [Routes.splash] — hard gate; user is pinned to splash until startup completes.
  /// - [Routes.onboarding] — hard gate; user is pinned until onboarding is finished.
  /// - [Routes.login] — allows the entire unauthenticated auth flow (login, register, reset password).
  /// - [Routes.homeScreen] — only redirects gate-only paths (e.g. splash, login);
  ///   regular in-app navigation is left unaffected.
  ///
  /// Idempotent: never redirects to the path already being visited,
  /// which prevents infinite redirect loops.
  static String? redirect(String path, Routes gate) {
    return switch (gate) {
      Routes.splash => path == Routes.splash.path ? null : Routes.splash.path,
      Routes.onboarding =>
        path == Routes.onboarding.path ? null : Routes.onboarding.path,
      Routes.login => _isAuthFlowPath(path) ? null : Routes.login.path,
      _ => _isGateOnlyPath(path) ? Routes.homeScreen.path : null,
    };
  }

  /// Returns `true` if [path] belongs to the unauthenticated auth flow
  /// (login, register, or any step in the reset-password chain).
  /// These paths are allowed through when the login gate is active.
  static bool _isAuthFlowPath(String path) =>
      path == Routes.login.path ||
      path == Routes.register.path ||
      path == Routes.resetPassScreen.path ||
      path == Routes.emailVerificationScreen.path ||
      path == Routes.createNewPassScreen.path;

  /// Returns `true` if [path] is a gate-only route like a route that
  /// should not be accessible once the user is authenticated.
  /// Includes splash, onboarding, all auth-flow paths, and the root `/`.
  /// An authenticated user landing on any of these is redirected to [Routes.homeScreen].
  static bool _isGateOnlyPath(String path) =>
      _isAuthFlowPath(path) ||
      path == Routes.splash.path ||
      path == Routes.onboarding.path ||
      path == '/';
}
