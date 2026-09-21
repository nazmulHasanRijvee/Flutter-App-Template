import 'package:material_ui/material_ui.dart';

/// [SplashScreen] solely focuses on its splash UI, free from
/// any authentication or onboarding logic. All app-level initialization
/// logics are centralized in [startupProvider].
///
/// While routing decisions (based on authentication, onboadring status) are handled  by go_router's
/// [routerStateProvider]
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Splash Screen')));
  }
}
