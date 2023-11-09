import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hgeology_app/gen/strings.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/pages/about_page.dart';
import 'package:hgeology_app/pages/backup_page.dart';
import 'package:hgeology_app/pages/settings_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:hgeology_app/provider/data_provider.dart';
import 'package:hgeology_app/utils/contact.dart';
import 'package:hgeology_app/provider.dart';
import 'package:hgeology_app/provider/auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:hgeology_app/widget/plus_badage.dart';

String convertUnixTimeToLocalDateString(int unixTime) {
  final date = DateTime.fromMillisecondsSinceEpoch(unixTime);
  final formatter = DateFormat('y-MM-dd'); // Change to your preferred format
  return formatter.format(date);
}

class MorePage extends ConsumerStatefulWidget {
  const MorePage({super.key});

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends ConsumerState<MorePage>
    with WidgetsBindingObserver {
  String? appVersion;
  String? appBuildNumber;
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    // WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.resumed) {
  //     _refreshData(); // Refreshing when app is resumed
  //   }
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this); // Unregistering observer
  //   super.dispose();
  // }

  Future<void> _refreshData() async {
    final userDataManager = ref.read(userDataProvider);

    userDataManager.loadData();
  }

  Future<void> _initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appVersion = packageInfo.version;
      appBuildNumber = packageInfo.buildNumber;
    });
  }

  Widget _buildPriviligeItem(Widget icon, String title) {
    return SizedBox(
      child: Column(
        children: [
          icon,
          Text(title,
              style: TextStyle(color: Theme.of(context).colorScheme.primary))
        ],
      ),
    );
  }

  Widget _buildAccountPart(WidgetRef ref) {
    final userDataManager = ref.watch(userDataProvider);

    return Stack(
      alignment: Alignment.bottomLeft,
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        Card(
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: 50,
                    child: GridView(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.0,
                      ),
                      children: [
                        _buildPriviligeItem(
                            Icon(Icons.video_collection_outlined,
                                color: Theme.of(context).colorScheme.primary),
                            t.moreTab.privilige.unlimited),
                        _buildPriviligeItem(
                            Icon(Icons.chrome_reader_mode,
                                color: Theme.of(context).colorScheme.primary),
                            t.moreTab.privilige.review),
                        _buildPriviligeItem(
                            Icon(Icons.cloud,
                                color: Theme.of(context).colorScheme.primary),
                            t.moreTab.privilige.sync),
                        _buildPriviligeItem(
                            Icon(Icons.speaker,
                                color: Theme.of(context).colorScheme.primary),
                            t.moreTab.privilige.unlimited),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalPart(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
        ListTile(
          leading: const Icon(Icons.layers_rounded),
          title: Text(
            t.moreTab.general.check101,
          ),
          subtitle: Text(
            t.moreTab.general.check101Intro,
          ),
          trailing: const Icon(Icons.open_in_new_sharp, size: 18),
          onTap: () async {
            check101();
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(
            t.moreTab.actions.settings,
          ),
          // subtitle: Text(t.moreTab.general.feedbackIntro),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18),
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.backup_rounded),
          title: Text(
            t.moreTab.actions.sync,
          ),
          // subtitle: Text(t.moreTab.general.feedbackIntro),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18),
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BackupPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.chat),
          title: Text(
            t.moreTab.general.feedback,
          ),
          // subtitle: Text(t.moreTab.general.feedbackIntro),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18),
          onTap: () async {
            contactViaEmail();
          },
        ),
        const SizedBox(height: 12),
        ListTile(
          // leading: Icon(Icons.rate_review),
          title: Text(
            t.moreTab.actions.rate,
          ),
          // subtitle: Text(t.moreTab.rateIntro),
          trailing: const Icon(Icons.open_in_new_sharp, size: 18),
          onTap: () {
            rateApp();
          },
        ),
        ListTile(
          title: Text(
            t.moreTab.general.about,
          ),
          subtitle: Text(t.moreTab.general.aboutIntro),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutPage()),
            );
          },
        ),
        const SizedBox(height: 20),
        if (appVersion != null) // Check that appVersion is not null
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Version $appVersion ($appBuildNumber)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 750),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView(
                physics:
                    const AlwaysScrollableScrollPhysics(), // This ensures the list is always scrollable
                children: <Widget>[
                  // const SizedBox(height: 30),
                  _buildAdditionalPart(ref),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
