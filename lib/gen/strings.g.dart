/// Generated file. Do not edit.
///
/// Locales: 2
/// Strings: 542 (271 per locale)


// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.en;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale with BaseAppLocale<AppLocale, _StringsEn> {
	en(languageCode: 'en', build: _StringsEn.build),
	zhCn(languageCode: 'zh', countryCode: 'CN', build: _StringsZhCn.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, _StringsEn> build;

	/// Gets current instance managed by [LocaleSettings].
	_StringsEn get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
_StringsEn get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
class Translations {
	Translations._(); // no constructor

	static _StringsEn of(BuildContext context) => InheritedLocaleData.of<AppLocale, _StringsEn>(context).translations;
}

/// The provider for method B
class TranslationProvider extends BaseTranslationProvider<AppLocale, _StringsEn> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, _StringsEn> of(BuildContext context) => InheritedLocaleData.of<AppLocale, _StringsEn>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	_StringsEn get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, _StringsEn> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale, {bool? listenToDeviceLocale = false}) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale setLocaleRaw(String rawLocale, {bool? listenToDeviceLocale = false}) => instance.setLocaleRaw(rawLocale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, _StringsEn> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
class _StringsEn implements BaseTranslations<AppLocale, _StringsEn> {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsEn.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  );

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, _StringsEn> $meta;

	late final _StringsEn _root = this; // ignore: unused_field

	// Translations
	String get locale => 'English';
	String get appName => 'ClipMemo';
	late final _StringsGeneralEn general = _StringsGeneralEn._(_root);
	late final _StringsMediaLibraryTabEn mediaLibraryTab = _StringsMediaLibraryTabEn._(_root);
	late final _StringsAccountDetailPageEn accountDetailPage = _StringsAccountDetailPageEn._(_root);
	late final _StringsMemoLibraryPageEn memoLibraryPage = _StringsMemoLibraryPageEn._(_root);
	late final _StringsMediaDetailPageEn mediaDetailPage = _StringsMediaDetailPageEn._(_root);
	late final _StringsStatisticTabEn statisticTab = _StringsStatisticTabEn._(_root);
	late final _StringsReviewTabEn reviewTab = _StringsReviewTabEn._(_root);
	late final _StringsMoreTabEn moreTab = _StringsMoreTabEn._(_root);
	late final _StringsAboutPageEn aboutPage = _StringsAboutPageEn._(_root);
	late final _StringsPurchasePageEn purchasePage = _StringsPurchasePageEn._(_root);
	late final _StringsNewMediaPageEn newMediaPage = _StringsNewMediaPageEn._(_root);
	late final _StringsBookmarkDetailPageEn bookmarkDetailPage = _StringsBookmarkDetailPageEn._(_root);
	late final _StringsSettingsPageEn settingsPage = _StringsSettingsPageEn._(_root);
	late final _StringsSearchPageEn searchPage = _StringsSearchPageEn._(_root);
	late final _StringsBackupPageEn backupPage = _StringsBackupPageEn._(_root);
	late final _StringsLoginPageEn loginPage = _StringsLoginPageEn._(_root);
	late final _StringsSignupPageEn signupPage = _StringsSignupPageEn._(_root);
	late final _StringsLangugaePageEn langugaePage = _StringsLangugaePageEn._(_root);
	late final _StringsDialogEn dialog = _StringsDialogEn._(_root);
	late final _StringsLinksEn links = _StringsLinksEn._(_root);
}

// Path: general
class _StringsGeneralEn {
	_StringsGeneralEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get add => 'Add';
	String get advanced => 'Advanced';
	String get cancel => 'Cancel';
	String get close => 'Close';
	String get confirm => 'Confirm';
	String get continueStr => 'Continue';
	String get copy => 'Copy';
	String get decline => 'Decline';
	String get deleteStr => 'Delete';
	String get done => 'Done';
	String get edit => 'Edit';
	String get error => 'Error';
	String get email => 'Email';
	String get example => 'Example';
	String get finished => 'Finished';
	String get hide => 'Hide';
	String get next => 'Next';
	String get off => 'Off';
	String get on => 'On';
	String get open => 'Open';
	String get password => 'Password';
	String get play => 'Play';
	String get previous => 'Previous';
	String get preview => 'Preview';
	String get pause => 'Pause';
	String get renamed => 'Renamed';
	String get rename => 'Rename';
	String get reset => 'Reset';
	String get settings => 'Settings';
	String get start => 'Start';
	String get stop => 'Stop';
	String get save => 'Save';
	String get unchanged => 'Unchanged';
	String get unknown => 'Unknown';
	String get expired => 'Expired';
	String get nologin => 'Not Login';
	String get view => 'View';
	String get learnMore => 'Learn More...';
	String get language => 'Language';
	String get noEligibilityHint => 'You need to upgrade to Plus plan to use this feature.';
}

// Path: mediaLibraryTab
class _StringsMediaLibraryTabEn {
	_StringsMediaLibraryTabEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get tabName => 'Library';
	String get emptyHint => 'There is no media yet, add one';
	late final _StringsMediaLibraryTabSortMethodEn sortMethod = _StringsMediaLibraryTabSortMethodEn._(_root);
}

// Path: accountDetailPage
class _StringsAccountDetailPageEn {
	_StringsAccountDetailPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Account';
	late final _StringsAccountDetailPageInfoEn info = _StringsAccountDetailPageInfoEn._(_root);
	late final _StringsAccountDetailPagePasswordEn password = _StringsAccountDetailPagePasswordEn._(_root);
}

// Path: memoLibraryPage
class _StringsMemoLibraryPageEn {
	_StringsMemoLibraryPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Memos';
}

// Path: mediaDetailPage
class _StringsMediaDetailPageEn {
	_StringsMediaDetailPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get playAll => 'Play All Memos';
	String get stopPlayAll => 'Stop Auto Play';
	late final _StringsMediaDetailPageTranscriptEn transcript = _StringsMediaDetailPageTranscriptEn._(_root);
	late final _StringsMediaDetailPageRenameEn rename = _StringsMediaDetailPageRenameEn._(_root);
	String get noMediaError => 'Can not find the media file. You can re-import it.';
	late final _StringsMediaDetailPageAppBarActionsEn appBarActions = _StringsMediaDetailPageAppBarActionsEn._(_root);
	String get limitationReachedHint => 'Upgrade to Plus subscription to add more memoes.';
	String get startCaptureBtn => 'Start Capture';
	String get loopModeSwitch => 'Set loop mode';
	String get optionsBtn => 'Options';
	String get loopBtn => 'Loop';
	late final _StringsMediaDetailPageOptionsEn options = _StringsMediaDetailPageOptionsEn._(_root);
	late final _StringsMediaDetailPageCaptureHintEn captureHint = _StringsMediaDetailPageCaptureHintEn._(_root);
	late final _StringsMediaDetailPageShareEn share = _StringsMediaDetailPageShareEn._(_root);
}

// Path: statisticTab
class _StringsStatisticTabEn {
	_StringsStatisticTabEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Statistic';
	String get deleteConfirm => 'Are you sure you want to delete this thing?';
	String get noDataHint => 'No enough data yet.';
	String get totalBookmark => 'Total Memos';
	String get totalReview => 'Total Reviews';
	List<String> get quotes => [
		'The beautiful thing about learning is that no one can take it away from you.',
		'Learning never exhausts the mind, it only ignites it.',
		'The more you learn, the more you\'ll realize how much you don\'t know.',
		'Live as if you were to die tomorrow. Learn as if you were to live forever.',
		'The only thing that is constant is learning. Embrace the journey.',
		'Your future depends on what you learn today. Make the most of it.',
		'Learning is an endless journey that opens new doors and opportunities.',
		'The more you learn, the more places you\'ll go. Keep exploring.',
		'Ignite your curiosity and fuel your passion for learning. The sky is the limit.',
		'Learn, grow, succeed. Repeat.',
	];
}

// Path: reviewTab
class _StringsReviewTabEn {
	_StringsReviewTabEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Review';
	String get weekCheck => 'This Week';
	String get dayCheck => 'Today';
	String get comparedWithLastWeek => 'Than last week';
	String get emptyHint => 'No bookmarks yet.';
	String get playAnwser => 'Play the anwser';
}

// Path: moreTab
class _StringsMoreTabEn {
	_StringsMoreTabEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'More';
	String get lifetime => 'Lifetime';
	late final _StringsMoreTabGeneralEn general = _StringsMoreTabGeneralEn._(_root);
	late final _StringsMoreTabPriviligeEn privilige = _StringsMoreTabPriviligeEn._(_root);
	late final _StringsMoreTabActionsEn actions = _StringsMoreTabActionsEn._(_root);
}

// Path: aboutPage
class _StringsAboutPageEn {
	_StringsAboutPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'About';
	String get tagline => 'Designed and Created by';
	String get author => 'RiverTwilight';
}

// Path: purchasePage
class _StringsPurchasePageEn {
	_StringsPurchasePageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Membership';
	String get restore => 'Restore Purchase';
	late final _StringsPurchasePageIntroEn intro = _StringsPurchasePageIntroEn._(_root);
	String get loginHint => 'For your peace of mind, logging in before purchasing a membership ensures that your payment is correctly allocated to your account. It also safeguards your membership privileges against any unexpected loss.';
	String get introTitle => 'Record Faster, Learn Faster.';
	String get introBody => 'Our mission is to bring everyone better education resource. While basic plan can meet most leaner\'s demand, you can try TalkReel Plus to gain a better, faster learning experience, and 8 special features.';
	late final _StringsPurchasePageFeaturesEn features = _StringsPurchasePageFeaturesEn._(_root);
	late final _StringsPurchasePageRedeemEn redeem = _StringsPurchasePageRedeemEn._(_root);
	String get unlimited => 'Unlimited';
	String get alreadyPurchasedHint => 'You are already a Plus member.';
	late final _StringsPurchasePagePurchaseHintEn purchaseHint = _StringsPurchasePagePurchaseHintEn._(_root);
}

// Path: newMediaPage
class _StringsNewMediaPageEn {
	_StringsNewMediaPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Add to Library';
	String get customTab => 'Custom';
	String get onlineTab => 'Online';
	String get finishImport => 'Imported Successfully';
	String get importError => 'An error occured. Don\'t worry, it\'s not your fault.';
	late final _StringsNewMediaPageSourceEn source = _StringsNewMediaPageSourceEn._(_root);
	late final _StringsNewMediaPagePermissionEn permission = _StringsNewMediaPagePermissionEn._(_root);
	late final _StringsNewMediaPageYoutubeEn youtube = _StringsNewMediaPageYoutubeEn._(_root);
	late final _StringsNewMediaPageCreateCollectionEn createCollection = _StringsNewMediaPageCreateCollectionEn._(_root);
	String get tedFile => 'Select the downloaded file...';
	String get tedHelpBtn => 'How to download TED video?';
	String get remoteFileHint => 'You can add your favorite podcast show or video with URL. ClipMemo will not download them to your device.';
	String get bilibiliHint => 'You can get the link by tapping the Share button on video page of Bilibili APP. On your PC or Mac, you can directly copy content of the address bar.';
	String get youtubeHint => 'You can get the link by tapping the Share button on video page of YouTube APP.  On desktop you can directly copy content of the address bar.';
}

// Path: bookmarkDetailPage
class _StringsBookmarkDetailPageEn {
	_StringsBookmarkDetailPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Edit Memo';
	String get deleteStr => 'Delete Memo';
	String get noNoteHint => 'Tap Edit to start take notes down.';
	late final _StringsBookmarkDetailPageTagEn tag = _StringsBookmarkDetailPageTagEn._(_root);
	String get deleteConfirmTitle => 'Delete this bookmark';
	String get deleteConfirm => 'Are you sure you want to delete this bookmark?';
}

// Path: settingsPage
class _StringsSettingsPageEn {
	_StringsSettingsPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Settings';
	late final _StringsSettingsPageAccountEn account = _StringsSettingsPageAccountEn._(_root);
	late final _StringsSettingsPageGeneralEn general = _StringsSettingsPageGeneralEn._(_root);
	late final _StringsSettingsPageDataEn data = _StringsSettingsPageDataEn._(_root);
	String get termOfUse => 'Term of Use';
}

// Path: searchPage
class _StringsSearchPageEn {
	_StringsSearchPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get inputHint => 'Search Anything...';
}

// Path: backupPage
class _StringsBackupPageEn {
	_StringsBackupPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Backup';
	String get backupSubtitle => 'Store your data to the iCloud';
	String get restore => 'Restore';
	String get backup => 'Backup';
	String get csv => 'Export CSV';
	String get hint => 'The media file cannot be synced. You can re-link media source after restoreing the data.';
	String get fromiCloud => 'From iCloud';
	String get fromLocal => 'Local';
	String get downloadFinish => 'Download completed';
	String get uploadFinish => 'Upload completed';
}

// Path: loginPage
class _StringsLoginPageEn {
	_StringsLoginPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Login';
	String get noAccount => 'I do not have an account';
	String get forget => 'I forget my password';
	String get passwordValid => 'Please enter your password';
	String get emailValid => 'Please enter your email';
	String get errorPrefix => 'Failed to login: ';
}

// Path: signupPage
class _StringsSignupPageEn {
	_StringsSignupPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Sign Up';
	String get passwordConfirm => 'Confirm Password';
	String get passwordConfirmValid => 'Please confirm your password';
	String get haveAccount => 'I already have an account';
	String get notMatch => 'Passwords do not match';
	String get errorPrefix => 'Failed to sign up: ';
}

// Path: langugaePage
class _StringsLangugaePageEn {
	_StringsLangugaePageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Language';
	late final _StringsLangugaePageLocalizedLanguageNameEn localizedLanguageName = _StringsLangugaePageLocalizedLanguageNameEn._(_root);
}

// Path: dialog
class _StringsDialogEn {
	_StringsDialogEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	late final _StringsDialogContactEn contact = _StringsDialogContactEn._(_root);
	late final _StringsDialogAddBilibiliErrorEn addBilibiliError = _StringsDialogAddBilibiliErrorEn._(_root);
	late final _StringsDialogRenameBookmarkEn renameBookmark = _StringsDialogRenameBookmarkEn._(_root);
	late final _StringsDialogIntroductionEn introduction = _StringsDialogIntroductionEn._(_root);
}

// Path: links
class _StringsLinksEn {
	_StringsLinksEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get root => 'https://www.ygeeker.com/support/clipmemo';
	String get privacy => '/legal/privacy';
	String get tips => '/intro';
	String get term => '/legal/term-of-use';
	String get ted => '/tutorial-basics/import-from-ted';
	String get wechatTutoral => '/tutorial-basics/import-from-wechat';
}

// Path: mediaLibraryTab.sortMethod
class _StringsMediaLibraryTabSortMethodEn {
	_StringsMediaLibraryTabSortMethodEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get name => 'Sort by Name';
	String get recent => 'Recently';
	String get date => 'Sort by Date';
}

// Path: accountDetailPage.info
class _StringsAccountDetailPageInfoEn {
	_StringsAccountDetailPageInfoEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Info';
}

// Path: accountDetailPage.password
class _StringsAccountDetailPagePasswordEn {
	_StringsAccountDetailPagePasswordEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get oldPwd => 'Old Password';
	String get newPwd => 'New Password';
}

// Path: mediaDetailPage.transcript
class _StringsMediaDetailPageTranscriptEn {
	_StringsMediaDetailPageTranscriptEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get startBtn => 'Start';
	String get transcribingStr => 'Transcribing';
	String get tip => 'Larger file make take longer time.';
	String get localLimitationHint => 'Only local media file can be transcribed';
}

// Path: mediaDetailPage.rename
class _StringsMediaDetailPageRenameEn {
	_StringsMediaDetailPageRenameEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get confirmBtn => 'Rename';
	String get label => 'New Name';
}

// Path: mediaDetailPage.appBarActions
class _StringsMediaDetailPageAppBarActionsEn {
	_StringsMediaDetailPageAppBarActionsEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get transcribe => 'Transcribe';
	String get replace => 'Replace Media';
}

// Path: mediaDetailPage.options
class _StringsMediaDetailPageOptionsEn {
	_StringsMediaDetailPageOptionsEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get mediaSource => 'Media Source: ';
	String get speed => 'Speed: ';
	String get autoRestore => 'Auto Restore Last Played Position';
	String get danmuku => 'Danmuku';
}

// Path: mediaDetailPage.captureHint
class _StringsMediaDetailPageCaptureHintEn {
	_StringsMediaDetailPageCaptureHintEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'What to capture?';
	String get expression => 'Difficult or new phrase/slangs';
	String get phrase => 'Graph, List or Mindmap';
	String get anything => 'Anything you like';
}

// Path: mediaDetailPage.share
class _StringsMediaDetailPageShareEn {
	_StringsMediaDetailPageShareEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Share';
	late final _StringsMediaDetailPageSharePublishToStoreEn publishToStore = _StringsMediaDetailPageSharePublishToStoreEn._(_root);
	late final _StringsMediaDetailPageShareExportEn export = _StringsMediaDetailPageShareExportEn._(_root);
}

// Path: moreTab.general
class _StringsMoreTabGeneralEn {
	_StringsMoreTabGeneralEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'General';
	String get feedback => 'Feedback';
	String get feedbackIntro => 'We need you!';
	String get about => 'About';
	String get aboutIntro => 'Find the author and his more helpful products.';
	String get check101 => 'ClipMemo 101';
	String get check101Intro => 'Get Tips & Tricks';
	String get brightness => 'Brightness';
	late final _StringsMoreTabGeneralBrightnessOptionsEn brightnessOptions = _StringsMoreTabGeneralBrightnessOptionsEn._(_root);
	String get color => 'Color';
	late final _StringsMoreTabGeneralColorOptionsEn colorOptions = _StringsMoreTabGeneralColorOptionsEn._(_root);
	String get language => 'Language';
	late final _StringsMoreTabGeneralLanguageOptionsEn languageOptions = _StringsMoreTabGeneralLanguageOptionsEn._(_root);
}

// Path: moreTab.privilige
class _StringsMoreTabPriviligeEn {
	_StringsMoreTabPriviligeEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get review => 'Review';
	String get unlimited => 'Unlimited';
	String get sync => 'Sync';
}

// Path: moreTab.actions
class _StringsMoreTabActionsEn {
	_StringsMoreTabActionsEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get rate => 'Rate us';
	String get sync => 'Backup & Restore';
	String get settings => 'Settings';
}

// Path: purchasePage.intro
class _StringsPurchasePageIntroEn {
	_StringsPurchasePageIntroEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get review => 'Get progress faster with Daily Review.';
	String get sync => 'Access your notes and media across devices.';
	String get unlimited => 'Add unlimited media and bookmarks.';
}

// Path: purchasePage.features
class _StringsPurchasePageFeaturesEn {
	_StringsPurchasePageFeaturesEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get cloudSync => 'Cloud sync';
	String get note => 'Note';
	String get review => 'Daily Review';
	String get tag => 'Tag System';
	String get bookmark => 'Bookmark';
	String get transcribe => 'Auto Transcribe';
	String get speed => 'Playback Speed';
	String get media => 'Media';
	String get loop => 'Loop';
	String get theme => 'Theme Color';
}

// Path: purchasePage.redeem
class _StringsPurchasePageRedeemEn {
	_StringsPurchasePageRedeemEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Redeem';
	String get dialogTitle => 'Redeem Offer Code';
	String get redeemSuccessHint => 'Redeem Successfully.';
}

// Path: purchasePage.purchaseHint
class _StringsPurchasePagePurchaseHintEn {
	_StringsPurchasePagePurchaseHintEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get beforePolicy => 'Please check our ';
	String get policy => 'policy';
	String get afterPolicy => ' before purchasing. If you didn\'t receive your purchase, please ';
	String get contact => 'contact us';
	String get afterContact => ' at here.';
}

// Path: newMediaPage.source
class _StringsNewMediaPageSourceEn {
	_StringsNewMediaPageSourceEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get youtube => 'YouTube';
	String get bilibili => 'Bilibili';
	String get wechat => 'WeChat';
	String get ted => 'TED';
	String get localVideo => 'Video';
	String get localAudio => 'Audio';
	String get directUrl => 'Source URL';
}

// Path: newMediaPage.permission
class _StringsNewMediaPagePermissionEn {
	_StringsNewMediaPagePermissionEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Unlock More Features!';
	String get body => 'Looks like you\'ve been enjoying our app! To add more videos, consider upgrading to our Plus plan.';
	String get upgrade => 'Learn More';
}

// Path: newMediaPage.youtube
class _StringsNewMediaPageYoutubeEn {
	_StringsNewMediaPageYoutubeEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get fetchTitle => 'Auto-fetch Title';
}

// Path: newMediaPage.createCollection
class _StringsNewMediaPageCreateCollectionEn {
	_StringsNewMediaPageCreateCollectionEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'New Collection';
}

// Path: bookmarkDetailPage.tag
class _StringsBookmarkDetailPageTagEn {
	_StringsBookmarkDetailPageTagEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get btn => 'Add tag';
	String get dialogTitle => 'Add New Tag';
	String get inputHint => 'Enter tag';
}

// Path: settingsPage.account
class _StringsSettingsPageAccountEn {
	_StringsSettingsPageAccountEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Account';
	late final _StringsSettingsPageAccountDeleteAccountEn deleteAccount = _StringsSettingsPageAccountDeleteAccountEn._(_root);
	String get logout => 'Log out';
	String get login => 'Log in...';
	String get details => 'Account Details';
}

// Path: settingsPage.general
class _StringsSettingsPageGeneralEn {
	_StringsSettingsPageGeneralEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'General';
	String get brightness => 'Brightness';
	late final _StringsSettingsPageGeneralBrightnessOptionsEn brightnessOptions = _StringsSettingsPageGeneralBrightnessOptionsEn._(_root);
	String get color => 'Color';
	late final _StringsSettingsPageGeneralColorOptionsEn colorOptions = _StringsSettingsPageGeneralColorOptionsEn._(_root);
	String get language => 'Language';
	late final _StringsSettingsPageGeneralLanguageOptionsEn languageOptions = _StringsSettingsPageGeneralLanguageOptionsEn._(_root);
}

// Path: settingsPage.data
class _StringsSettingsPageDataEn {
	_StringsSettingsPageDataEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Data';
	String get clean => 'Clean';
	String get clear => 'Clear all data';
	String get confirmTitle => 'Confirm Wipe';
	String get confirmBody => 'Are you sure you want to wipe all local data';
	String get finishHint => 'Data wiped. Restart the app to take effect.';
}

// Path: langugaePage.localizedLanguageName
class _StringsLangugaePageLocalizedLanguageNameEn {
	_StringsLangugaePageLocalizedLanguageNameEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get enUS => 'English (US)';
	String get enGB => 'English (UK)';
	String get fr => 'French';
	String get ko => 'Korean';
	String get jp => 'Japanese';
	String get zhCN => 'Chinese (China Mainland)';
	String get zhHK => 'Chinese (Hong Kong)';
}

// Path: dialog.contact
class _StringsDialogContactEn {
	_StringsDialogContactEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get replayTime => 'You\'ll get a reply in 2 business days';
	String get wechat => 'WeChat';
	String get red => 'RED';
	String get wechatCopied => 'WeChat ID copied';
	String get redCopied => 'RED ID copied';
	String get emailCopied => 'Email address copied';
}

// Path: dialog.addBilibiliError
class _StringsDialogAddBilibiliErrorEn {
	_StringsDialogAddBilibiliErrorEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Invalid Url';
	String get body => 'Try remove extra text and input pure url. Currently, we cannot import episode from bilibili.';
}

// Path: dialog.renameBookmark
class _StringsDialogRenameBookmarkEn {
	_StringsDialogRenameBookmarkEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Give a Title';
}

// Path: dialog.introduction
class _StringsDialogIntroductionEn {
	_StringsDialogIntroductionEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	late final _StringsDialogIntroductionPage2En page_2 = _StringsDialogIntroductionPage2En._(_root);
	late final _StringsDialogIntroductionPage3En page_3 = _StringsDialogIntroductionPage3En._(_root);
}

// Path: mediaDetailPage.share.publishToStore
class _StringsMediaDetailPageSharePublishToStoreEn {
	_StringsMediaDetailPageSharePublishToStoreEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Publish to online showcase';
	String get body => '';
}

// Path: mediaDetailPage.share.export
class _StringsMediaDetailPageShareExportEn {
	_StringsMediaDetailPageShareExportEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Export to file';
	String get body => '';
}

// Path: moreTab.general.brightnessOptions
class _StringsMoreTabGeneralBrightnessOptionsEn {
	_StringsMoreTabGeneralBrightnessOptionsEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get system => 'System';
	String get dark => 'Dark';
	String get light => 'Light';
}

// Path: moreTab.general.colorOptions
class _StringsMoreTabGeneralColorOptionsEn {
	_StringsMoreTabGeneralColorOptionsEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get system => 'System';
}

// Path: moreTab.general.languageOptions
class _StringsMoreTabGeneralLanguageOptionsEn {
	_StringsMoreTabGeneralLanguageOptionsEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get system => 'System';
}

// Path: settingsPage.account.deleteAccount
class _StringsSettingsPageAccountDeleteAccountEn {
	_StringsSettingsPageAccountDeleteAccountEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Delete Account...';
	String get confirmTitle => 'Confirm Delete';
	String get confirmBody => 'Are you sure you want to delete your account? This cannot be undone.';
}

// Path: settingsPage.general.brightnessOptions
class _StringsSettingsPageGeneralBrightnessOptionsEn {
	_StringsSettingsPageGeneralBrightnessOptionsEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get system => 'System';
	String get dark => 'Dark';
	String get light => 'Light';
}

// Path: settingsPage.general.colorOptions
class _StringsSettingsPageGeneralColorOptionsEn {
	_StringsSettingsPageGeneralColorOptionsEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get system => 'System';
	String get purple => 'Purple';
	String get brown => 'Brown';
	String get blue => 'Blue';
	String get green => 'Green';
	String get yellow => 'Yellow';
}

// Path: settingsPage.general.languageOptions
class _StringsSettingsPageGeneralLanguageOptionsEn {
	_StringsSettingsPageGeneralLanguageOptionsEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get system => 'System';
}

// Path: dialog.introduction.page_2
class _StringsDialogIntroductionPage2En {
	_StringsDialogIntroductionPage2En._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'See how ClipMemo can help you';
	late final _StringsDialogIntroductionPage2Feature1En feature_1 = _StringsDialogIntroductionPage2Feature1En._(_root);
	late final _StringsDialogIntroductionPage2Feature2En feature_2 = _StringsDialogIntroductionPage2Feature2En._(_root);
	late final _StringsDialogIntroductionPage2Feature3En feature_3 = _StringsDialogIntroductionPage2Feature3En._(_root);
	String get footer => 'That\'s why we created ClipMemo.\n It allow you to bookmark video & podcast just like books.';
}

// Path: dialog.introduction.page_3
class _StringsDialogIntroductionPage3En {
	_StringsDialogIntroductionPage3En._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Lets get started';
	String get body => 'Don\'t worry. We\'ve created some example for you.';
}

// Path: dialog.introduction.page_2.feature_1
class _StringsDialogIntroductionPage2Feature1En {
	_StringsDialogIntroductionPage2Feature1En._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Learn spoken language';
	String get body => 'Save best clips from your favorite episode and movies, or YouTube video you like.';
}

// Path: dialog.introduction.page_2.feature_2
class _StringsDialogIntroductionPage2Feature2En {
	_StringsDialogIntroductionPage2Feature2En._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Engage video courses';
	String get body => 'Make online learning easier and more effective.';
}

// Path: dialog.introduction.page_2.feature_3
class _StringsDialogIntroductionPage2Feature3En {
	_StringsDialogIntroductionPage2Feature3En._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Bookmark anything you like';
	String get body => 'Let your favorite channel really benefit you.';
}

// Path: <root>
class _StringsZhCn extends _StringsEn {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsZhCn.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.zhCn,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <zh-CN>.
	@override final TranslationMetadata<AppLocale, _StringsEn> $meta;

	@override late final _StringsZhCn _root = this; // ignore: unused_field

	// Translations
	@override String get locale => '简体中文';
	@override String get appName => 'ClipMemo';
	@override late final _StringsGeneralZhCn general = _StringsGeneralZhCn._(_root);
	@override late final _StringsMediaLibraryTabZhCn mediaLibraryTab = _StringsMediaLibraryTabZhCn._(_root);
	@override late final _StringsMemoLibraryPageZhCn memoLibraryPage = _StringsMemoLibraryPageZhCn._(_root);
	@override late final _StringsAccountDetailPageZhCn accountDetailPage = _StringsAccountDetailPageZhCn._(_root);
	@override late final _StringsMediaDetailPageZhCn mediaDetailPage = _StringsMediaDetailPageZhCn._(_root);
	@override late final _StringsStatisticTabZhCn statisticTab = _StringsStatisticTabZhCn._(_root);
	@override late final _StringsReviewTabZhCn reviewTab = _StringsReviewTabZhCn._(_root);
	@override late final _StringsMoreTabZhCn moreTab = _StringsMoreTabZhCn._(_root);
	@override late final _StringsAboutPageZhCn aboutPage = _StringsAboutPageZhCn._(_root);
	@override late final _StringsPurchasePageZhCn purchasePage = _StringsPurchasePageZhCn._(_root);
	@override late final _StringsNewMediaPageZhCn newMediaPage = _StringsNewMediaPageZhCn._(_root);
	@override late final _StringsBookmarkDetailPageZhCn bookmarkDetailPage = _StringsBookmarkDetailPageZhCn._(_root);
	@override late final _StringsSettingsPageZhCn settingsPage = _StringsSettingsPageZhCn._(_root);
	@override late final _StringsSearchPageZhCn searchPage = _StringsSearchPageZhCn._(_root);
	@override late final _StringsBackupPageZhCn backupPage = _StringsBackupPageZhCn._(_root);
	@override late final _StringsLoginPageZhCn loginPage = _StringsLoginPageZhCn._(_root);
	@override late final _StringsSignupPageZhCn signupPage = _StringsSignupPageZhCn._(_root);
	@override late final _StringsLangugaePageZhCn langugaePage = _StringsLangugaePageZhCn._(_root);
	@override late final _StringsDialogZhCn dialog = _StringsDialogZhCn._(_root);
	@override late final _StringsLinksZhCn links = _StringsLinksZhCn._(_root);
}

// Path: general
class _StringsGeneralZhCn extends _StringsGeneralEn {
	_StringsGeneralZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get add => '添加';
	@override String get advanced => '高级';
	@override String get cancel => '取消';
	@override String get close => '关闭';
	@override String get confirm => '确认';
	@override String get continueStr => '继续';
	@override String get copy => '复制';
	@override String get decline => '拒绝';
	@override String get deleteStr => '删除';
	@override String get done => '完成';
	@override String get edit => '编辑';
	@override String get error => '错误';
	@override String get email => '电子邮件';
	@override String get example => '示例';
	@override String get finished => '已完成';
	@override String get hide => '隐藏';
	@override String get next => '下一个';
	@override String get off => '关闭';
	@override String get on => '打开';
	@override String get open => '打开';
	@override String get password => '密码';
	@override String get play => '播放';
	@override String get previous => '上一个';
	@override String get preview => '预览';
	@override String get pause => '暂停';
	@override String get renamed => '已重命名';
	@override String get rename => '重命名';
	@override String get reset => '重置';
	@override String get settings => '设置';
	@override String get start => '开始';
	@override String get stop => '停止';
	@override String get save => '保存';
	@override String get unchanged => '未改变';
	@override String get unknown => '未知';
	@override String get expired => '已过期';
	@override String get nologin => '未登录';
	@override String get view => '查看';
	@override String get learnMore => '了解更多...';
	@override String get language => '语言';
	@override String get noEligibilityHint => '你需要升级到 ClipMemo Plus 来使用此功能。';
}

// Path: mediaLibraryTab
class _StringsMediaLibraryTabZhCn extends _StringsMediaLibraryTabEn {
	_StringsMediaLibraryTabZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get tabName => '媒体库';
	@override String get emptyHint => '暂无媒体，请添加';
	@override late final _StringsMediaLibraryTabSortMethodZhCn sortMethod = _StringsMediaLibraryTabSortMethodZhCn._(_root);
}

// Path: memoLibraryPage
class _StringsMemoLibraryPageZhCn extends _StringsMemoLibraryPageEn {
	_StringsMemoLibraryPageZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Memos';
}

// Path: accountDetailPage
class _StringsAccountDetailPageZhCn extends _StringsAccountDetailPageEn {
	_StringsAccountDetailPageZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '账户';
	@override late final _StringsAccountDetailPageInfoZhCn info = _StringsAccountDetailPageInfoZhCn._(_root);
	@override late final _StringsAccountDetailPagePasswordZhCn password = _StringsAccountDetailPagePasswordZhCn._(_root);
}

// Path: mediaDetailPage
class _StringsMediaDetailPageZhCn extends _StringsMediaDetailPageEn {
	_StringsMediaDetailPageZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get playAll => '播放所有 Memo';
	@override String get stopPlayAll => '停止自动播放';
	@override late final _StringsMediaDetailPageTranscriptZhCn transcript = _StringsMediaDetailPageTranscriptZhCn._(_root);
	@override late final _StringsMediaDetailPageRenameZhCn rename = _StringsMediaDetailPageRenameZhCn._(_root);
	@override String get noMediaError => '找不到媒体文件。你可以重新导入。';
	@override late final _StringsMediaDetailPageAppBarActionsZhCn appBarActions = _StringsMediaDetailPageAppBarActionsZhCn._(_root);
	@override String get limitationReachedHint => '升级到 Plus 订阅以添加更多 Memo。';
	@override String get startCaptureBtn => '开始截取';
	@override String get loopModeSwitch => '设置循环模式';
	@override String get optionsBtn => '选项';
	@override String get loopBtn => '循环';
	@override late final _StringsMediaDetailPageOptionsZhCn options = _StringsMediaDetailPageOptionsZhCn._(_root);
	@override late final _StringsMediaDetailPageCaptureHintZhCn captureHint = _StringsMediaDetailPageCaptureHintZhCn._(_root);
	@override late final _StringsMediaDetailPageShareZhCn share = _StringsMediaDetailPageShareZhCn._(_root);
}

// Path: statisticTab
class _StringsStatisticTabZhCn extends _StringsStatisticTabEn {
	_StringsStatisticTabZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '统计';
	@override String get deleteConfirm => '你确定要删除此项吗？';
	@override String get noDataHint => '尚无足够数据。';
	@override String get totalBookmark => '书签数量';
	@override String get totalReview => '复习次数';
	@override List<String> get quotes => [
		'学习的美好之处在于，没有人能夺走它。',
		'学习永不会耗尽心智，它只会点燃它。',
		'你学得越多，你就越意识到你不知道的有多少。',
		'生活就像你明天就要死去。学习就像你将永远活着。',
		'唯一不变的事物是学习。',
		'你的未来取决于你今天学到的东西。充分利用它。',
		'学习是一次永无止境的旅程，为你打开新的大门和机会。',
		'你学得越多，你走的地方就越多。继续探索。',
		'点燃你的好奇心，激发你对学习的热情。天空是极限。',
		'学习，成长，成功。重复。',
	];
}

// Path: reviewTab
class _StringsReviewTabZhCn extends _StringsReviewTabEn {
	_StringsReviewTabZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '回顾';
	@override String get weekCheck => '本周';
	@override String get dayCheck => '今天';
	@override String get comparedWithLastWeek => '比上周';
	@override String get emptyHint => '暂无书签。';
	@override String get playAnwser => '查看答案';
}

// Path: moreTab
class _StringsMoreTabZhCn extends _StringsMoreTabEn {
	_StringsMoreTabZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '更多';
	@override String get lifetime => '永久';
	@override late final _StringsMoreTabGeneralZhCn general = _StringsMoreTabGeneralZhCn._(_root);
	@override late final _StringsMoreTabPriviligeZhCn privilige = _StringsMoreTabPriviligeZhCn._(_root);
	@override late final _StringsMoreTabActionsZhCn actions = _StringsMoreTabActionsZhCn._(_root);
}

// Path: aboutPage
class _StringsAboutPageZhCn extends _StringsAboutPageEn {
	_StringsAboutPageZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '关于';
	@override String get tagline => '设计 & 开发';
	@override String get author => 'RiverTwilight';
}

// Path: purchasePage
class _StringsPurchasePageZhCn extends _StringsPurchasePageEn {
	_StringsPurchasePageZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '会员';
	@override String get restore => '恢复购买';
	@override late final _StringsPurchasePageIntroZhCn intro = _StringsPurchasePageIntroZhCn._(_root);
	@override String get loginHint => '为了你的安心，请在购买会员之前登录，以确保你能拥有购买内容。它还保护你的会员特权免受任何意外损失。';
	@override String get introTitle => '更快录制，更快学习。';
	@override String get introBody => '我们的使命是为每个人带来更好的教育资源。虽然基本计划可以满足大多数学习者的需求，但你可以尝试 TalkReel Plus 以获得更好、更快的学习体验，以及8个特殊功能。';
	@override late final _StringsPurchasePageFeaturesZhCn features = _StringsPurchasePageFeaturesZhCn._(_root);
	@override late final _StringsPurchasePageRedeemZhCn redeem = _StringsPurchasePageRedeemZhCn._(_root);
	@override String get unlimited => '不限制';
	@override String get alreadyPurchasedHint => '你已经是 Plus 会员了。';
	@override late final _StringsPurchasePagePurchaseHintZhCn purchaseHint = _StringsPurchasePagePurchaseHintZhCn._(_root);
}

// Path: newMediaPage
class _StringsNewMediaPageZhCn extends _StringsNewMediaPageEn {
	_StringsNewMediaPageZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '添加到库';
	@override String get customTab => '自定义';
	@override String get onlineTab => '在线';
	@override String get finishImport => '成功导入';
	@override String get importError => '发生了错误。别担心，这不是你的错。';
	@override late final _StringsNewMediaPageSourceZhCn source = _StringsNewMediaPageSourceZhCn._(_root);
	@override late final _StringsNewMediaPagePermissionZhCn permission = _StringsNewMediaPagePermissionZhCn._(_root);
	@override late final _StringsNewMediaPageYoutubeZhCn youtube = _StringsNewMediaPageYoutubeZhCn._(_root);
	@override late final _StringsNewMediaPageCreateCollectionZhCn createCollection = _StringsNewMediaPageCreateCollectionZhCn._(_root);
	@override String get tedFile => '选择已下载的文件...';
	@override String get tedHelpBtn => '如何下载TED视频？';
	@override String get remoteFileHint => '你可以通过输入链接来添加播客节目或者视频文件。ClipMemo 不会下载文件到本地。';
	@override String get bilibiliHint => '轻触 Bilibili 客户端播放页面中的“分享”图标来获取视频链接，或者轻触分享页面的“更多”按钮直接分享到 ClipMemo。在 PC 或者 Mac 上，复制地址栏的文本即可获取链接。';
	@override String get youtubeHint => '轻触 YouTube 客户端播放页面中的“分享”图标来获取视频链接。在 PC 或者 Mac 上，复制地址栏的文本即可获取链接。';
}

// Path: bookmarkDetailPage
class _StringsBookmarkDetailPageZhCn extends _StringsBookmarkDetailPageEn {
	_StringsBookmarkDetailPageZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '编辑书签';
	@override String get deleteStr => '删除书签';
	@override String get noNoteHint => '点击“编辑”开始记笔记。';
	@override late final _StringsBookmarkDetailPageTagZhCn tag = _StringsBookmarkDetailPageTagZhCn._(_root);
	@override String get deleteConfirmTitle => '删除便签';
	@override String get deleteConfirm => '你确定要删除此项吗？';
}

// Path: settingsPage
class _StringsSettingsPageZhCn extends _StringsSettingsPageEn {
	_StringsSettingsPageZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '设置';
	@override late final _StringsSettingsPageAccountZhCn account = _StringsSettingsPageAccountZhCn._(_root);
	@override late final _StringsSettingsPageGeneralZhCn general = _StringsSettingsPageGeneralZhCn._(_root);
	@override late final _StringsSettingsPageDataZhCn data = _StringsSettingsPageDataZhCn._(_root);
	@override String get termOfUse => '使用协议';
}

// Path: searchPage
class _StringsSearchPageZhCn extends _StringsSearchPageEn {
	_StringsSearchPageZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get inputHint => '搜索任何内容...';
}

// Path: backupPage
class _StringsBackupPageZhCn extends _StringsBackupPageEn {
	_StringsBackupPageZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '备份';
	@override String get backupSubtitle => '将你的数据存储到 iCloud';
	@override String get restore => '恢复';
	@override String get backup => '备份';
	@override String get csv => '导出 CSV';
	@override String get hint => '媒体文件无法同步。你可以在恢复数据后重新链接媒体源。';
	@override String get fromiCloud => 'iCloud';
	@override String get fromLocal => '本地';
	@override String get downloadFinish => '下载完成';
	@override String get uploadFinish => '上传完成';
}

// Path: loginPage
class _StringsLoginPageZhCn extends _StringsLoginPageEn {
	_StringsLoginPageZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '登录';
	@override String get noAccount => '我没有帐户';
	@override String get forget => '我忘记了密码';
	@override String get passwordValid => '请输入你的密码';
	@override String get emailValid => '请输入你的电子邮件';
	@override String get errorPrefix => '登录失败：';
}

// Path: signupPage
class _StringsSignupPageZhCn extends _StringsSignupPageEn {
	_StringsSignupPageZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '注册';
	@override String get passwordConfirm => '确认密码';
	@override String get passwordConfirmValid => '请确认你的密码';
	@override String get haveAccount => '我已经有一个帐户';
	@override String get notMatch => '密码不匹配';
	@override String get errorPrefix => '注册失败：';
}

// Path: langugaePage
class _StringsLangugaePageZhCn extends _StringsLangugaePageEn {
	_StringsLangugaePageZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '语言';
	@override late final _StringsLangugaePageLocalizedLanguageNameZhCn localizedLanguageName = _StringsLangugaePageLocalizedLanguageNameZhCn._(_root);
}

// Path: dialog
class _StringsDialogZhCn extends _StringsDialogEn {
	_StringsDialogZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override late final _StringsDialogContactZhCn contact = _StringsDialogContactZhCn._(_root);
	@override late final _StringsDialogAddBilibiliErrorZhCn addBilibiliError = _StringsDialogAddBilibiliErrorZhCn._(_root);
	@override late final _StringsDialogRenameBookmarkZhCn renameBookmark = _StringsDialogRenameBookmarkZhCn._(_root);
	@override late final _StringsDialogIntroductionZhCn introduction = _StringsDialogIntroductionZhCn._(_root);
}

// Path: links
class _StringsLinksZhCn extends _StringsLinksEn {
	_StringsLinksZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get root => 'https://www.ygeeker.com/zh-CN/support/clipmemo';
	@override String get privacy => '/legal/privacy';
	@override String get tips => '/intro';
	@override String get term => '/legal/term-of-use';
	@override String get ted => '/tutorial-basics/import-from-ted';
	@override String get wechatTutoral => '/tutorial-basics/import-from-wechat';
}

// Path: mediaLibraryTab.sortMethod
class _StringsMediaLibraryTabSortMethodZhCn extends _StringsMediaLibraryTabSortMethodEn {
	_StringsMediaLibraryTabSortMethodZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get name => '按名称排序';
	@override String get recent => '最近';
	@override String get date => '按日期排序';
}

// Path: accountDetailPage.info
class _StringsAccountDetailPageInfoZhCn extends _StringsAccountDetailPageInfoEn {
	_StringsAccountDetailPageInfoZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '属性';
}

// Path: accountDetailPage.password
class _StringsAccountDetailPagePasswordZhCn extends _StringsAccountDetailPagePasswordEn {
	_StringsAccountDetailPagePasswordZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get oldPwd => '旧密码';
	@override String get newPwd => '新密码';
}

// Path: mediaDetailPage.transcript
class _StringsMediaDetailPageTranscriptZhCn extends _StringsMediaDetailPageTranscriptEn {
	_StringsMediaDetailPageTranscriptZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get startBtn => '开始';
	@override String get transcribingStr => '转录中';
	@override String get tip => '较大的文件可能需要更长的时间。';
	@override String get localLimitationHint => '仅支持转录本地音视频文件';
}

// Path: mediaDetailPage.rename
class _StringsMediaDetailPageRenameZhCn extends _StringsMediaDetailPageRenameEn {
	_StringsMediaDetailPageRenameZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get confirmBtn => '重命名';
	@override String get label => '新名称';
}

// Path: mediaDetailPage.appBarActions
class _StringsMediaDetailPageAppBarActionsZhCn extends _StringsMediaDetailPageAppBarActionsEn {
	_StringsMediaDetailPageAppBarActionsZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get transcribe => '转录';
	@override String get replace => '替换媒体';
}

// Path: mediaDetailPage.options
class _StringsMediaDetailPageOptionsZhCn extends _StringsMediaDetailPageOptionsEn {
	_StringsMediaDetailPageOptionsZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get mediaSource => '媒体来源：';
	@override String get speed => '速度：';
	@override String get autoRestore => '自动恢复上次播放位置';
	@override String get danmuku => '弹幕';
}

// Path: mediaDetailPage.captureHint
class _StringsMediaDetailPageCaptureHintZhCn extends _StringsMediaDetailPageCaptureHintEn {
	_StringsMediaDetailPageCaptureHintZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '截取什么？';
	@override String get expression => '困难或新的词汇/俚语/表达';
	@override String get phrase => '图表、划重点或者思维导图';
	@override String get anything => '你想保存的任何东西';
}

// Path: mediaDetailPage.share
class _StringsMediaDetailPageShareZhCn extends _StringsMediaDetailPageShareEn {
	_StringsMediaDetailPageShareZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '分享';
	@override late final _StringsMediaDetailPageSharePublishToStoreZhCn publishToStore = _StringsMediaDetailPageSharePublishToStoreZhCn._(_root);
	@override late final _StringsMediaDetailPageShareExportZhCn export = _StringsMediaDetailPageShareExportZhCn._(_root);
}

// Path: moreTab.general
class _StringsMoreTabGeneralZhCn extends _StringsMoreTabGeneralEn {
	_StringsMoreTabGeneralZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '通用';
	@override String get feedback => '反馈';
	@override String get feedbackIntro => '我们需要你！';
	@override String get about => '关于';
	@override String get aboutIntro => '和作者聊聊，看看他的更多作品。';
	@override String get check101 => '前往 ClipMemo 学院';
	@override String get check101Intro => '获取提示和帮助';
	@override String get brightness => '亮度';
	@override late final _StringsMoreTabGeneralBrightnessOptionsZhCn brightnessOptions = _StringsMoreTabGeneralBrightnessOptionsZhCn._(_root);
	@override String get color => '颜色';
	@override late final _StringsMoreTabGeneralColorOptionsZhCn colorOptions = _StringsMoreTabGeneralColorOptionsZhCn._(_root);
	@override String get language => '语言';
	@override late final _StringsMoreTabGeneralLanguageOptionsZhCn languageOptions = _StringsMoreTabGeneralLanguageOptionsZhCn._(_root);
}

// Path: moreTab.privilige
class _StringsMoreTabPriviligeZhCn extends _StringsMoreTabPriviligeEn {
	_StringsMoreTabPriviligeZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get review => '回顾';
	@override String get unlimited => '不限制';
	@override String get sync => '同步';
}

// Path: moreTab.actions
class _StringsMoreTabActionsZhCn extends _StringsMoreTabActionsEn {
	_StringsMoreTabActionsZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get rate => '给我们评分';
	@override String get sync => '备份与恢复';
	@override String get settings => '设置';
}

// Path: purchasePage.intro
class _StringsPurchasePageIntroZhCn extends _StringsPurchasePageIntroEn {
	_StringsPurchasePageIntroZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get review => '通过每日回顾更快地取得进步。';
	@override String get sync => '在不同设备之间访问你的笔记和媒体。';
	@override String get unlimited => '添加无限媒体和书签。';
}

// Path: purchasePage.features
class _StringsPurchasePageFeaturesZhCn extends _StringsPurchasePageFeaturesEn {
	_StringsPurchasePageFeaturesZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get cloudSync => '云同步';
	@override String get note => '笔记';
	@override String get review => '每日回顾';
	@override String get tag => '标签系统';
	@override String get bookmark => '书签';
	@override String get transcribe => '自动转录';
	@override String get speed => '播放速度';
	@override String get media => '媒体';
	@override String get loop => '循环';
	@override String get theme => '主题颜色';
}

// Path: purchasePage.redeem
class _StringsPurchasePageRedeemZhCn extends _StringsPurchasePageRedeemEn {
	_StringsPurchasePageRedeemZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '兑换';
	@override String get dialogTitle => '兑换优惠码';
	@override String get redeemSuccessHint => '兑换成功。';
}

// Path: purchasePage.purchaseHint
class _StringsPurchasePagePurchaseHintZhCn extends _StringsPurchasePagePurchaseHintEn {
	_StringsPurchasePagePurchaseHintZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get beforePolicy => '购买前请查看我们的';
	@override String get policy => '政策';
	@override String get afterPolicy => '。如果付款后你的订阅状态没有更新，请凭支付收据截图';
	@override String get contact => '联系我们';
	@override String get afterContact => '。';
}

// Path: newMediaPage.source
class _StringsNewMediaPageSourceZhCn extends _StringsNewMediaPageSourceEn {
	_StringsNewMediaPageSourceZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get youtube => 'YouTube';
	@override String get bilibili => 'Bilibili';
	@override String get wechat => '微信';
	@override String get ted => 'TED';
	@override String get localVideo => '视频';
	@override String get localAudio => '音频';
	@override String get directUrl => '文件链接';
}

// Path: newMediaPage.permission
class _StringsNewMediaPagePermissionZhCn extends _StringsNewMediaPagePermissionEn {
	_StringsNewMediaPagePermissionZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '解锁更多功能！';
	@override String get body => '看来您一直在享受我们的应用！要添加更多视频，请考虑升级到我们的Plus计划。';
	@override String get upgrade => '了解更多';
}

// Path: newMediaPage.youtube
class _StringsNewMediaPageYoutubeZhCn extends _StringsNewMediaPageYoutubeEn {
	_StringsNewMediaPageYoutubeZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get fetchTitle => '自动获取标题';
}

// Path: newMediaPage.createCollection
class _StringsNewMediaPageCreateCollectionZhCn extends _StringsNewMediaPageCreateCollectionEn {
	_StringsNewMediaPageCreateCollectionZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '新建合集';
}

// Path: bookmarkDetailPage.tag
class _StringsBookmarkDetailPageTagZhCn extends _StringsBookmarkDetailPageTagEn {
	_StringsBookmarkDetailPageTagZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get btn => '新增标签';
	@override String get dialogTitle => '添加一个标签';
	@override String get inputHint => '输入标签内容，例如“日语”';
}

// Path: settingsPage.account
class _StringsSettingsPageAccountZhCn extends _StringsSettingsPageAccountEn {
	_StringsSettingsPageAccountZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '帐户';
	@override late final _StringsSettingsPageAccountDeleteAccountZhCn deleteAccount = _StringsSettingsPageAccountDeleteAccountZhCn._(_root);
	@override String get logout => '退出登录';
	@override String get login => '登录...';
	@override String get details => '帐户详细信息';
}

// Path: settingsPage.general
class _StringsSettingsPageGeneralZhCn extends _StringsSettingsPageGeneralEn {
	_StringsSettingsPageGeneralZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '一般';
	@override String get brightness => '亮度';
	@override late final _StringsSettingsPageGeneralBrightnessOptionsZhCn brightnessOptions = _StringsSettingsPageGeneralBrightnessOptionsZhCn._(_root);
	@override String get color => '颜色';
	@override late final _StringsSettingsPageGeneralColorOptionsZhCn colorOptions = _StringsSettingsPageGeneralColorOptionsZhCn._(_root);
	@override String get language => '语言';
	@override late final _StringsSettingsPageGeneralLanguageOptionsZhCn languageOptions = _StringsSettingsPageGeneralLanguageOptionsZhCn._(_root);
}

// Path: settingsPage.data
class _StringsSettingsPageDataZhCn extends _StringsSettingsPageDataEn {
	_StringsSettingsPageDataZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '数据';
	@override String get clean => '清理';
	@override String get clear => '清除所有数据';
	@override String get confirmTitle => '确认擦除';
	@override String get confirmBody => '你确定要擦除所有本地数据吗？此操作不能撤销。';
	@override String get finishHint => '数据已擦除。重新启动应用以生效。';
}

// Path: langugaePage.localizedLanguageName
class _StringsLangugaePageLocalizedLanguageNameZhCn extends _StringsLangugaePageLocalizedLanguageNameEn {
	_StringsLangugaePageLocalizedLanguageNameZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get enUS => '英语（美国）';
	@override String get enGB => '英语（英语）';
	@override String get fr => '法语';
	@override String get ko => '韩语';
	@override String get jp => '日语';
	@override String get zhCN => '中文（中国）';
	@override String get zhHK => '中文（香港）';
}

// Path: dialog.contact
class _StringsDialogContactZhCn extends _StringsDialogContactEn {
	_StringsDialogContactZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get replayTime => '我们会在 2 个工作日内回复你。';
	@override String get wechat => '微信';
	@override String get red => '小红书';
	@override String get wechatCopied => '已复制微信号';
	@override String get redCopied => '已复制小红书 ID。在小红书中搜索此账户即可联系我们。';
	@override String get emailCopied => '已复制邮件';
}

// Path: dialog.addBilibiliError
class _StringsDialogAddBilibiliErrorZhCn extends _StringsDialogAddBilibiliErrorEn {
	_StringsDialogAddBilibiliErrorZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '我们无法处理你输入的链接';
	@override String get body => '试着移除多余的字符。目前，我们不支持导入番剧。';
}

// Path: dialog.renameBookmark
class _StringsDialogRenameBookmarkZhCn extends _StringsDialogRenameBookmarkEn {
	_StringsDialogRenameBookmarkZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '起个名字吧';
}

// Path: dialog.introduction
class _StringsDialogIntroductionZhCn extends _StringsDialogIntroductionEn {
	_StringsDialogIntroductionZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override late final _StringsDialogIntroductionPage2ZhCn page_2 = _StringsDialogIntroductionPage2ZhCn._(_root);
	@override late final _StringsDialogIntroductionPage3ZhCn page_3 = _StringsDialogIntroductionPage3ZhCn._(_root);
}

// Path: mediaDetailPage.share.publishToStore
class _StringsMediaDetailPageSharePublishToStoreZhCn extends _StringsMediaDetailPageSharePublishToStoreEn {
	_StringsMediaDetailPageSharePublishToStoreZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '发布到商店';
	@override String get body => '';
}

// Path: mediaDetailPage.share.export
class _StringsMediaDetailPageShareExportZhCn extends _StringsMediaDetailPageShareExportEn {
	_StringsMediaDetailPageShareExportZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '导出文件';
	@override String get body => '';
}

// Path: moreTab.general.brightnessOptions
class _StringsMoreTabGeneralBrightnessOptionsZhCn extends _StringsMoreTabGeneralBrightnessOptionsEn {
	_StringsMoreTabGeneralBrightnessOptionsZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get system => '跟随系统';
	@override String get dark => '深色模式';
	@override String get light => '浅色模式';
}

// Path: moreTab.general.colorOptions
class _StringsMoreTabGeneralColorOptionsZhCn extends _StringsMoreTabGeneralColorOptionsEn {
	_StringsMoreTabGeneralColorOptionsZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get system => '系统';
}

// Path: moreTab.general.languageOptions
class _StringsMoreTabGeneralLanguageOptionsZhCn extends _StringsMoreTabGeneralLanguageOptionsEn {
	_StringsMoreTabGeneralLanguageOptionsZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get system => '系统';
}

// Path: settingsPage.account.deleteAccount
class _StringsSettingsPageAccountDeleteAccountZhCn extends _StringsSettingsPageAccountDeleteAccountEn {
	_StringsSettingsPageAccountDeleteAccountZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '删除帐户...';
	@override String get confirmTitle => '确认删除';
	@override String get confirmBody => '你确定要删除你的帐户吗？这不能撤消。';
}

// Path: settingsPage.general.brightnessOptions
class _StringsSettingsPageGeneralBrightnessOptionsZhCn extends _StringsSettingsPageGeneralBrightnessOptionsEn {
	_StringsSettingsPageGeneralBrightnessOptionsZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get system => '系统';
	@override String get dark => '深色模式';
	@override String get light => '浅色模式';
}

// Path: settingsPage.general.colorOptions
class _StringsSettingsPageGeneralColorOptionsZhCn extends _StringsSettingsPageGeneralColorOptionsEn {
	_StringsSettingsPageGeneralColorOptionsZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get system => '自动';
	@override String get purple => '星空紫';
	@override String get brown => '沉稳棕';
	@override String get blue => '深海蓝';
	@override String get green => '马尔斯绿';
	@override String get yellow => '活力黄';
}

// Path: settingsPage.general.languageOptions
class _StringsSettingsPageGeneralLanguageOptionsZhCn extends _StringsSettingsPageGeneralLanguageOptionsEn {
	_StringsSettingsPageGeneralLanguageOptionsZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get system => '系统';
}

// Path: dialog.introduction.page_2
class _StringsDialogIntroductionPage2ZhCn extends _StringsDialogIntroductionPage2En {
	_StringsDialogIntroductionPage2ZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => 'ClipMemo 的打开方式';
	@override late final _StringsDialogIntroductionPage2Feature1ZhCn feature_1 = _StringsDialogIntroductionPage2Feature1ZhCn._(_root);
	@override late final _StringsDialogIntroductionPage2Feature2ZhCn feature_2 = _StringsDialogIntroductionPage2Feature2ZhCn._(_root);
	@override late final _StringsDialogIntroductionPage2Feature3ZhCn feature_3 = _StringsDialogIntroductionPage2Feature3ZhCn._(_root);
	@override String get footer => '总之，你可以像给书加书签一样，给任何视频或者播客打上书签。我们支持 Bilibili 和 YouTube 导入哦。';
}

// Path: dialog.introduction.page_3
class _StringsDialogIntroductionPage3ZhCn extends _StringsDialogIntroductionPage3En {
	_StringsDialogIntroductionPage3ZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '开始吧！';
	@override String get body => '我们已经为你准备好了一些示例。';
}

// Path: dialog.introduction.page_2.feature_1
class _StringsDialogIntroductionPage2Feature1ZhCn extends _StringsDialogIntroductionPage2Feature1En {
	_StringsDialogIntroductionPage2Feature1ZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '边看视频边学口语';
	@override String get body => '截取番剧、电影中的表达、俚语或者词汇，每日复习。';
}

// Path: dialog.introduction.page_2.feature_2
class _StringsDialogIntroductionPage2Feature2ZhCn extends _StringsDialogIntroductionPage2Feature2En {
	_StringsDialogIntroductionPage2Feature2ZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '提高视频学习效率';
	@override String get body => '快速记录网课、视频笔记';
}

// Path: dialog.introduction.page_2.feature_3
class _StringsDialogIntroductionPage2Feature3ZhCn extends _StringsDialogIntroductionPage2Feature3En {
	_StringsDialogIntroductionPage2Feature3ZhCn._(_StringsZhCn root) : this._root = root, super._(root);

	@override final _StringsZhCn _root; // ignore: unused_field

	// Translations
	@override String get title => '标记任何多媒体内容';
	@override String get body => '收集碎片化的视频中的知识，如面试、外国友人录制的 vlog...';
}
