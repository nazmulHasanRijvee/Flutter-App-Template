import 'package:flutter/material.dart';

/// extension's on BuildContext class for cleanly or shortly accessing
// MediaQuery like context.mqSizeOfWidth and other things in UI 
// There's also other extension's on BuildContext for handling theme
// in core/static/theme/theme.dart file
extension ContextEx on BuildContext {
  /// Private theme getter to access the current theme of the context
  // only in this extension, not to be used outside of this extension
  ThemeData get _theme => Theme.of(this);

  /// Returns true if the current platform is iOS, false otherwise.
  bool get isIos => _theme.platform == TargetPlatform.iOS;
  /// Returns true if the current platform is Android, false otherwise.
  bool get isAndroid => _theme.platform == TargetPlatform.android;

  /// Returns MediaQueryData of the current context, which provides information
  /// about the padding of the screen.
  MediaQueryData get mq => MediaQuery.of(this);
  EdgeInsets get mqViewInsets => MediaQuery.viewInsetsOf(this);
  EdgeInsets get mqViewPadding => MediaQuery.viewPaddingOf(this);
  EdgeInsets get mqPadding => MediaQuery.paddingOf(this);

  /// Returns the MediaQuery size of the screen as a Size object.
  Size get mqSizeOf => MediaQuery.sizeOf(this);
  /// Returns the total height of the screen only when size changes
  double get mqSizeOfHeight => mqSizeOf.height;
  /// Returns the total width of the screen
  double get mqSizeOfWidth => mqSizeOf.width;

  /// Returns true if the screen width is greater than 600px.
  bool get isTablet => MediaQuery.sizeOf(this).width > 600;
}
