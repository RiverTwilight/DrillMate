import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share_handler/share_handler.dart';
import 'package:hgeology_app/constants.dart';
import 'package:hgeology_app/pages/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:intl/intl.dart';

class StopHoleApplyPage extends ConsumerStatefulWidget {
  final SharedMedia? sharePayload;
  const StopHoleApplyPage({Key? key, this.sharePayload}) : super(key: key);

  @override
  ConsumerState<StopHoleApplyPage> createState() => _StopHoleApplyPageState();
}

class _StopHoleApplyPageState extends ConsumerState<StopHoleApplyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _holeRadiusController = TextEditingController();
  TextEditingController _holeDepthController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _finishTimeController = TextEditingController();

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    setState(() {
      _finishTimeController.text =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _holeRadiusController.dispose();
    _holeDepthController.dispose();
    _descriptionController.dispose();
    _finishTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: const LeadingBackButton(),
        title: Text("终止"),
        elevation: 0.0,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 6),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _holeRadiusController,
                decoration: InputDecoration(labelText: '钻孔直径 (mm)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _holeDepthController,
                decoration: InputDecoration(labelText: '终孔深度 (m)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: '描述'),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: _finishTimeController,
                decoration: InputDecoration(labelText: '终止时间'),
                readOnly: true,
              ),
              const SizedBox(
                height: 18,
              ),
              ElevatedButton(onPressed: () {}, child: Text("确认终止"))
            ],
          ),
        ),
      ),
    );
  }
}
