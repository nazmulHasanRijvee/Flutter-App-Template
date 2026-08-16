// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/aftar_noon.svg
  String get aftarNoon => 'assets/icons/aftar_noon.svg';

  /// File path: assets/icons/apple_icon.svg
  String get appleIcon => 'assets/icons/apple_icon.svg';

  /// File path: assets/icons/chat.svg
  String get chat => 'assets/icons/chat.svg';

  /// File path: assets/icons/chat_outline.svg
  String get chatOutline => 'assets/icons/chat_outline.svg';

  /// File path: assets/icons/devotion.svg
  String get devotion => 'assets/icons/devotion.svg';

  /// File path: assets/icons/google_icon.svg
  String get googleIcon => 'assets/icons/google_icon.svg';

  /// File path: assets/icons/group.svg
  String get group => 'assets/icons/group.svg';

  /// File path: assets/icons/morning.svg
  String get morning => 'assets/icons/morning.svg';

  /// File path: assets/icons/night.svg
  String get night => 'assets/icons/night.svg';

  /// File path: assets/icons/notification.svg
  String get notification => 'assets/icons/notification.svg';

  /// File path: assets/icons/pray.svg
  String get pray => 'assets/icons/pray.svg';

  /// File path: assets/icons/prayed.png
  AssetGenImage get prayed => const AssetGenImage('assets/icons/prayed.png');

  /// List of all assets
  List<dynamic> get values => [
    aftarNoon,
    appleIcon,
    chat,
    chatOutline,
    devotion,
    googleIcon,
    group,
    morning,
    night,
    notification,
    pray,
    prayed,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/app_icon.png
  AssetGenImage get appIcon =>
      const AssetGenImage('assets/images/app_icon.png');

  /// File path: assets/images/app_logo.png
  AssetGenImage get appLogo =>
      const AssetGenImage('assets/images/app_logo.png');

  /// File path: assets/images/misty_mountains.png
  AssetGenImage get mistyMountains =>
      const AssetGenImage('assets/images/misty_mountains.png');

  /// File path: assets/images/people.png
  AssetGenImage get people => const AssetGenImage('assets/images/people.png');

  /// File path: assets/images/start_divider.png
  AssetGenImage get startDivider =>
      const AssetGenImage('assets/images/start_divider.png');

  /// File path: assets/images/start_image.png
  AssetGenImage get startImage =>
      const AssetGenImage('assets/images/start_image.png');

  /// File path: assets/images/verse_frame.png
  AssetGenImage get verseFrame =>
      const AssetGenImage('assets/images/verse_frame.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    appIcon,
    appLogo,
    mistyMountains,
    people,
    startDivider,
    startImage,
    verseFrame,
  ];
}

abstract final class Assets {
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
