import 'package:flutter/material.dart';
import 'package:hgeology_app/models/rock_record.dart';
import 'package:share_handler/share_handler.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void _saveForm() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      // Now _standardStrata is filled with the form data
      // You can handle the form submission here
    }
  }

  Widget _buildNumberTextField(String label) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      // Add validation and saving logic
    );
  }

  Widget _buildStringTextField(String label) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      // Add validation and saving logic
    );
  }

  Widget _buildOptionField(String label) {
    // Assuming dropdown or similar widget
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      items: [], // Add items here
      onChanged: (String? newValue) {
        // Handle change
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text("新建岩土记录"),
          elevation: 0.0,
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          actions: [
            IconButton(onPressed: _saveForm, icon: const Icon(Icons.check))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 6),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                const SizedBox(
                  height: 18,
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: _buildNumberTextField('开始深度 (m)')),
                    SizedBox(width: 10),
                    Expanded(child: _buildNumberTextField('结束深度 (m)')),
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: _buildOptionField('岩土类型')),
                    SizedBox(width: 10),
                    Expanded(child: _buildOptionField('岩土名称')),
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: _buildStringTextField('Main Layer')),
                    const SizedBox(width: 10),
                    Expanded(child: _buildStringTextField('Secondary Layer')),
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                _buildStringTextField('Third Layer'),
                const SizedBox(
                  height: 14,
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: _buildOptionField('颜色')),
                    const SizedBox(width: 10),
                    Expanded(child: _buildOptionField('湿度')),
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: _buildOptionField('地质时代')),
                    const SizedBox(width: 10),
                    Expanded(child: _buildOptionField('地质年代')),
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: _buildOptionField('密实度')),
                    const SizedBox(width: 10),
                    Expanded(child: _buildOptionField('可塑性')),
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                _buildStringTextField('描述'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
