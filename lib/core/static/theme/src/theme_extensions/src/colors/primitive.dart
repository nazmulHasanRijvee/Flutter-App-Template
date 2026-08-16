part of 'colors.dart';

/// Primitive color palette
class _Primitive {
  static const Color brand = Color(0xFF536150);
  static const Color brandDeep = Color(0xFF0E7246);
  static const Color scaffoldColor = Color(0xFFF5F1E8);
  static const Color textFieldFillColor = Color(0xFFFDF8F8);
  static const Color textFieldBorderColor = Color(
    0xFFFDF8F8,
  ); // Old value => Color(0xFFEECACA)
  static const Color textFieldFocusBorderColor = Color(
    0xFFFDF8F8,
  ); // Color.fromARGB(255, 235, 171, 171,);

  // Neutral colors
  static const Color neutral0 = Color(0xFFFFFFFF);
  static const Color neutral10 = Color(0xFFFDF8F8);
  static const Color neutral20 = Color(0xFFF1F1F1);
  static const Color neutral30 = Color(0xFFD5DCE4);
  static const Color neutral40 = Color(0xFF75757C);
  static const Color neutral50 = Color(0xFF313137);
  static const Color neutral60 = Color(0xFF1B1B1B);
  static const Color neutral90 = Color(0xFF000000);

  // Semantic colors
  static const Color success = Color(0xFF008000);
  static const Color error = Color(0xFFFF0000);
  static const Color warning = Color(0xFFFFFF00);
  static const Color info = brand;

  // Accent colors
  static const Color accentBlue = Color(0xFF167EE6);
  static const Color accentPurple = Color(0xFF6334C1);
  static const Color accentYellow = Color(0xFF897303);
}
