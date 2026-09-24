import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/auth_repository_impl.dart';

/// Handles logout through the authentication repository. The repository
/// invalidates session state after the token session is cleared, causing
/// go_router to redirect to the unauthenticated routes.
class LogoutNotifier extends AsyncNotifier<bool?> {
  @override
  Future<bool?> build() async => null;

  Future<void> call() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return ref.read(authRepositoryProvider).logout();
    });
  }
}

final logoutProvider = AsyncNotifierProvider<LogoutNotifier, bool?>(
  LogoutNotifier.new,
);

/// The UI triggers logout by calling [LogoutNotifier.call] via
/// `ref.read(logoutProvider.notifier).call()`, which clears the session.
///
/// go_router then reactively detects the [sessionStatusProvider] state change
/// and automatically redirects to the login screen. Thats why its known  as a
/// reactive state-driven routing
///
/// [logoutProivder] is resposible for logging out logic only
/// while go_router is responsible for only routing/navigation when logged out
