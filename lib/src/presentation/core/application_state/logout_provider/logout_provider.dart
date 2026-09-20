import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/services/auth/auth_service.dart';
import '../session_status_provider/session_status_provider.dart';

/// Handles the logout flow, clears the persisted session through [AuthService]
/// and invalidates or dispose [sessionStatusProvider] so the go_router's [routerStateProvider]
/// immediately redirects to the unauthenticated screens (login screen)
class LogoutNotifier extends AsyncNotifier<bool?> {
  @override
  Future<bool?> build() async => null;

  Future<void> call() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      await authService.clearSession();
      ref.invalidate(sessionStatusProvider);
      return true;
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
