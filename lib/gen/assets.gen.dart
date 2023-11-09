/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/ic_launcher.png
  AssetGenImage get icLauncher =>
      const AssetGenImage('assets/icons/ic_launcher.png');

  /// File path: assets/icons/ic_launcher_foreground.png
  AssetGenImage get icLauncherForeground =>
      const AssetGenImage('assets/icons/ic_launcher_foreground.png');

  /// File path: assets/icons/ic_launcher_round.png
  AssetGenImage get icLauncherRound =>
      const AssetGenImage('assets/icons/ic_launcher_round.png');

  /// File path: assets/icons/macos_original.png
  AssetGenImage get macosOriginal =>
      const AssetGenImage('assets/icons/macos_original.png');

  $AssetsIconsProductsGen get products => const $AssetsIconsProductsGen();

  /// List of all assets
  List<AssetGenImage> get values =>
      [icLauncher, icLauncherForeground, icLauncherRound, macosOriginal];
}

class $AssetsIllustrationsGen {
  const $AssetsIllustrationsGen();

  /// File path: assets/illustrations/default_profile_background.jpeg
  AssetGenImage get defaultProfileBackground => const AssetGenImage(
      'assets/illustrations/default_profile_background.jpeg');

  /// File path: assets/illustrations/snap_the_moment_re_88cu.png
  AssetGenImage get snapTheMomentRe88cu =>
      const AssetGenImage('assets/illustrations/snap_the_moment_re_88cu.png');

  /// File path: assets/illustrations/undraw_audio_player_re_cl20.svg
  String get undrawAudioPlayerReCl20 =>
      'assets/illustrations/undraw_audio_player_re_cl20.svg';

  /// File path: assets/illustrations/undraw_contemplating_re_ynec.svg
  String get undrawContemplatingReYnec =>
      'assets/illustrations/undraw_contemplating_re_ynec.svg';

  /// File path: assets/illustrations/undraw_no_data_re_kwbl.svg
  String get undrawNoDataReKwbl =>
      'assets/illustrations/undraw_no_data_re_kwbl.svg';

  /// File path: assets/illustrations/undraw_snap_the_moment_re_88cu.svg
  String get undrawSnapTheMomentRe88cu =>
      'assets/illustrations/undraw_snap_the_moment_re_88cu.svg';

  /// File path: assets/illustrations/undraw_things_to_say_re_jpcg.svg
  String get undrawThingsToSayReJpcg =>
      'assets/illustrations/undraw_things_to_say_re_jpcg.svg';

  /// File path: assets/illustrations/undraw_video_streaming_re_v3qg.svg
  String get undrawVideoStreamingReV3qg =>
      'assets/illustrations/undraw_video_streaming_re_v3qg.svg';

  /// List of all assets
  List<dynamic> get values => [
        defaultProfileBackground,
        snapTheMomentRe88cu,
        undrawAudioPlayerReCl20,
        undrawContemplatingReYnec,
        undrawNoDataReKwbl,
        undrawSnapTheMomentRe88cu,
        undrawThingsToSayReJpcg,
        undrawVideoStreamingReV3qg
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/YouTube.jpeg
  AssetGenImage get youTube =>
      const AssetGenImage('assets/images/YouTube.jpeg');

  /// File path: assets/images/avatar.png
  AssetGenImage get avatar => const AssetGenImage('assets/images/avatar.png');

  /// List of all assets
  List<AssetGenImage> get values => [youTube, avatar];
}

class $AssetsIconsProductsGen {
  const $AssetsIconsProductsGen();

  /// File path: assets/icons/products/balloner.png
  AssetGenImage get balloner =>
      const AssetGenImage('assets/icons/products/balloner.png');

  /// File path: assets/icons/products/i_didnt.png
  AssetGenImage get iDidnt =>
      const AssetGenImage('assets/icons/products/i_didnt.png');

  /// File path: assets/icons/products/ygktool.png
  AssetGenImage get ygktool =>
      const AssetGenImage('assets/icons/products/ygktool.png');

  /// List of all assets
  List<AssetGenImage> get values => [balloner, iDidnt, ygktool];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsIllustrationsGen illustrations =
      $AssetsIllustrationsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

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
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
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

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
