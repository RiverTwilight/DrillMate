import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/pages/store/store_page.dart';
import 'package:hgeology_app/provider/data_provider.dart';
import 'package:hgeology_app/provider/media_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hgeology_app/provider/settings_provider.dart';
import 'package:hgeology_app/services/media_controller.dart';
import 'package:hgeology_app/utils/link_generator.dart';
import 'package:hgeology_app/utils/url_checker.dart';
import 'package:hgeology_app/widget/card_base.dart';
import 'package:hgeology_app/widget/custom_bottomsheet.dart';
import 'package:hgeology_app/widget/tip_text.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';
import 'package:hgeology_app/gen/strings.g.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectQRcodePage extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectQRcodePage({
    Key? key,
    required this.projectId,
  }) : super(key: key);

  @override
  ConsumerState<ProjectQRcodePage> createState() => _ProjectQRcodePageState();
}

class _ProjectQRcodePageState extends ConsumerState<ProjectQRcodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading:
            const LeadingBackButton(), // Ensure this widget is defined elsewhere in your code.
        title: const Text("项目二维码"),
        elevation: 0.0,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 6),
        child: ListView(
          children: [
            Center(
              child: QrImageView(
                data: widget.projectId,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement the scanning functionality here
                },
                child: const Text('Scan Qrcode'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
