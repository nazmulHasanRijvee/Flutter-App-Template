part of '../colors.dart';

abstract class TextColors {
  const TextColors();

  Color get primary;
  Color get secondary;
  Color get tertiary;
}

class _LightTextColors extends TextColors {
  const _LightTextColors();

  @override
  Color get primary => _Primitive.textPrimaryLight;

  @override
  Color get secondary => _Primitive.textSecondaryLight;

  @override
  Color get tertiary => _Primitive.unselected;
}

class _DarkTextColors extends TextColors {
  const _DarkTextColors();

  @override
  Color get primary => _Primitive.textPrimaryDark;

  @override
  Color get secondary => _Primitive.textSecondaryDark;

  @override
  Color get tertiary => _Primitive.unselected;
}
