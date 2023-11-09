/// Generated file. Do not edit.
///
/// Locales: 1
/// Strings: 274


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
	en(languageCode: 'en', build: _StringsEn.build);

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
	String get locale => '简体中文';
	String get appName => '道路勘探';
	late final _StringsGeneralEn general = _StringsGeneralEn._(_root);
	late final _StringsMediaLibraryTabEn mediaLibraryTab = _StringsMediaLibraryTabEn._(_root);
	late final _StringsProjectLibraryTabEn projectLibraryTab = _StringsProjectLibraryTabEn._(_root);
	late final _StringsMemoLibraryPageEn memoLibraryPage = _StringsMemoLibraryPageEn._(_root);
	late final _StringsAccountDetailPageEn accountDetailPage = _StringsAccountDetailPageEn._(_root);
	late final _StringsMediaDetailPageEn mediaDetailPage = _StringsMediaDetailPageEn._(_root);
	late final _StringsStatisticTabEn statisticTab = _StringsStatisticTabEn._(_root);
	late final _StringsReviewTabEn reviewTab = _StringsReviewTabEn._(_root);
	late final _StringsMoreTabEn moreTab = _StringsMoreTabEn._(_root);
	late final _StringsAboutPageEn aboutPage = _StringsAboutPageEn._(_root);
	late final _StringsCollectionPageEn collectionPage = _StringsCollectionPageEn._(_root);
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
	String get add => '添加';
	String get advanced => '高级';
	String get cancel => '取消';
	String get close => '关闭';
	String get confirm => '确认';
	String get continueStr => '继续';
	String get copy => '复制';
	String get decline => '拒绝';
	String get deleteStr => '删除';
	String get done => '完成';
	String get edit => '编辑';
	String get error => '错误';
	String get email => '电子邮件';
	String get example => '示例';
	String get finished => '已完成';
	String get hide => '隐藏';
	String get next => '下一个';
	String get off => '关闭';
	String get on => '打开';
	String get open => '打开';
	String get password => '密码';
	String get play => '播放';
	String get previous => '上一个';
	String get preview => '预览';
	String get pause => '暂停';
	String get renamed => '已重命名';
	String get rename => '重命名';
	String get reset => '重置';
	String get settings => '设置';
	String get start => '开始';
	String get stop => '停止';
	String get save => '保存';
	String get unchanged => '未改变';
	String get unknown => '未知';
	String get expired => '已过期';
	String get nologin => '未登录';
	String get view => '查看';
	String get learnMore => '了解更多...';
	String get language => '语言';
	String get noEligibilityHint => '你需要升级到 ClipMemo Plus 来使用此功能。';
}

// Path: mediaLibraryTab
class _StringsMediaLibraryTabEn {
	_StringsMediaLibraryTabEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get tabName => '媒体库';
	String get emptyHint => '暂无媒体，请添加';
	late final _StringsMediaLibraryTabSortMethodEn sortMethod = _StringsMediaLibraryTabSortMethodEn._(_root);
}

// Path: projectLibraryTab
class _StringsProjectLibraryTabEn {
	_StringsProjectLibraryTabEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get tabName => '项目';
	late final _StringsProjectLibraryTabEmptyHintEn emptyHint = _StringsProjectLibraryTabEmptyHintEn._(_root);
}

// Path: memoLibraryPage
class _StringsMemoLibraryPageEn {
	_StringsMemoLibraryPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Memos';
}

// Path: accountDetailPage
class _StringsAccountDetailPageEn {
	_StringsAccountDetailPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '账户';
	late final _StringsAccountDetailPageInfoEn info = _StringsAccountDetailPageInfoEn._(_root);
	late final _StringsAccountDetailPagePasswordEn password = _StringsAccountDetailPagePasswordEn._(_root);
}

// Path: mediaDetailPage
class _StringsMediaDetailPageEn {
	_StringsMediaDetailPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get playAll => '播放所有 Memo';
	String get stopPlayAll => '停止自动播放';
	late final _StringsMediaDetailPageTranscriptEn transcript = _StringsMediaDetailPageTranscriptEn._(_root);
	late final _StringsMediaDetailPageRenameEn rename = _StringsMediaDetailPageRenameEn._(_root);
	String get noMediaError => '找不到媒体文件。你可以重新导入。';
	late final _StringsMediaDetailPageAppBarActionsEn appBarActions = _StringsMediaDetailPageAppBarActionsEn._(_root);
	String get limitationReachedHint => '升级到 Plus 订阅以添加更多 Memo。';
	String get startCaptureBtn => '开始截取';
	String get loopModeSwitch => '设置循环模式';
	String get optionsBtn => '选项';
	String get loopBtn => '循环';
	late final _StringsMediaDetailPageOptionsEn options = _StringsMediaDetailPageOptionsEn._(_root);
	late final _StringsMediaDetailPageCaptureHintEn captureHint = _StringsMediaDetailPageCaptureHintEn._(_root);
	late final _StringsMediaDetailPageShareEn share = _StringsMediaDetailPageShareEn._(_root);
}

// Path: statisticTab
class _StringsStatisticTabEn {
	_StringsStatisticTabEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '统计';
	String get deleteConfirm => '你确定要删除此项吗？';
	String get noDataHint => '尚无足够数据。';
	String get totalBookmark => '书签数量';
	String get totalReview => '复习次数';
	List<String> get quotes => [
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
class _StringsReviewTabEn {
	_StringsReviewTabEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '回顾';
	String get weekCheck => '本周';
	String get dayCheck => '今天';
	String get comparedWithLastWeek => '比上周';
	String get emptyHint => '暂无书签。';
	String get playAnwser => '查看答案';
}

// Path: moreTab
class _StringsMoreTabEn {
	_StringsMoreTabEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '更多';
	String get lifetime => '永久';
	late final _StringsMoreTabGeneralEn general = _StringsMoreTabGeneralEn._(_root);
	late final _StringsMoreTabPriviligeEn privilige = _StringsMoreTabPriviligeEn._(_root);
	late final _StringsMoreTabActionsEn actions = _StringsMoreTabActionsEn._(_root);
}

// Path: aboutPage
class _StringsAboutPageEn {
	_StringsAboutPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '关于';
	String get tagline => '设计 & 开发';
	String get author => 'RiverTwilight';
}

// Path: collectionPage
class _StringsCollectionPageEn {
	_StringsCollectionPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
}

// Path: purchasePage
class _StringsPurchasePageEn {
	_StringsPurchasePageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '会员';
	String get restore => '恢复购买';
	late final _StringsPurchasePageIntroEn intro = _StringsPurchasePageIntroEn._(_root);
	String get loginHint => '为了你的安心，请在购买会员之前登录，以确保你能拥有购买内容。它还保护你的会员特权免受任何意外损失。';
	String get introTitle => '更快录制，更快学习。';
	String get introBody => '我们的使命是为每个人带来更好的教育资源。虽然基本计划可以满足大多数学习者的需求，但你可以尝试 TalkReel Plus 以获得更好、更快的学习体验，以及8个特殊功能。';
	late final _StringsPurchasePageFeaturesEn features = _StringsPurchasePageFeaturesEn._(_root);
	late final _StringsPurchasePageRedeemEn redeem = _StringsPurchasePageRedeemEn._(_root);
	String get unlimited => '不限制';
	String get alreadyPurchasedHint => '你已经是 Plus 会员了。';
	late final _StringsPurchasePagePurchaseHintEn purchaseHint = _StringsPurchasePagePurchaseHintEn._(_root);
}

// Path: newMediaPage
class _StringsNewMediaPageEn {
	_StringsNewMediaPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '添加到库';
	String get customTab => '自定义';
	String get onlineTab => '在线';
	String get finishImport => '成功导入';
	String get importError => '发生了错误。别担心，这不是你的错。';
	late final _StringsNewMediaPageSourceEn source = _StringsNewMediaPageSourceEn._(_root);
	late final _StringsNewMediaPagePermissionEn permission = _StringsNewMediaPagePermissionEn._(_root);
	late final _StringsNewMediaPageYoutubeEn youtube = _StringsNewMediaPageYoutubeEn._(_root);
	late final _StringsNewMediaPageCreateCollectionEn createCollection = _StringsNewMediaPageCreateCollectionEn._(_root);
	String get tedFile => '选择已下载的文件...';
	String get tedHelpBtn => '如何下载TED视频？';
	String get remoteFileHint => '你可以通过输入链接来添加播客节目或者视频文件。ClipMemo 不会下载文件到本地。';
	String get bilibiliHint => '轻触 Bilibili 客户端播放页面中的“分享”图标来获取视频链接，或者轻触分享页面的“更多”按钮直接分享到 ClipMemo。在 PC 或者 Mac 上，复制地址栏的文本即可获取链接。';
	String get youtubeHint => '轻触 YouTube 客户端播放页面中的“分享”图标来获取视频链接。在 PC 或者 Mac 上，复制地址栏的文本即可获取链接。';
}

// Path: bookmarkDetailPage
class _StringsBookmarkDetailPageEn {
	_StringsBookmarkDetailPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '编辑书签';
	String get deleteStr => '删除书签';
	String get noNoteHint => '点击“编辑”开始记笔记。';
	late final _StringsBookmarkDetailPageTagEn tag = _StringsBookmarkDetailPageTagEn._(_root);
	String get deleteConfirmTitle => '删除便签';
	String get deleteConfirm => '你确定要删除此项吗？';
}

// Path: settingsPage
class _StringsSettingsPageEn {
	_StringsSettingsPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '设置';
	late final _StringsSettingsPageAccountEn account = _StringsSettingsPageAccountEn._(_root);
	late final _StringsSettingsPageGeneralEn general = _StringsSettingsPageGeneralEn._(_root);
	late final _StringsSettingsPageDataEn data = _StringsSettingsPageDataEn._(_root);
	String get termOfUse => '使用协议';
}

// Path: searchPage
class _StringsSearchPageEn {
	_StringsSearchPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get inputHint => '搜索任何内容...';
}

// Path: backupPage
class _StringsBackupPageEn {
	_StringsBackupPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '备份';
	String get backupSubtitle => '将你的数据存储到 iCloud';
	String get restore => '恢复';
	String get backup => '备份';
	String get csv => '导出 CSV';
	String get hint => '媒体文件无法同步。你可以在恢复数据后重新链接媒体源。';
	String get fromiCloud => 'iCloud';
	String get fromLocal => '本地';
	String get downloadFinish => '下载完成';
	String get uploadFinish => '上传完成';
}

// Path: loginPage
class _StringsLoginPageEn {
	_StringsLoginPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '登录';
	String get noAccount => '我没有帐户';
	String get forget => '我忘记了密码';
	String get passwordValid => '请输入你的密码';
	String get emailValid => '请输入你的电子邮件';
	String get errorPrefix => '登录失败：';
}

// Path: signupPage
class _StringsSignupPageEn {
	_StringsSignupPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '注册';
	String get passwordConfirm => '确认密码';
	String get passwordConfirmValid => '请确认你的密码';
	String get haveAccount => '我已经有一个帐户';
	String get notMatch => '密码不匹配';
	String get errorPrefix => '注册失败：';
}

// Path: langugaePage
class _StringsLangugaePageEn {
	_StringsLangugaePageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '语言';
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
	String get root => 'https://www.ygeeker.com/zh-CN/support/clipmemo';
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
	String get name => '按名称排序';
	String get recent => '最近';
	String get date => '按日期排序';
}

// Path: projectLibraryTab.emptyHint
class _StringsProjectLibraryTabEmptyHintEn {
	_StringsProjectLibraryTabEmptyHintEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '暂时没有项目';
	String get body => '轻点右下角添加一个项目，或者刷新页面';
}

// Path: accountDetailPage.info
class _StringsAccountDetailPageInfoEn {
	_StringsAccountDetailPageInfoEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '属性';
}

// Path: accountDetailPage.password
class _StringsAccountDetailPagePasswordEn {
	_StringsAccountDetailPagePasswordEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get oldPwd => '旧密码';
	String get newPwd => '新密码';
}

// Path: mediaDetailPage.transcript
class _StringsMediaDetailPageTranscriptEn {
	_StringsMediaDetailPageTranscriptEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get startBtn => '开始';
	String get transcribingStr => '转录中';
	String get tip => '较大的文件可能需要更长的时间。';
	String get localLimitationHint => '仅支持转录本地音视频文件';
}

// Path: mediaDetailPage.rename
class _StringsMediaDetailPageRenameEn {
	_StringsMediaDetailPageRenameEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get confirmBtn => '重命名';
	String get label => '新名称';
}

// Path: mediaDetailPage.appBarActions
class _StringsMediaDetailPageAppBarActionsEn {
	_StringsMediaDetailPageAppBarActionsEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get transcribe => '转录';
	String get replace => '替换媒体';
}

// Path: mediaDetailPage.options
class _StringsMediaDetailPageOptionsEn {
	_StringsMediaDetailPageOptionsEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get mediaSource => '媒体来源：';
	String get speed => '速度：';
	String get autoRestore => '自动恢复上次播放位置';
	String get danmuku => '弹幕';
}

// Path: mediaDetailPage.captureHint
class _StringsMediaDetailPageCaptureHintEn {
	_StringsMediaDetailPageCaptureHintEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '截取什么？';
	String get expression => '困难或新的词汇/俚语/表达';
	String get phrase => '图表、划重点或者思维导图';
	String get anything => '你想保存的任何东西';
}

// Path: mediaDetailPage.share
class _StringsMediaDetailPageShareEn {
	_StringsMediaDetailPageShareEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '分享';
	late final _StringsMediaDetailPageSharePublishToStoreEn publishToStore = _StringsMediaDetailPageSharePublishToStoreEn._(_root);
	late final _StringsMediaDetailPageShareExportEn export = _StringsMediaDetailPageShareExportEn._(_root);
}

// Path: moreTab.general
class _StringsMoreTabGeneralEn {
	_StringsMoreTabGeneralEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '通用';
	String get feedback => '反馈';
	String get feedbackIntro => '我们需要你！';
	String get about => '关于';
	String get aboutIntro => '和作者聊聊，看看他的更多作品。';
	String get check101 => '前往 ClipMemo 学院';
	String get check101Intro => '获取提示和帮助';
	String get brightness => '亮度';
	late final _StringsMoreTabGeneralBrightnessOptionsEn brightnessOptions = _StringsMoreTabGeneralBrightnessOptionsEn._(_root);
	String get color => '颜色';
	late final _StringsMoreTabGeneralColorOptionsEn colorOptions = _StringsMoreTabGeneralColorOptionsEn._(_root);
	String get language => '语言';
	late final _StringsMoreTabGeneralLanguageOptionsEn languageOptions = _StringsMoreTabGeneralLanguageOptionsEn._(_root);
}

// Path: moreTab.privilige
class _StringsMoreTabPriviligeEn {
	_StringsMoreTabPriviligeEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get review => '回顾';
	String get unlimited => '不限制';
	String get sync => '同步';
}

// Path: moreTab.actions
class _StringsMoreTabActionsEn {
	_StringsMoreTabActionsEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get rate => '给我们评分';
	String get sync => '备份与恢复';
	String get settings => '设置';
}

// Path: purchasePage.intro
class _StringsPurchasePageIntroEn {
	_StringsPurchasePageIntroEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get review => '通过每日回顾更快地取得进步。';
	String get sync => '在不同设备之间访问你的笔记和媒体。';
	String get unlimited => '添加无限媒体和书签。';
}

// Path: purchasePage.features
class _StringsPurchasePageFeaturesEn {
	_StringsPurchasePageFeaturesEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get cloudSync => '云同步';
	String get note => '笔记';
	String get review => '每日回顾';
	String get tag => '标签系统';
	String get bookmark => '书签';
	String get transcribe => '自动转录';
	String get speed => '播放速度';
	String get media => '媒体';
	String get loop => '循环';
	String get theme => '主题颜色';
}

// Path: purchasePage.redeem
class _StringsPurchasePageRedeemEn {
	_StringsPurchasePageRedeemEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '兑换';
	String get dialogTitle => '兑换优惠码';
	String get redeemSuccessHint => '兑换成功。';
}

// Path: purchasePage.purchaseHint
class _StringsPurchasePagePurchaseHintEn {
	_StringsPurchasePagePurchaseHintEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get beforePolicy => '购买前请查看我们的';
	String get policy => '政策';
	String get afterPolicy => '。如果付款后你的订阅状态没有更新，请凭支付收据截图';
	String get contact => '联系我们';
	String get afterContact => '。';
}

// Path: newMediaPage.source
class _StringsNewMediaPageSourceEn {
	_StringsNewMediaPageSourceEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get youtube => 'YouTube';
	String get bilibili => 'Bilibili';
	String get wechat => '微信';
	String get ted => 'TED';
	String get localVideo => '视频';
	String get localAudio => '音频';
	String get directUrl => '文件链接';
}

// Path: newMediaPage.permission
class _StringsNewMediaPagePermissionEn {
	_StringsNewMediaPagePermissionEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '解锁更多功能！';
	String get body => '看来您一直在享受我们的应用！要添加更多视频，请考虑升级到我们的Plus计划。';
	String get upgrade => '了解更多';
}

// Path: newMediaPage.youtube
class _StringsNewMediaPageYoutubeEn {
	_StringsNewMediaPageYoutubeEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get fetchTitle => '自动获取标题';
}

// Path: newMediaPage.createCollection
class _StringsNewMediaPageCreateCollectionEn {
	_StringsNewMediaPageCreateCollectionEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '新建合集';
}

// Path: bookmarkDetailPage.tag
class _StringsBookmarkDetailPageTagEn {
	_StringsBookmarkDetailPageTagEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get btn => '新增标签';
	String get dialogTitle => '添加一个标签';
	String get inputHint => '输入标签内容，例如“日语”';
}

// Path: settingsPage.account
class _StringsSettingsPageAccountEn {
	_StringsSettingsPageAccountEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '帐户';
	late final _StringsSettingsPageAccountDeleteAccountEn deleteAccount = _StringsSettingsPageAccountDeleteAccountEn._(_root);
	String get logout => '退出登录';
	String get login => '登录...';
	String get details => '帐户详细信息';
}

// Path: settingsPage.general
class _StringsSettingsPageGeneralEn {
	_StringsSettingsPageGeneralEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '一般';
	String get brightness => '亮度';
	late final _StringsSettingsPageGeneralBrightnessOptionsEn brightnessOptions = _StringsSettingsPageGeneralBrightnessOptionsEn._(_root);
	String get color => '颜色';
	late final _StringsSettingsPageGeneralColorOptionsEn colorOptions = _StringsSettingsPageGeneralColorOptionsEn._(_root);
	String get language => '语言';
	late final _StringsSettingsPageGeneralLanguageOptionsEn languageOptions = _StringsSettingsPageGeneralLanguageOptionsEn._(_root);
}

// Path: settingsPage.data
class _StringsSettingsPageDataEn {
	_StringsSettingsPageDataEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '数据';
	String get clean => '清理';
	String get clear => '清除所有数据';
	String get confirmTitle => '确认擦除';
	String get confirmBody => '你确定要擦除所有本地数据吗？此操作不能撤销。';
	String get finishHint => '数据已擦除。重新启动应用以生效。';
}

// Path: langugaePage.localizedLanguageName
class _StringsLangugaePageLocalizedLanguageNameEn {
	_StringsLangugaePageLocalizedLanguageNameEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get enUS => '英语（美国）';
	String get enGB => '英语（英语）';
	String get fr => '法语';
	String get ko => '韩语';
	String get jp => '日语';
	String get zhCN => '中文（中国）';
	String get zhHK => '中文（香港）';
}

// Path: dialog.contact
class _StringsDialogContactEn {
	_StringsDialogContactEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get replayTime => '我们会在 2 个工作日内回复你。';
	String get wechat => '微信';
	String get red => '小红书';
	String get wechatCopied => '已复制微信号';
	String get redCopied => '已复制小红书 ID。在小红书中搜索此账户即可联系我们。';
	String get emailCopied => '已复制邮件';
}

// Path: dialog.addBilibiliError
class _StringsDialogAddBilibiliErrorEn {
	_StringsDialogAddBilibiliErrorEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '我们无法处理你输入的链接';
	String get body => '试着移除多余的字符。目前，我们不支持导入番剧。';
}

// Path: dialog.renameBookmark
class _StringsDialogRenameBookmarkEn {
	_StringsDialogRenameBookmarkEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '起个名字吧';
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
	String get title => '发布到商店';
	String get body => '';
}

// Path: mediaDetailPage.share.export
class _StringsMediaDetailPageShareExportEn {
	_StringsMediaDetailPageShareExportEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '导出文件';
	String get body => '';
}

// Path: moreTab.general.brightnessOptions
class _StringsMoreTabGeneralBrightnessOptionsEn {
	_StringsMoreTabGeneralBrightnessOptionsEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get system => '跟随系统';
	String get dark => '深色模式';
	String get light => '浅色模式';
}

// Path: moreTab.general.colorOptions
class _StringsMoreTabGeneralColorOptionsEn {
	_StringsMoreTabGeneralColorOptionsEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get system => '系统';
}

// Path: moreTab.general.languageOptions
class _StringsMoreTabGeneralLanguageOptionsEn {
	_StringsMoreTabGeneralLanguageOptionsEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get system => '系统';
}

// Path: settingsPage.account.deleteAccount
class _StringsSettingsPageAccountDeleteAccountEn {
	_StringsSettingsPageAccountDeleteAccountEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '删除帐户...';
	String get confirmTitle => '确认删除';
	String get confirmBody => '你确定要删除你的帐户吗？这不能撤消。';
}

// Path: settingsPage.general.brightnessOptions
class _StringsSettingsPageGeneralBrightnessOptionsEn {
	_StringsSettingsPageGeneralBrightnessOptionsEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get system => '系统';
	String get dark => '深色模式';
	String get light => '浅色模式';
}

// Path: settingsPage.general.colorOptions
class _StringsSettingsPageGeneralColorOptionsEn {
	_StringsSettingsPageGeneralColorOptionsEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get system => '自动';
	String get purple => '星空紫';
	String get brown => '沉稳棕';
	String get blue => '深海蓝';
	String get green => '马尔斯绿';
	String get yellow => '活力黄';
}

// Path: settingsPage.general.languageOptions
class _StringsSettingsPageGeneralLanguageOptionsEn {
	_StringsSettingsPageGeneralLanguageOptionsEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get system => '系统';
}

// Path: dialog.introduction.page_2
class _StringsDialogIntroductionPage2En {
	_StringsDialogIntroductionPage2En._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'ClipMemo 的打开方式';
	late final _StringsDialogIntroductionPage2Feature1En feature_1 = _StringsDialogIntroductionPage2Feature1En._(_root);
	late final _StringsDialogIntroductionPage2Feature2En feature_2 = _StringsDialogIntroductionPage2Feature2En._(_root);
	late final _StringsDialogIntroductionPage2Feature3En feature_3 = _StringsDialogIntroductionPage2Feature3En._(_root);
	String get footer => '总之，你可以像给书加书签一样，给任何视频或者播客打上书签。我们支持 Bilibili 和 YouTube 导入哦。';
}

// Path: dialog.introduction.page_3
class _StringsDialogIntroductionPage3En {
	_StringsDialogIntroductionPage3En._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '开始吧！';
	String get body => '我们已经为你准备好了一些示例。';
}

// Path: dialog.introduction.page_2.feature_1
class _StringsDialogIntroductionPage2Feature1En {
	_StringsDialogIntroductionPage2Feature1En._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '边看视频边学口语';
	String get body => '截取番剧、电影中的表达、俚语或者词汇，每日复习。';
}

// Path: dialog.introduction.page_2.feature_2
class _StringsDialogIntroductionPage2Feature2En {
	_StringsDialogIntroductionPage2Feature2En._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '提高视频学习效率';
	String get body => '快速记录网课、视频笔记';
}

// Path: dialog.introduction.page_2.feature_3
class _StringsDialogIntroductionPage2Feature3En {
	_StringsDialogIntroductionPage2Feature3En._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => '标记任何多媒体内容';
	String get body => '收集碎片化的视频中的知识，如面试、外国友人录制的 vlog...';
}
