import 'package:flutter_app_template/core/logger/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

base class RiverpodObserver extends ProviderObserver {
  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    AppLogger.info('Provider ${context.provider} was initialized with $value');
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    AppLogger.warning('Provider ${context.provider} was disposed');
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    AppLogger.info(
      'Provider ${context.provider} updated from $previousValue to $newValue',
    );
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    AppLogger.error('Provider ${context.provider} threw $error at $stackTrace');
  }
}
