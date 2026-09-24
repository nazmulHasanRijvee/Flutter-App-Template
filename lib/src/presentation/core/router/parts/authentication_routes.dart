part of "../router.dart";

List<GoRoute> _authenticationRoutes(Ref ref) {
  return [
    GoRoute(
      path: Routes.login.path,
      name: Routes.login.name,
      pageBuilder: (context, state) {
        return const MaterialPage(child: LoginScreen());
      },
      routes: [
        GoRoute(
          path: Routes.register.path,
          name: Routes.register.name,
          pageBuilder: (context, state) => buildTransitionPage(
            child: RegisterScreen(),
            key: ValueKey(Routes.register.name),
          ),
        ),
        GoRoute(
          path: Routes.resetPassScreen.path,
          name: Routes.resetPassScreen.name,
          pageBuilder: (context, state) =>
              const MaterialPage(child: ResetPassScreen()),
          routes: [
            GoRoute(
              path: Routes.emailVerificationScreen.path,
              name: Routes.emailVerificationScreen.name,
              pageBuilder: (context, state) =>
                  const MaterialPage(child: EmailVerificationScreen()),
            ),
            GoRoute(
              path: Routes.createNewPassScreen.path,
              name: Routes.createNewPassScreen.name,
              pageBuilder: (context, state) =>
                  const MaterialPage(child: CreateNewPassScreen()),
              routes: [],
            ),
          ],
        ),
      ],
    ),
  ];
}
