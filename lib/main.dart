import 'package:flutter_app_template/app.dart';
import 'package:flutter_app_template/src/core/bootstrap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    UncontrolledProviderScope(
      container: await bootstrap(),
      child: const MyApp(),
    ),
  );
}
