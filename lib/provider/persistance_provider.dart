import 'dart:io';
import 'package:hgeology_app/models/theme_color.dart';
import 'package:hgeology_app/provider/settings_provider.dart';
import 'package:hgeology_app/utils/native/platform_check.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hgeology_app/gen/strings.g.dart';

const _themeKey = 'tr_theme';
const _themeColorKey = 'tr_color';
const _autoSeekKey = 'tr_autoseek';
const _danmukuKey = 'tr_danmuku';
const _localeKey = 'tr_locale';
const _autoFetchYoutubeTitleKey = 'cm_autofetchyoutubetitle';

final _logger = Logger('PersistenceService');

final persistenceProvider = Provider<PersistenceService>((ref) {
  throw Exception('persistenceProvider not initialized');
});

/// This service abstracts the persistence layer.
class PersistenceService {
  final SharedPreferences _prefs;

  PersistenceService._(this._prefs);

  static Future<PersistenceService> initialize() async {
    SharedPreferences prefs;

    try {
      prefs = await SharedPreferences.getInstance();
    } catch (e) {
      if (checkPlatform([TargetPlatform.windows])) {
        _logger.info(
            'Could not initialize SharedPreferences, trying to delete corrupted settings file');
        final settingsDir = await path.getApplicationSupportDirectory();
        final prefsFile = p.join(settingsDir.path, 'shared_preferences.json');
        File(prefsFile).deleteSync();
        prefs = await SharedPreferences.getInstance();
      } else {
        throw Exception('Could not initialize SharedPreferences');
      }
    }

    final persistedLocale = prefs.getString(_localeKey);
    if (persistedLocale == null) {
      LocaleSettings.useDeviceLocale();
    } else {
      LocaleSettings.setLocaleRaw(persistedLocale);
    }

    return PersistenceService._(prefs);
  }

  ThemeMode getTheme() {
    final value = _prefs.getString(_themeKey);
    if (value == null) {
      return ThemeMode.system;
    }
    return ThemeMode.values.firstWhereOrNull((theme) => theme.name == value) ??
        ThemeMode.system;
  }

  Future<void> setTheme(ThemeMode theme) async {
    await _prefs.setString(_themeKey, theme.name);
  }

  AppLocale? getLocale() {
    final value = _prefs.getString(_localeKey);
    if (value == null) {
      return null;
    }
    return AppLocale.values
        .firstWhereOrNull((locale) => locale.languageTag == value);
  }

  Future<void> setLocale(AppLocale? locale) async {
    if (locale == null) {
      await _prefs.remove(_localeKey);
    } else {
      await _prefs.setString(_localeKey, locale.languageTag);
    }
  }

  ThemeColor getThemeColor() {
    final value = _prefs.getString(_themeColorKey);

    return ThemeColor.values.firstWhereOrNull((color) => color.name == value) ??
        ThemeColor.green;
  }

  Future<void> setThemeColor(ThemeColor color) async {
    await _prefs.setString(_themeColorKey, color.name);
  }

  bool getAutoSeek() {
    return _prefs.getBool(_autoSeekKey) ?? true;
  }

  Future<void> setAutoSeek(bool autoSeek) async {
    await _prefs.setBool(_autoSeekKey, autoSeek);
  }

  bool getAutoFetchYoutubeTitle() {
    return _prefs.getBool(_autoFetchYoutubeTitleKey) ?? true;
  }

  Future<void> setAutoFetchYoutubeTitle(bool autoFetchYoutubeTitle) async {
    await _prefs.setBool(_autoFetchYoutubeTitleKey, autoFetchYoutubeTitle);
  }

  bool getDanmuku() {
    return _prefs.getBool(_danmukuKey) ?? true;
  }

  Future<void> setDanmuku(bool danmuku) async {
    await _prefs.setBool(_danmukuKey, danmuku);
  }
}
