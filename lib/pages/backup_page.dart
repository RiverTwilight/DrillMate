import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hgeology_app/gen/strings.g.dart';
import 'package:hgeology_app/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:hgeology_app/provider/data_provider.dart';
import 'package:hgeology_app/services/database.dart';
import 'package:hgeology_app/utils/priviliage_checker.dart';
import 'package:hgeology_app/widget/custom_constrained_box.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';
import 'package:hgeology_app/widget/plus_badage.dart';
import 'package:hgeology_app/widget/settings_section.dart';

class BackupPage extends ConsumerStatefulWidget {
  const BackupPage({super.key});

  @override
  _BackupPageState createState() => _BackupPageState();
}

class _BackupPageState extends ConsumerState<BackupPage> {
  final formKey = GlobalKey<FormState>();
  String? appVersion;
  String? appBuildNumber;
  bool isUploading = false;
  bool isDownloading = false;

  final _downloadProgressController = StreamController<double>.broadcast();
  final _uploadProgressController = StreamController<double>.broadcast();

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  void dispose() {
    _downloadProgressController.close();
    _uploadProgressController.close();

    super.dispose();
  }

  void checkEligbility() {
    if (hasPrivilage(FeatureFlags.cloudSync, DataProvider().isPlus)) {}
  }

  Future<void> _initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appVersion = packageInfo.version;
      appBuildNumber = packageInfo.buildNumber;
    });
  }

  Widget _buildGeneralPart(WidgetRef ref) {
    final userDataManager = ref.read(userDataProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SettingsSection(
          title: t.backupPage.fromiCloud,
          children: [
            ListTile(
              leading: const Icon(Icons.cloud_upload_rounded),
              title: Row(children: [
                Text(t.backupPage.backup),
                PlusBadge(
                  size: 16,
                )
              ]),
              subtitle: Text(t.backupPage.backupSubtitle),
              onTap: () async {
                if (!hasPrivilage(
                    FeatureFlags.cloudSync, userDataManager.isPlus)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(t.general.noEligibilityHint)));
                } else {
                  try {
                    // await AppDatabase()
                    //     .uploadToICloud(appVersion!, _uploadProgressController);

                    // ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text(t.backupPage.uploadFinish)));
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              },
              trailing: StreamBuilder<double>(
                stream: _uploadProgressController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data! < 1) {
                    return SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(value: snapshot.data),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.cloud_download_rounded),
              title: Row(children: [
                Text(t.backupPage.restore),
                PlusBadge(
                  size: 16,
                )
              ]),
              onTap: () async {
                if (!hasPrivilage(
                    FeatureFlags.cloudSync, userDataManager.isPlus)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(t.general.noEligibilityHint)));
                } else {
                  final video = ref.read(videoProvider);
                  final bookmarkManager = ref.read(bookmarkProvider);

                  try {
                    // await AppDatabase().downloadFromICloud(
                    //     appVersion!, _downloadProgressController, () {
                    //   video.loadData();
                    //   bookmarkManager.loadData();
                    // });

                    // ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text(t.backupPage.downloadFinish)));
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              },
              trailing: StreamBuilder<double>(
                stream: _downloadProgressController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data! < 1) {
                    return SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(value: snapshot.data),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        // SettingsSection(
        //   title: t.backupPage.fromLocal,
        //   children: [
        //     ListTile(
        //       leading: const Icon(Icons.file_copy),
        //       title: Text(t.backupPage.csv),
        //       onTap: () async {
        //         // TODO Export data to CSV
        //       },
        //     )
        //   ],
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            t.backupPage.hint,
            style: Theme.of(context).textTheme.bodySmall,
          ),
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
      body: CustomConstrainedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Wrap(
                children: <Widget>[
                  _buildGeneralPart(ref),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
