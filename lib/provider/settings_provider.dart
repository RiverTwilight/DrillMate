import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/gen/strings.g.dart';
import "package:hgeology_app/models/settings_state.dart";
import 'package:hgeology_app/models/theme_color.dart';
import 'package:hgeology_app/provider/persistance_provider.dart';

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});

class SettingsNotifier extends Notifier<SettingsState> {
  late PersistenceService _service;

  SettingsNotifier();

  @override
  SettingsState build() {
    _service = ref.watch(persistenceProvider);
    return SettingsState(
      theme: _service.getTheme(),
      locale: _service.getLocale(),
      themeColor: _service.getThemeColor(),
      autoSeek: _service.getAutoSeek(),
      autoFetchYoutubeTitle: _service.getAutoFetchYoutubeTitle(),
      danmuku: _service.getDanmuku(),
    );
  }

  Future<void> setTheme(ThemeMode theme) async {
    await _service.setTheme(theme);
    state = state.copyWith(
      theme: theme,
    );
  }

  Future<void> setLocale(AppLocale? locale) async {
    await _service.setLocale(locale);
    state = state.copyWith(
      locale: locale,
    );
  }

  Future<void> setThemeColor(ThemeColor color) async {
    await _service.setThemeColor(color);
    state = state.copyWith(
      themeColor: color,
    );
  }

  Future<void> setAutoSeek(bool autoSeek) async {
    await _service.setAutoSeek(autoSeek);
    state = state.copyWith(
      autoSeek: autoSeek,
    );
  }

  Future<void> setAutoFetchYoutubeTitle(bool autoFetchYoutubeTitle) async {
    await _service.setAutoFetchYoutubeTitle(autoFetchYoutubeTitle);
    state = state.copyWith(
      autoFetchYoutubeTitle: autoFetchYoutubeTitle,
    );
  }

  Future<void> setDanmuku(bool danmuku) async {
    await _service.setDanmuku(danmuku);
    state = state.copyWith(
      danmuku: danmuku,
    );
  }
}
