import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/locale_repository.dart';
import '../services/cache/cache_service.dart';

class LocaleRepositoryImpl implements LocaleRepository {
  LocaleRepositoryImpl(this.local);

  final CacheService local;

  @override
  Future<void> setLanguage(String language) async {
    await local.save(CacheKey.language, language);
  }

  @override
  Future<String> getLanguage() async {
    return local.get<String>(CacheKey.language) ?? 'en';
  }
}

final localeRepositoryProvider = Provider<LocaleRepository>((ref) {
  final cache = ref.watch(cacheServiceProvider);
  return LocaleRepositoryImpl(cache);
});
