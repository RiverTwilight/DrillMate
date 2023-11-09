import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hgeology_app/utils/native/platform_check.dart';

final _borderRadius = BorderRadius.circular(8);

ThemeData getTheme(Brightness brightness, ColorScheme? colorScheme,
    {MaterialColor themeColor = Colors.blueGrey}) {
  colorScheme ??= ColorScheme.fromSwatch(
    primarySwatch: themeColor,
    brightness: brightness,
    backgroundColor:
        brightness == Brightness.light ? Colors.white : Colors.grey.shade900,
  ).copyWith(
    onError: Colors.white,
    tertiaryContainer: brightness == Brightness.light
        ? const Color(0xffF0F0F0)
        : const Color.fromARGB(255, 26, 26, 28),
    onTertiary: brightness == Brightness.light
        ? Colors.grey.shade900
        : Colors.white.withOpacity(0.9),
    secondaryContainer: brightness == Brightness.light
        ? Color.lerp(themeColor.shade100, Colors.white, 0.5)
        : Color.lerp(themeColor.shade100, Colors.black, 0.6),
    onSecondaryContainer:
        brightness == Brightness.light ? Colors.black : Colors.white,
  );

  final lightInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: colorScheme.secondaryContainer),
    borderRadius: _borderRadius,
  );

  final darkInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: colorScheme.secondaryContainer),
    borderRadius: _borderRadius,
  );

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    navigationBarTheme: brightness == Brightness.dark
        ? NavigationBarThemeData(
            iconTheme: MaterialStateProperty.all(
                const IconThemeData(color: Colors.white)),
          )
        : null,
    brightness: brightness,
    // primaryColor: const Color(0xFF34A555),
    // primaryColorLight: const Color(0xFF44BC67),
    // scaffoldBackgroundColor: const Color(0xFF44BC67),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.secondaryContainer,
      border:
          brightness == Brightness.light ? lightInputBorder : darkInputBorder,
      focusedBorder:
          brightness == Brightness.light ? lightInputBorder : darkInputBorder,
      enabledBorder:
          brightness == Brightness.light ? lightInputBorder : darkInputBorder,
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: brightness == Brightness.dark ? Colors.white : null,
        padding: checkPlatformIsDesktop()
            ? const EdgeInsets.all(16)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    // textTheme: TextTheme(
    //     titleLarge: TextStyle(color: Colors.blue),
    //     titleSmall: TextStyle(
    //         color: brightness == Brightness.light
    //             ? Colors.black26
    //             : Colors.white38,
    //         fontSize: 20,
    //         fontWeight: FontWeight.bold),
    //     bodySmall: TextStyle(
    //         fontSize: 12,
    //         color: brightness == Brightness.light
    //             ? Colors.black26
    //             : Colors.white38)),
  );
}

Future<void> updateSystemOverlayStyle(BuildContext context) async {
  final brightness = Theme.of(context).brightness;
  // final brightness = MediaQuery.of(context).platformBrightness;
  await updateSystemOverlayStyleWithBrightness(brightness);
}

Future<void> updateSystemOverlayStyleWithBrightness(
    Brightness brightness) async {
  final style = SystemUiOverlayStyle(
    statusBarIconBrightness: brightness == Brightness.light
        ? Brightness.dark
        : Brightness.light, // android
    statusBarBrightness: brightness, // iOS
    systemNavigationBarColor: Colors.transparent,
    statusBarColor: Colors.transparent,
  );

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(style);
}

// extension ThemeDataExt on ThemeData {
//   /// This is the actual [cardColor] being used.
//   Color get cardColorWithElevation {
//     return ElevationOverlay.applySurfaceTint(
//         cardColor, colorScheme.surfaceTint, 1);
//   }
// }

extension ColorSchemeExt on ColorScheme {
  Color get warning {
    return Colors.orange;
  }

  Color? get secondaryContainerIfDark {
    return brightness == Brightness.dark ? secondaryContainer : null;
  }

  Color? get onSecondaryContainerIfDark {
    return brightness == Brightness.dark ? onSecondaryContainer : null;
  }
}

extension InputDecorationThemeExt on InputDecorationTheme {
  BorderRadius get borderRadius => _borderRadius;
}
