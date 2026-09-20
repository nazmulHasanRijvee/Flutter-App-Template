import '../../domain/repositories/auth_repository.dart';
import '../services/auth/auth_service.dart';
import '../services/network/rest_client.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl({
    required this.remote,
    required this.authService,
  });

  final RestClient remote;
  final AuthService authService;

  @override
  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final response = await remote.register(data);
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    final response = await remote.login(data);
    return response.data as Map<String, dynamic>;
  }

  /// Manages the "Remember Me" functionality.
  ///
  /// When [rememberMe] is null, retrieves the current setting from cache.
  /// When [rememberMe] has a value, updates the setting in cache.
  /// Returns the current or newly saved value, defaulting to false on errors.
  @override
  Future<bool> rememberMe({bool? rememberMe}) async {
    try {
      if (rememberMe == null) {
        return authService.rememberMe ?? false;
      }

      await authService.setRememberMe(rememberMe);

      return rememberMe;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> forgotPassword(Map<String, dynamic> data) {
    // implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<String> resetPassword(Map<String, dynamic> data) {
    // implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<String> verifyOTP(Map<String, dynamic> data) {
    // implement verifyOTP
    throw UnimplementedError();
  }

  @override
  Future<String> resendOTP(Map<String, dynamic> data) {
    // implement resendOTP
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    await authService.clearSession();
  }
}
