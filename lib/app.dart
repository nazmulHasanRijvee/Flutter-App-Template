import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/core/providers/theme_provider.dart';
import 'package:flutter_app_template/core/routes/part_of.dart';
import 'package:flutter_app_template/core/static/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeProvider).value ?? ThemeMode.system;

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      ensureScreenSize: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Flutter Template',
          debugShowCheckedModeBanner: false,
          theme: context.lightTheme,
          darkTheme: context.darkTheme,
          /// ThemeMode.system
          themeMode: themeMode,
          routerConfig: router,
        );
      },
    );
  }
}
