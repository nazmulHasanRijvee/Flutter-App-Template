import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/router_repository_impl.dart';

enum SessionStatus { authenticated, unauthenticated }

/// Whether an active user session exists, reactively derived from [RouterRepository].
/// go_router's [routerStateProvider] watches this provider to redirect between
/// authenticated and unauthenticated screens.
final sessionStatusProvider = StreamProvider<SessionStatus>((ref) async* {
  final repository = ref.watch(routerRepoProvider);

  // 1. Yield initial session state once stored session is evaluated
  final hasInitialSession = await repository.hasSession();

  yield hasInitialSession
      ? SessionStatus.authenticated
      : SessionStatus.unauthenticated;

  // 2. React continuously to all session stream events from the repository
  await for (final hasSession in repository.sessionStream) {
    yield hasSession
        ? SessionStatus.authenticated
        : SessionStatus.unauthenticated;
  }
});
