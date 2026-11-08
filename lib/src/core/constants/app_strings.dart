/// enum used as an alternative of static const variables in a class AppStrings {...}
enum AppStrings {
  hi("Hi"),
  appName("Template");

  const AppStrings(this.text);
  final String text;
}