import 'package:flutter_app_template/src/core/extensions/riverpod_extensions.dart';
import 'package:flutter_app_template/src/presentation/core/routes/custom_transition_page.dart';
import 'package:flutter_app_template/src/presentation/core/routes/redirect_gate.dart';
import 'package:flutter_app_template/src/presentation/core/routes/router_state/router_state_provider.dart';
import 'package:flutter_app_template/src/presentation/core/widgets/not_found_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../feature/ask/ask_screen/view/ask_screen.dart';
import '../../feature/auth/create_new_password/view/create_new_pass_screen.dart';
import '../../feature/auth/reset_password/view/reset_pass_screen.dart';
import '../../feature/auth/register_screen/view/register_screen.dart';
import '../../feature/auth/sign_in_screen/view/sign_in_screen.dart';
import '../../feature/auth/email_verification/view/email_verification_screen.dart';
import '../../feature/community/community_screen/view/community_screen.dart';
import '../../feature/home/bottom_nav_bar/view/bottom_nav_bar.dart';
import '../../feature/home/home_screen/view/home_screen.dart';
import '../../feature/onboarding/start_today/view/start_today_screen.dart';
import '../../feature/splash/splash_screen/view/splash_screen.dart';
import '../providers/navigator_key_provider.dart';
import 'routes.dart';

part 'route_config.dart';
part 'parts/onboarding_routes.dart';
part "parts/authentication_routes.dart";
part "parts/shell_routes.dart";
