import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../router/routes.dart';
import '../theme/theme.dart';

/// `errorBuilder` destination for unmatched routes. The button targets
/// [Routes.home]; an unauthenticated user is redirected to login by the
/// gate.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({required this.uri, super.key});

  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: context.dimensions.sizes.md,
              color: context.color.text.primary,
            ),
            context.dimensions.spacing.sm.verticalSpace,
            Text(uri.toString()),
            context.dimensions.spacing.sm.verticalSpace,
            FilledButton(
              onPressed: () => context.go(Routes.homeScreen.path),
              child: Text("Go to Home"),
            ),
          ],
        ),
      ),
    );
  }
}
