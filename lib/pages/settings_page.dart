import 'package:flutter/material.dart';
import 'package:hgeology_app/gen/strings.g.dart';
import 'package:hgeology_app/models/theme_color.dart';
import 'package:hgeology_app/models/user.dart';
import 'package:hgeology_app/pages/account/account_detail_page.dart';
import 'package:hgeology_app/pages/language_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/provider/settings_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:hgeology_app/provider/auth_provider.dart';
import 'package:hgeology_app/services/database.dart';
import 'package:hgeology_app/theme.dart';
import 'package:hgeology_app/utils/contact.dart';
import 'package:hgeology_app/utils/sleep.dart';
import 'package:hgeology_app/widget/custom_dropdown_button.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';
import 'package:hgeology_app/widget/settings_section.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final formKey = GlobalKey<FormState>();
  String? appVersion;
  String? appBuildNumber;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appVersion = packageInfo.version;
      appBuildNumber = packageInfo.buildNumber;
    });
  }

  Widget _buildGeneralPart(WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // StreamBuilder<User?>(
        //   stream: AuthProvider().userStream,
        //   builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        //     if (snapshot.connectionState == ConnectionState.active) {
        //       if (snapshot.data != null) {
        //         return SettingsSection(
        //           title: t.settingsPage.title,
        //           children: [
        //             ListTile(
        //               leading: const Icon(Icons.account_circle),
        //               title: Text(t.settingsPage.account.details),
        //               onTap: () async {
        //                 Navigator.of(context).push(
        //                   MaterialPageRoute(
        //                     builder: (context) => const AccountSettingsPage(),
        //                   ),
        //                 );
        //               },
        //             ),
        //             ListTile(
        //               leading: const Icon(Icons.delete),
        //               title: Text(t.settingsPage.account.deleteAccount.title),
        //               onTap: () async {
        //                 showDialog(
        //                   context: context,
        //                   builder: (BuildContext context) {
        //                     return AlertDialog(
        //                       title: Text(t.settingsPage.account.deleteAccount
        //                           .confirmTitle),
        //                       content: Text(t.settingsPage.account.deleteAccount
        //                           .confirmBody),
        //                       actions: <Widget>[
        //                         TextButton(
        //                           onPressed: () => Navigator.of(context)
        //                               .pop(), // Close dialog without deleting
        //                           child: Text(t.general.cancel),
        //                         ),
        //                         TextButton(
        //                           onPressed: () async {
        //                             await AuthProvider().deleteUser();
        //                             Navigator.of(context).pop();
        //                             Navigator.of(context).pop();
        //                           },
        //                           child: Text(t.general.confirm),
        //                         ),
        //                       ],
        //                     );
        //                   },
        //                 );
        //               },
        //             ),
        //             ListTile(
        //               leading: const Icon(Icons.exit_to_app),
        //               title: Text(
        //                 t.settingsPage.account.logout,
        //               ),
        //               onTap: () async {
        //                 final authManager = AuthProvider();
        //                 await authManager.logout();
        //               },
        //             ),
        //           ],
        //         );
        //       } else {
        //         return SettingsSection(
        //             title: t.settingsPage.account.title,
        //             children: [
        //               ListTile(
        //                 leading: const Icon(Icons.exit_to_app),
        //                 title: Text(
        //                   t.settingsPage.account.login,
        //                 ),
        //                 onTap: () async {
        //                   Navigator.of(context).push(
        //                     MaterialPageRoute(
        //                       builder: (context) => LoginScreen(
        //                         onLoginSuccess: () {
        //                           Navigator.pop(context);
        //                         },
        //                       ),
        //                     ),
        //                   );
        //                 },
        //               ),
        //             ]);
        //       }
        //     } else {
        //       return const SizedBox(
        //         height: 50,
        //         width: 50,
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //   },
        // ),
        SettingsSection(title: t.settingsPage.general.title, children: [
          _SettingsEntry(
            label: t.settingsPage.general.brightness,
            child: CustomDropdownButton<ThemeMode>(
              value: settings.theme,
              items: ThemeMode.values.map((theme) {
                return DropdownMenuItem(
                  value: theme,
                  alignment: Alignment.center,
                  child: Text(theme.humanName),
                );
              }).toList(),
              onChanged: (theme) async {
                if (theme != null) {
                  await ref.read(settingsProvider.notifier).setTheme(theme);
                  await sleepAsync(
                      500); // workaround: brightness takes some time to be updated
                  if (mounted) {
                    await updateSystemOverlayStyle(context);
                  }
                }
              },
            ),
          ),
          _SettingsEntry(
            label: t.settingsPage.general.color,
            child: CustomDropdownButton<ThemeColor>(
              value: settings.themeColor,
              items: ThemeColor.values.map((color) {
                return DropdownMenuItem(
                  value: color,
                  alignment: Alignment.center,
                  child: Text(color.humanName),
                );
              }).toList(),
              onChanged: (color) async {
                if (color != null) {
                  await ref
                      .read(settingsProvider.notifier)
                      .setThemeColor(color);
                  // await sleepAsync(
                  //     500); // workaround: brightness takes some time to be updated
                  // if (mounted) {
                  //   await updateSystemOverlayStyle(context);
                  // }
                }
              },
            ),
          ),
          _SettingsEntry(
            label: t.settingsPage.general.language,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor:
                    Theme.of(context).inputDecorationTheme.fillColor,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        Theme.of(context).inputDecorationTheme.borderRadius),
                foregroundColor: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LanguagePage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  settings.locale?.humanName ?? "System",
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ]),
        SettingsSection(title: t.settingsPage.data.title, children: [
          _SettingsEntry(
            label: t.settingsPage.data.clear,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor:
                    Theme.of(context).inputDecorationTheme.fillColor,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        Theme.of(context).inputDecorationTheme.borderRadius),
                foregroundColor: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(t.settingsPage.data.title),
                      content: Text(t.settingsPage.data.confirmTitle),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context)
                              .pop(), // Close dialog without deleting
                          child: Text(t.general.cancel),
                        ),
                        TextButton(
                          onPressed: () {
                            AppDatabase().wipeData();
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(t.settingsPage.data.finishHint),
                              ),
                            );
                          },
                          child: Text(t.general.confirm),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(t.settingsPage.data.clear),
              ),
            ),
          ),
        ]),
        ListTile(
          leading: const Icon(Icons.info_rounded),
          title: Text(t.settingsPage.termOfUse),
          onTap: () {
            checkTermOfUse();
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const LeadingBackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Wrap(
              children: <Widget>[
                _buildGeneralPart(ref),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsEntry extends StatelessWidget {
  final String label;
  final Widget child;

  const _SettingsEntry({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Expanded(
            child: Text(label),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 150,
            child: child,
          ),
        ],
      ),
    );
  }
}

extension on ThemeMode {
  String get humanName {
    switch (this) {
      case ThemeMode.system:
        return t.settingsPage.general.brightnessOptions.system;
      case ThemeMode.light:
        return t.settingsPage.general.brightnessOptions.light;
      case ThemeMode.dark:
        return t.settingsPage.general.brightnessOptions.dark;
    }
  }
}

extension on ThemeColor {
  String get humanName {
    switch (this) {
      case ThemeColor.green:
        return t.settingsPage.general.colorOptions.green;
      case ThemeColor.blue:
        return t.settingsPage.general.colorOptions.blue;
      case ThemeColor.yellow:
        return t.settingsPage.general.colorOptions.yellow;
      case ThemeColor.brown:
        return t.settingsPage.general.colorOptions.brown;
      case ThemeColor.purple:
        return t.settingsPage.general.colorOptions.purple;
    }
  }
}
