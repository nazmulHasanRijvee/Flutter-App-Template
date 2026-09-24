import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/router_repository_impl.dart';

enum SessionStatus { authenticated, unauthenticated }

/// Whether an active user session exists, based on stored auth tokens.
/// go_router's [routeStateProvider] watches this provider to redirect between
/// authenticated and unauthenticated screens
final sessionStatusProvider = FutureProvider<SessionStatus>((ref) async {
  final repository = ref.watch(routerRepoProvider);
  final hasSession = await repository.hasSession();
  return hasSession
      ? SessionStatus.authenticated
      : SessionStatus.unauthenticated;
});
