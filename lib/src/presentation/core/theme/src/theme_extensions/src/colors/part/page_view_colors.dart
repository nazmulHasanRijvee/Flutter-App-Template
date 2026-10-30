part of '../colors.dart';

abstract class PageViewColors {
  const PageViewColors();

  Color get active;
  Color get inactive;
}

class _LightPageViewColors extends PageViewColors {
  const _LightPageViewColors();

  @override
  Color get active => _Primitive.brandPrimary;

  @override
  Color get inactive => _Primitive.borderLight;
}

class _DarkPageViewColors extends PageViewColors {
  const _DarkPageViewColors();

  @override
  Color get active => _Primitive.brandPrimary;

  @override
  Color get inactive => _Primitive.borderDark;
}
