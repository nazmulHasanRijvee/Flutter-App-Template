import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/services/cache/cache_service.dart';

/// Tracks whether the user has completed the onboarding flow.
/// Stored persistently in cache using [CacheKey.isOnBoardingCompleted].
///
/// go_router's [routerStateProvider] watches this provider to redirect to
/// onboarding screen if onboarding isn't completed yet
class OnboardingStatusNotifier extends Notifier<bool> {
  @override
  bool build() {
    final cacheService = ref.watch(cacheServiceProvider);
    return cacheService.get<bool>(CacheKey.isOnBoardingCompleted) ?? false;
  }

  Future<void> completeOnboarding() async {
    final cacheService = ref.read(cacheServiceProvider);
    await cacheService.save<bool>(CacheKey.isOnBoardingCompleted, true);
    state = true;
  }
}

final onboardingStatusProvider =
    NotifierProvider<OnboardingStatusNotifier, bool>(
      OnboardingStatusNotifier.new,
    );
