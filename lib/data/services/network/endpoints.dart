class Endpoints {
  static const base = String.fromEnvironment("BASE_URL");
  static const communityBase = String.fromEnvironment("COMMUNITY_URL");

  /// Authentication
  static const String register = '/auth/register/';
  static const String login = '/auth/login';
  static const String forgotPassword = '/auth/forgot_password/';
  static const String resetPassword = '/auth/reset_password/';
  static const String refreshToken = '/auth/refresh_token/';

  /// OTP
  static const String verifyOtp = '/otp/verify_otp/';
  static const String resendOtp = '/otp/resend_otp/';

  /// Community
  static const String community = '/community';

  static String pray(int id) => '/community/$id/pray';

  /// Quran
  static const quranBase = 'https://api.template.kodevio.com';
  static const String quranToday = '/quran/today';

  /// Chat
  static const String chat = '/chat';
}
