abstract interface class AuthenticationRepository {
  Future<Map<String, dynamic>> register(Map<String, dynamic> data);

  Future<Map<String, dynamic>> login(Map<String, dynamic> data);

  Future<bool> rememberMe({bool? rememberMe});

  Future<String> forgotPassword(Map<String, dynamic> data);

  Future<String> resetPassword(Map<String, dynamic> data);

  Future<String> verifyOTP(Map<String, dynamic> data);

  Future<String> resendOTP(Map<String, dynamic> data);

  Future<void> logout();
}
