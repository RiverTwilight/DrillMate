// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SettingsState {
  ThemeMode get theme => throw _privateConstructorUsedError;
  AppLocale? get locale => throw _privateConstructorUsedError;
  ThemeColor get themeColor => throw _privateConstructorUsedError;
  bool get autoSeek => throw _privateConstructorUsedError;
  bool get autoFetchYoutubeTitle => throw _privateConstructorUsedError;
  bool get danmuku => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SettingsStateCopyWith<SettingsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsStateCopyWith<$Res> {
  factory $SettingsStateCopyWith(
          SettingsState value, $Res Function(SettingsState) then) =
      _$SettingsStateCopyWithImpl<$Res, SettingsState>;
  @useResult
  $Res call(
      {ThemeMode theme,
      AppLocale? locale,
      ThemeColor themeColor,
      bool autoSeek,
      bool autoFetchYoutubeTitle,
      bool danmuku});
}

/// @nodoc
class _$SettingsStateCopyWithImpl<$Res, $Val extends SettingsState>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? theme = null,
    Object? locale = freezed,
    Object? themeColor = null,
    Object? autoSeek = null,
    Object? autoFetchYoutubeTitle = null,
    Object? danmuku = null,
  }) {
    return _then(_value.copyWith(
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      locale: freezed == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as AppLocale?,
      themeColor: null == themeColor
          ? _value.themeColor
          : themeColor // ignore: cast_nullable_to_non_nullable
              as ThemeColor,
      autoSeek: null == autoSeek
          ? _value.autoSeek
          : autoSeek // ignore: cast_nullable_to_non_nullable
              as bool,
      autoFetchYoutubeTitle: null == autoFetchYoutubeTitle
          ? _value.autoFetchYoutubeTitle
          : autoFetchYoutubeTitle // ignore: cast_nullable_to_non_nullable
              as bool,
      danmuku: null == danmuku
          ? _value.danmuku
          : danmuku // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SettingsStateCopyWith<$Res>
    implements $SettingsStateCopyWith<$Res> {
  factory _$$_SettingsStateCopyWith(
          _$_SettingsState value, $Res Function(_$_SettingsState) then) =
      __$$_SettingsStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ThemeMode theme,
      AppLocale? locale,
      ThemeColor themeColor,
      bool autoSeek,
      bool autoFetchYoutubeTitle,
      bool danmuku});
}

/// @nodoc
class __$$_SettingsStateCopyWithImpl<$Res>
    extends _$SettingsStateCopyWithImpl<$Res, _$_SettingsState>
    implements _$$_SettingsStateCopyWith<$Res> {
  __$$_SettingsStateCopyWithImpl(
      _$_SettingsState _value, $Res Function(_$_SettingsState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? theme = null,
    Object? locale = freezed,
    Object? themeColor = null,
    Object? autoSeek = null,
    Object? autoFetchYoutubeTitle = null,
    Object? danmuku = null,
  }) {
    return _then(_$_SettingsState(
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      locale: freezed == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as AppLocale?,
      themeColor: null == themeColor
          ? _value.themeColor
          : themeColor // ignore: cast_nullable_to_non_nullable
              as ThemeColor,
      autoSeek: null == autoSeek
          ? _value.autoSeek
          : autoSeek // ignore: cast_nullable_to_non_nullable
              as bool,
      autoFetchYoutubeTitle: null == autoFetchYoutubeTitle
          ? _value.autoFetchYoutubeTitle
          : autoFetchYoutubeTitle // ignore: cast_nullable_to_non_nullable
              as bool,
      danmuku: null == danmuku
          ? _value.danmuku
          : danmuku // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_SettingsState implements _SettingsState {
  const _$_SettingsState(
      {required this.theme,
      required this.locale,
      required this.themeColor,
      required this.autoSeek,
      required this.autoFetchYoutubeTitle,
      required this.danmuku});

  @override
  final ThemeMode theme;
  @override
  final AppLocale? locale;
  @override
  final ThemeColor themeColor;
  @override
  final bool autoSeek;
  @override
  final bool autoFetchYoutubeTitle;
  @override
  final bool danmuku;

  @override
  String toString() {
    return 'SettingsState(theme: $theme, locale: $locale, themeColor: $themeColor, autoSeek: $autoSeek, autoFetchYoutubeTitle: $autoFetchYoutubeTitle, danmuku: $danmuku)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SettingsState &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.themeColor, themeColor) ||
                other.themeColor == themeColor) &&
            (identical(other.autoSeek, autoSeek) ||
                other.autoSeek == autoSeek) &&
            (identical(other.autoFetchYoutubeTitle, autoFetchYoutubeTitle) ||
                other.autoFetchYoutubeTitle == autoFetchYoutubeTitle) &&
            (identical(other.danmuku, danmuku) || other.danmuku == danmuku));
  }

  @override
  int get hashCode => Object.hash(runtimeType, theme, locale, themeColor,
      autoSeek, autoFetchYoutubeTitle, danmuku);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SettingsStateCopyWith<_$_SettingsState> get copyWith =>
      __$$_SettingsStateCopyWithImpl<_$_SettingsState>(this, _$identity);
}

abstract class _SettingsState implements SettingsState {
  const factory _SettingsState(
      {required final ThemeMode theme,
      required final AppLocale? locale,
      required final ThemeColor themeColor,
      required final bool autoSeek,
      required final bool autoFetchYoutubeTitle,
      required final bool danmuku}) = _$_SettingsState;

  @override
  ThemeMode get theme;
  @override
  AppLocale? get locale;
  @override
  ThemeColor get themeColor;
  @override
  bool get autoSeek;
  @override
  bool get autoFetchYoutubeTitle;
  @override
  bool get danmuku;
  @override
  @JsonKey(ignore: true)
  _$$_SettingsStateCopyWith<_$_SettingsState> get copyWith =>
      throw _privateConstructorUsedError;
}
