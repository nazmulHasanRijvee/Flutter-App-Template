import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/gen/assets.gen.dart';
import '../widgets/bottom_nav_bar_item.dart';
import '../widgets/exit_confirm_dialog.dart';

class AppBottomNavBar extends StatefulWidget {
  const AppBottomNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.navigationShell.currentIndex;
  }

  Future<void> _onBackPressed() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) => const ExitConfirmDialog(),
    );

    if (shouldExit == true) {
      SystemNavigator.pop();
    }
  }

  void _onTabChanged(int index) {
    setState(() => _selectedIndex = index);

    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _selectedIndex;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Define colors dynamically for Dark and Light theme compatibility
    final barBgColor = isDark
        ? const Color(0xFF1B1B1B)
        : const Color(0xFFFDFCF9);
    final barBorderColor = isDark
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFF3EFE9);
    final itemBgColor = isDark
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFEFEBE4);
    final inactiveIconColor = isDark
        ? const Color(0xFF75757C)
        : const Color(0xFF9E9A93);
    final activeTextColors = isDark
        ? const Color(0xFFFFFFFF)
        : const Color(0xFF2E2D2B);
    final activeGreenCircleColor = isDark
        ? const Color(0xFF536150)
        : const Color(0xFF536150);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) await _onBackPressed();
      },
      child: Scaffold(
        extendBody: true,
        body: widget.navigationShell,
        bottomNavigationBar: SafeArea(
          child: Container(
            margin: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
            decoration: BoxDecoration(
              color: barBgColor,
              borderRadius: BorderRadius.circular(40.r),
              border: Border.all(color: barBorderColor, width: 8.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 16,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BottomNavBarItem(
                  index: 0,
                  asset: Assets.icons.devotion,
                  label: 'Devotion',
                  isSelected: currentIndex == 0,
                  itemBgColor: itemBgColor,
                  activeGreenCircleColor: activeGreenCircleColor,
                  inactiveIconColor: inactiveIconColor,
                  activeTextColors: activeTextColors,
                  onTap: () => _onTabChanged(0),
                ),
                BottomNavBarItem(
                  index: 1,
                  asset: Assets.icons.chat,
                  label: 'Ask',
                  isSelected: currentIndex == 1,
                  itemBgColor: itemBgColor,
                  activeGreenCircleColor: activeGreenCircleColor,
                  inactiveIconColor: inactiveIconColor,
                  activeTextColors: activeTextColors,
                  onTap: () => _onTabChanged(1),
                ),
                BottomNavBarItem(
                  index: 2,
                  asset: Assets.icons.group,
                  label: 'Community',
                  isSelected: currentIndex == 2,
                  itemBgColor: itemBgColor,
                  activeGreenCircleColor: activeGreenCircleColor,
                  inactiveIconColor: inactiveIconColor,
                  activeTextColors: activeTextColors,
                  onTap: () => _onTabChanged(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
