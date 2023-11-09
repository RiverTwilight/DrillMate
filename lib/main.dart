import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hgeology_app/models/theme_color.dart';

import 'package:hgeology_app/provider/auth_provider.dart';
import 'package:hgeology_app/provider/persistance_provider.dart';
import 'package:hgeology_app/pages/home_page.dart';
import 'package:hgeology_app/init.dart';
import 'package:hgeology_app/gen/strings.g.dart';
import 'package:hgeology_app/provider/settings_provider.dart';
import 'provider.dart';
import 'theme.dart';

void main(List<String> args) async {
  final persistenceService = await preInit(args);
  runApp(ProviderScope(
    overrides: [
      persistenceProvider.overrideWithValue(persistenceService),
    ],
    child: TranslationProvider(
      child: const HGeologyApp(),
    ),
  ));
}

class HGeologyApp extends ConsumerStatefulWidget {
  const HGeologyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<HGeologyApp> createState() => _HGeologyAppState();
}

class _HGeologyAppState extends ConsumerState<HGeologyApp> {
  bool _initialized = false;
  AuthProvider? authManager;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      initializeAsyncTasks();
      _initialized = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initializeAsyncTasks() async {
    final video = ref.read(videoProvider);
    final bookmarkManager = ref.read(bookmarkProvider);
    final collectionManager = ref.read(collectionProvider);

    video.loadData();
    bookmarkManager.loadData();
    collectionManager.loadData();

    try {
      final userDataManager = ref.read(userDataProvider);
      await userDataManager.loadData();
    } catch (e) {
      // print('An error occurred: $e');
    }

    setState(() {
      authManager = AuthProvider();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode =
        ref.watch(settingsProvider.select((settings) => settings.theme));
    final themeColor =
        ref.watch(settingsProvider.select((settings) => settings.themeColor));

    // if (authManager == null) {
    //   return Container();
    // }

    // print(TranslationProvider.of(context).flutterLocale);
    return DynamicColorBuilder(builder: (lightColor, darkColor) {
      return MaterialApp(
        theme: getTheme(Brightness.light, null,
            themeColor: themeColor.materialName),
        darkTheme: getTheme(Brightness.dark, null,
            themeColor: themeColor.materialName),
        themeMode: themeMode,
        debugShowCheckedModeBanner: false,
        locale: TranslationProvider.of(context).flutterLocale,
        supportedLocales: AppLocaleUtils.supportedLocales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: const HomePage(),
      );
    });
    // Uncomment this to enable force login
    //
    // home: StreamBuilder<User?>(
    //   stream: authManager?.userStream,
    //   builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
    //     if (snapshot.connectionState == ConnectionState.active) {
    //       if (snapshot.data != null) {
    //         // User is logged in, return your home layout
    //         return const HomePage();
    //       } else {
    //         // User is not logged in
    //         return LoginScreen(onLoginSuccess: () {
    //           setState(() {
    //             authManager = AuthProvider();
    //           });
    //         });
    //       }
    //     } else {
    //       // Return the LoginScreen if an error happens or while waiting for the connection
    //       return const Scaffold(
    //           body: Center(
    //         child: SizedBox(
    //           height: 50,
    //           width: 50,
    //           child: CircularProgressIndicator(),
    //         ),
    //       ));
    //     }
    //   },
    // ),
  }
}

extension on ThemeColor {
  MaterialColor get materialName {
    switch (this) {
      case ThemeColor.green:
        return Colors.green;
      case ThemeColor.blue:
        return Colors.blue;
      case ThemeColor.yellow:
        return Colors.yellow;
      case ThemeColor.brown:
        return Colors.brown;
      case ThemeColor.purple:
        return Colors.purple;
    }
  }
}
