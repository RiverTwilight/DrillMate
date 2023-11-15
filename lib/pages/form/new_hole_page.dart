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

class NewBackRulerRecordPage extends ConsumerStatefulWidget {
  final SharedMedia? sharePayload;
  const NewBackRulerRecordPage({Key? key, this.sharePayload}) : super(key: key);

  @override
  ConsumerState<NewBackRulerRecordPage> createState() =>
      _NewBackRulerRecordPageState();
}

class _NewBackRulerRecordPageState
    extends ConsumerState<NewBackRulerRecordPage> {
  bool _isProcessing = false;
  String? _errorText;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? drillingSize;
  double? depthStart;
  double? depthEnd;
  DateTime? recordTime;
  String? drillEnterMethod;

  @override
  void initState() {
    super.initState();
    recordTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: const LeadingBackButton(),
          title: Text("新建回尺记录"),
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
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      labelText: '钻孔孔径 (m)', icon: Icon(Icons.radar_outlined)),
                  onSaved: (value) => drillingSize = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入钻孔孔径';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: '开始深度', icon: Icon(Icons.label_outline_sharp)),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => depthStart = double.tryParse(value ?? ''),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入开始深度';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: '结束深度', icon: Icon(Icons.label)),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => depthEnd = double.tryParse(value ?? ''),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入结束深度';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                InputDatePickerFormField(
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  initialDate: recordTime!,
                  onDateSaved: (value) => recordTime = value,
                ),
                const SizedBox(
                  height: 12,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: '钻进方法'),
                  items: [
                    DropdownMenuItem(value: 'Method1', child: Text('方法1')),
                    DropdownMenuItem(value: 'Method2', child: Text('方法2')),
                    // Add more methods as needed
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      drillEnterMethod = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return '请选择钻进方法';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
