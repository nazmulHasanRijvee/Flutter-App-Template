import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/services/auth/auth_service.dart';

enum SessionStatus { authenticated, unauthenticated }

/// Whether an active user session exists, based on stored auth tokens.
/// go_router's [routeStateProvider] watches this provider to redirect between
/// authenticated and unauthenticated screens
final sessionStatusProvider = Provider<SessionStatus>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.isLoggedIn
      ? SessionStatus.authenticated
      : SessionStatus.unauthenticated;
});
