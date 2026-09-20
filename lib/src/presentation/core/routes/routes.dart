/// The app's named routes. [path] is the URL segment handed to
/// `GoRoute.path`; `name` (the enum member name) is what `GoRoute.name`
/// and named navigation (`context.pushNamed`) use. Keeping both on one
/// enum means path and name cannot drift, and switches over routes are
/// exhaustive.
///
/// Top-level routes carry absolute paths (leading `/`). Sub-routes carry
/// relative segments and nest under their parent in the route tree — their
/// full location is the joined path (e.g. `/login/registration`).
enum Routes {
  splash('/splash'),
  onboarding('/onboarding'),

  login('/login'),
  register('/register_screen'),
  resetPassScreen('/reset_pass_screen'),
  emailVerificationScreen('/email_verification_screen'),
  createNewPassScreen('/create_new_pass_screen'),

  homeScreen('/home_screen'),
  chatScreen('/chat_screen'),
  communityScreen('/community_screen');

  const Routes(this.path);

  final String path;
}
