import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization_provider/localization_provider.dart';

/// Runs once at app startup to initialize application-level state.
///
/// Currently loads the persisted locale so the app opens in the user's
/// last-selected language. Additional startup tasks (e.g. remote config
/// fetching) can be added here and awaited before the UI is shown.
final startupProvider = FutureProvider<void>((ref) async {
  await ref.read(localizationProvider.notifier).setCurrentLocale();
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
