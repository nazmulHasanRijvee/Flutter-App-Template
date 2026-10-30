part of '../colors.dart';

abstract class BottomNavBarColors {
  const BottomNavBarColors();

  Color get selectedItem;
  Color get unselectedItem;
}

class _LightBottomNavBarColors extends BottomNavBarColors {
  const _LightBottomNavBarColors();

  @override
  Color get selectedItem => _Primitive.brandPrimary;

  @override
  Color get unselectedItem => _Primitive.unselected;
}

class _DarkBottomNavBarColors extends BottomNavBarColors {
  const _DarkBottomNavBarColors();

  @override
  Color get selectedItem => _Primitive.brandPrimary;

  @override
  Color get unselectedItem => _Primitive.unselected;
}
