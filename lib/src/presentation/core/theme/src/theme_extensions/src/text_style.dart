import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyleExtension extends ThemeExtension<TextStyleExtension> {
  const TextStyleExtension();

  TextStyle get headLineLarge {
    return GoogleFonts.manrope(
      height: 1.40,
      fontSize: 24,
      letterSpacing: 0,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle get headLineMedium {
    return GoogleFonts.manrope(
      height: 1.40,
      fontSize: 20,
      letterSpacing: 0,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle get headLineSmall {
    return GoogleFonts.manrope(
      height: 1.33,
      fontSize: 18,
      letterSpacing: 0,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle get bodyLarge {
    return GoogleFonts.manrope(
      height: 1.50,
      fontSize: 16,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle get bodyMedium {
    return GoogleFonts.manrope(
      height: 1.42,
      fontSize: 14,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle get bodySmall {
    return GoogleFonts.manrope(
      height: 1.42,
      fontSize: 12,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle get labelLarge {
    return GoogleFonts.manrope(
      height: 1.15,
      fontSize: 16,
      letterSpacing: 1,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle get labelMedium {
    return GoogleFonts.manrope(
      height: 1.15,
      fontSize: 14,
      letterSpacing: 1,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle get labelSmall {
    return GoogleFonts.manrope(
      height: 1.15,
      fontSize: 12,
      letterSpacing: 1,
      fontWeight: FontWeight.w500,
    );
  }

  @override
  ThemeExtension<TextStyleExtension> copyWith() => const TextStyleExtension();

  @override
  ThemeExtension<TextStyleExtension> lerp(other, t) =>
      const TextStyleExtension();
}
