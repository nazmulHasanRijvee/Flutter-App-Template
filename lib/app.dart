import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/src/presentation/core/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'src/presentation/core/application_state/theme_mode_provider/theme_mode_provider.dart';
import 'src/presentation/core/router/router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

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
