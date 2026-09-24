import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/repositories/auth_repository_impl.dart';

/// Loads and persists the checkbox preference. Login passes this value to the
/// repository, which decides whether the token session survives a restart.
class RememberMeNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() {
    return ref.read(authRepositoryProvider).rememberMe();
  }

  Future<void> setRememberMe(bool value) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).rememberMe(rememberMe: value),
    );
  }
}

final rememberMeProvider = AsyncNotifierProvider<RememberMeNotifier, bool>(
  RememberMeNotifier.new,
);

/// Minimal login action state for the sign-in screen.
class LoginNotifier extends AsyncNotifier<bool?> {
  @override
  Future<bool?> build() async => null;

  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final shouldRemember = await ref.read(rememberMeProvider.future);
      return ref
          .read(authRepositoryProvider)
          .login(
            username: username,
            password: password,
            shouldRemember: shouldRemember,
          );
    });
  }
}

final loginProvider = AsyncNotifierProvider<LoginNotifier, bool?>(
  LoginNotifier.new,
);
