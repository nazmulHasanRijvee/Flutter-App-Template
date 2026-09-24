import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/auth_repository_impl.dart';
import '../localization_provider/localization_provider.dart';
import '../theme_mode_provider/theme_mode_provider.dart';

/// Runs once at app startup to initialize application-level state.
///
/// Restores the remember-me session policy and loads the persisted locale and
/// theme before the first route is selected.
final startupProvider = FutureProvider<void>((ref) async {
  await ref.read(authRepositoryProvider).restoreSession();
  await ref.read(localizationProvider.notifier).setCurrentLocale();
  await ref.read(themeModeProvider.notifier).setCurrentThemeMode();
});

/// [startupProvider] is eagerly initialized by go_router's redirect logic
/// (via [routerStateProvider]) before any UI is rendered, ensuring all
/// startup tasks complete before the first screen appears
///
/// This keeps [SplashScreen] focused solely on its splash UI, free from
/// any authentication or onboarding logic. All app-level initialization
/// logics are centralized here in [startupProvider], while routing decisions
/// (based on authentication, onboadring status) are handled  by go_router's
/// [routerStateProvider]
