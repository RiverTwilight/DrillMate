import 'package:flutter/material.dart';
import 'package:hgeology_app/gen/strings.g.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hgeology_app/models/theme_color.dart';

part 'settings_state.freezed.dart';

ThemeMode themeMode = ThemeMode.system;

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    required ThemeMode theme,
    required AppLocale? locale,
    required ThemeColor themeColor,
    required bool autoSeek,
    required bool autoFetchYoutubeTitle,
    required bool danmuku,
  }) = _SettingsState;
}
