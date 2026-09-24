import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/router_repository_impl.dart';

/// Tracks whether the user has completed the onboarding flow.
/// Stored persistently in cache using [CacheKey.isOnBoardingCompleted].
///
/// go_router's [routerStateProvider] watches this provider to redirect to
/// onboarding screen if onboarding isn't completed yet
class OnboardingStatusNotifier extends Notifier<bool> {
  @override
  bool build() {
    final routerRepository = ref.watch(routerRepoProvider);
    return routerRepository.isOnboardingCompleted();
  }

  Future<void> completeOnboarding() async {
    final routerRepository = ref.read(routerRepoProvider);
    await routerRepository.saveOnboardingAsCompleted();
    state = true;
  }
}

final onboardingStatusProvider =
    NotifierProvider<OnboardingStatusNotifier, bool>(
      OnboardingStatusNotifier.new,
    );
