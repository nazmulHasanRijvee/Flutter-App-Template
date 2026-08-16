import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppTransitionType {
  rightToLeft,
  leftToRight,
  bottomToTop,
  topToBottom,
  fade,
  scale,
  none,
}

CustomTransitionPage buildTransitionPage({
  required Widget child,
  required LocalKey key,
  AppTransitionType type = AppTransitionType.rightToLeft,
  Duration duration = const Duration(milliseconds: 200),
}) {
  return CustomTransitionPage(
    key: key,
    transitionDuration: duration,
    child: child,
    transitionsBuilder: (_, animation, _, child) {
      switch (type) {
        case AppTransitionType.rightToLeft:
          return SlideTransition(
            position: Tween(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );

        case AppTransitionType.leftToRight:
          return SlideTransition(
            position: Tween(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );

        case AppTransitionType.bottomToTop:
          return SlideTransition(
            position: Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );

        case AppTransitionType.topToBottom:
          return SlideTransition(
            position: Tween(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );

        case AppTransitionType.fade:
          return FadeTransition(opacity: animation, child: child);

        case AppTransitionType.scale:
          return ScaleTransition(
            scale: Tween(begin: 0.9, end: 1.0).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );

        case AppTransitionType.none:
          return child;
      }
    },
  );
}
