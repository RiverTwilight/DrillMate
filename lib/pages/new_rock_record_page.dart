import 'package:flutter/material.dart';
import 'package:share_handler/share_handler.dart';
import 'package:hgeology_app/constants.dart';
import 'package:hgeology_app/pages/home_page.dart';
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
import 'package:hgeology_app/widget/leading_back_button.dart';
import 'package:hgeology_app/gen/strings.g.dart';
import 'package:http/http.dart' as http;

class NewRockRecordPage extends ConsumerStatefulWidget {
  final SharedMedia? sharePayload;
  const NewRockRecordPage({Key? key, this.sharePayload}) : super(key: key);

  @override
  ConsumerState<NewRockRecordPage> createState() => _NewRockRecordPageState();
}

class _NewRockRecordPageState extends ConsumerState<NewRockRecordPage> {
  bool _isProcessing = false;
  String? _errorText;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void _showSuccessSnackbar() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          t.newMediaPage.finishImport,
          style: const TextStyle(fontSize: 16),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: SnackBarAction(
          label: t.general.view,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: const LeadingBackButton(),
          title: Text("新建岩土记录"),
          elevation: 0.0,
          backgroundColor: Theme.of(context).canvasColor,
          actions: [
            IconButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Handle form submission
                  }
                },
                icon: Icon(Icons.check))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 6),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}
