import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/gen/assets.gen.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../view_model/onboarding_status_provider.dart';

class StartTodayScreen extends ConsumerWidget {
  const StartTodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        alignment: .bottomCenter,
        children: [
          Assets.images.appIcon.image().animate().fadeIn(duration: 700.ms),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.color.scaffoldBackground.withValues(alpha: 0.9),
                  context.color.scaffoldBackground.withValues(alpha: 0.4),
                  context.color.scaffoldBackground.withValues(alpha: 0.2),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.images.appLogo
                        .image()
                        .animate()
                        .fadeIn(duration: 700.ms)
                        .slideY(begin: -.3, end: 0),

                    Text(
                      'Mercy',
                      style: GoogleFonts.playfairDisplay(
                        color: context.color.primary,
                        fontSize: 48,
                        fontWeight: .w700,
                      ),
                    ),

                    Text(
                      'Grow your faith daily',
                      style: GoogleFonts.inter(
                        color: context.color.primary,
                        fontSize: 20,
                        fontWeight: .w500,
                      ),
                    ),

                    80.verticalSpace,

                    SizedBox(
                      width: 230.w,
                      child:
                          Text(
                                "For we walk by faith,\n not by sight.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.manrope(
                                  fontSize: 20.sp,
                                  color: context.color.text.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                              .animate(delay: 500.ms)
                              .fadeIn(duration: 800.ms)
                              .slideY(begin: .2, end: 0),
                    ),

                    20.verticalSpace,

                    Text(
                      "2nd Corinthians 5:7",
                      style: context.textStyle.bodyMedium.copyWith(
                        color: context.color.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ).animate(delay: 700.ms).fadeIn(duration: 700.ms),

                    180.verticalSpace,

                    GestureDetector(
                          onTap: () async {
                            // Persist onboarding first. Updating the notifier
                            // changes routerStateProvider; go_router then
                            // sends this user to login (no imperative push).
                            await ref
                                .read(onboardingStatusProvider.notifier)
                                .completeOnboarding();
                          },
                          child:
                              Container(
                                    height: 55.h,
                                    decoration: BoxDecoration(
                                      color: context.color.primary,
                                      borderRadius: BorderRadius.circular(30.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: context.color.primary
                                              .withValues(alpha: .25),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Start Your Journey",
                                        style: context.textStyle.bodyMedium
                                            .copyWith(
                                              color: context.color.onPrimary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  )
                                  .animate(
                                    onPlay: (controller) => controller.repeat(),
                                  )
                                  .shimmer(duration: 1800.ms),
                        )
                        .animate(delay: 900.ms)
                        .fadeIn(duration: 700.ms)
                        .slideY(begin: 1, end: 0),

                    20.verticalSpace,

                    RichText(
                          text: TextSpan(
                            text: 'Already Have an account? ',
                            style: context.textStyle.bodyLarge.copyWith(
                              color: context.color.primary,
                              fontWeight: .w500,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign in',
                                style: context.textStyle.bodyLarge.copyWith(
                                  color: context.color.text.primary,
                                  fontWeight: .w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.push(Routes.login.path);
                                  },
                              ),
                            ],
                          ),
                        )
                        .animate(delay: 900.ms)
                        .fadeIn(duration: 700.ms)
                        .slideY(begin: 1, end: 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
