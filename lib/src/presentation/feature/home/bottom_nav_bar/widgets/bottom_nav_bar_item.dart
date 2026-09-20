import 'package:material_ui/material_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavBarItem extends StatefulWidget {
  final int index;
  final String asset;
  final String label;
  final bool isSelected;
  final Color itemBgColor;
  final Color activeGreenCircleColor;
  final Color inactiveIconColor;
  final Color activeTextColors;
  final VoidCallback onTap;

  const BottomNavBarItem({
    super.key,
    required this.index,
    required this.asset,
    required this.label,
    required this.isSelected,
    required this.itemBgColor,
    required this.activeGreenCircleColor,
    required this.inactiveIconColor,
    required this.activeTextColors,
    required this.onTap,
  });

  @override
  State<BottomNavBarItem> createState() => _BottomNavBarItemState();
}

class _BottomNavBarItemState extends State<BottomNavBarItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    // Sweet micro-animation bounce sequence for interactive feel
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -6.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 4.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 4.0, end: -2.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -2.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isSelected) {
      _controller.forward(from: 0);
    }
  }

  @override
  void didUpdateWidget(covariant BottomNavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      if (widget.isSelected) {
        _controller.forward(from: 0);
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getTextWidth(String label) {
    switch (label) {
      case 'Devotion':
        return 64.w;
      case 'Ask':
        return 32.w;
      case 'Community':
        return 72.w;
      default:
        return 50.w;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textWidth = _getTextWidth(widget.label);

    // Dynamically calculate the active width of the pill container
    final activeWidth = 5.h + 38.h + 8.w + textWidth + 16.w;
    final itemWidth = widget.isSelected ? activeWidth : 48.h;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
        width: itemWidth,
        height: 48.h,
        decoration: BoxDecoration(
          color: widget.itemBgColor,
          borderRadius: BorderRadius.circular(24.h),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Left spacer (fixed padding inside capsule, or centered when inactive)
              SizedBox(width: 5.h),

              // Icon Container (Green circle when active, animated bounce)
              AnimatedBuilder(
                animation: _bounceAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _bounceAnimation.value),
                    child: child,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 550),
                  curve: Curves.easeInOutCubic,
                  width: 38.h,
                  height: 38.h,
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? widget.activeGreenCircleColor
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      widget.asset,
                      height: 20.h,
                      colorFilter: ColorFilter.mode(
                        widget.isSelected
                            ? Colors.white
                            : widget.inactiveIconColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),

              // Gap between icon and text (animated reveal)
              AnimatedContainer(
                duration: const Duration(milliseconds: 550),
                curve: Curves.easeInOutCubic,
                width: widget.isSelected ? 8.w : 0.0,
              ),

              // Text label (animated width reveal + opacity)
              AnimatedContainer(
                duration: const Duration(milliseconds: 550),
                curve: Curves.easeInOutCubic,
                width: widget.isSelected ? textWidth : 0.0,
                child: ClipRect(
                  child: OverflowBox(
                    alignment: Alignment.centerLeft,
                    minWidth: 0,
                    maxWidth:
                        160.w, // Safe max width to prevent horizontal wrapping
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      opacity: widget.isSelected ? 1.0 : 0.0,
                      child: Text(
                        widget.label,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: widget.activeTextColors,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Right padding inside the active capsule (animated reveal)
              AnimatedContainer(
                duration: const Duration(milliseconds: 550),
                curve: Curves.easeInOutCubic,
                width: widget.isSelected ? 16.w : 0.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
