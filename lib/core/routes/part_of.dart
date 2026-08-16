import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../src/feature/ask/ask_screen/view/ask_screen.dart';
import '../../src/feature/auth/create_new_password/view/create_new_pass_screen.dart';
import '../../src/feature/auth/forgot_password/view/forgot_pass_screen.dart';
import '../../src/feature/auth/register_screen/view/register_screen.dart';
import '../../src/feature/auth/sign_in_screen/view/sign_in_screen.dart';
import '../../src/feature/auth/verify_email/view/verify_email_screen.dart';
import '../../src/feature/community/community_screen/view/community_screen.dart';
import '../../src/feature/home/bottom_nav_bar/view/bottom_nav_bar.dart';
import '../../src/feature/home/home_screen/view/home_screen.dart';
import '../../src/feature/onboarding/start_today/view/start_today_screen.dart';
import '../providers/navigator_key_provider.dart';
import 'route_const.dart';

part 'route_config.dart';
