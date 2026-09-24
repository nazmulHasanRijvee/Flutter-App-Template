import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/repositories/locale_repository_impl.dart';

class LocalizationNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    return const Locale('en');
  }

  Future<void> changeLocale(Locale locale) async {
    final repo = ref.read(localeRepositoryProvider);
    await repo.setLanguage(locale.languageCode);
    state = locale;
  }

  Future<void> setCurrentLocale() async {
    final repo = ref.read(localeRepositoryProvider);
    final language = await repo.getLanguage();
    state = Locale(language);
  }
}

final localizationProvider = NotifierProvider<LocalizationNotifier, Locale>(
  LocalizationNotifier.new,
);
