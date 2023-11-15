import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
import 'package:hgeology_app/widget/tip_text.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';
import 'package:hgeology_app/gen/strings.g.dart';
import 'package:http/http.dart' as http;

class NewPointPage extends ConsumerStatefulWidget {
  final SharedMedia? sharePayload;
  const NewPointPage({Key? key, this.sharePayload}) : super(key: key);

  @override
  ConsumerState<NewPointPage> createState() => _NewPointPageState();
}

class _NewPointPageState extends ConsumerState<NewPointPage> {
  bool _isProcessing = false;
  String? _errorText;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String holeSerialNumber = '';
  double? height;
  double? depth;
  double? radius;
  double? xPosition;
  double? yPosition;
  String? technicalRequirements;
  String holeType = 'Default';
  String holePointType = 'Default';

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

  void _showErrorSnackbar() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          t.newMediaPage.importError,
          style: const TextStyle(fontSize: 16),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void handleFinishImport() async {
    if (context.mounted) {
      _showSuccessSnackbar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: const LeadingBackButton(),
          title: Text("新建勘探点"),
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
                  decoration: InputDecoration(labelText: '勘探点编号'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter hole serial number';
                    }
                    return null;
                  },
                  onSaved: (value) => holeSerialNumber = value!,
                ),
                const SizedBox(height: 14),
                _buildNumberField(
                    '高程 (m)', (value) => height = double.tryParse(value ?? '')),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                        child: _buildNumberField('设计深度 (m)',
                            (value) => depth = double.tryParse(value ?? ''))),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _buildNumberField('钻孔直径 (m)',
                            (value) => radius = double.tryParse(value ?? ''))),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                        child: _buildNumberField('经度',
                            (value) => depth = double.tryParse(value ?? ''))),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _buildNumberField('纬度',
                            (value) => radius = double.tryParse(value ?? ''))),
                  ],
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: holeType,
                  onChanged: (newValue) => setState(() => holeType = newValue!),
                  items: <String>['Default', 'Type 1', 'Type 2']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: '钻孔类型'),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: holePointType,
                  onChanged: (newValue) =>
                      setState(() => holePointType = newValue!),
                  items: <String>['Default', 'Point 1', 'Point 2']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: '钻孔工点类型'),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                        child: _buildNumberField(
                            'X 坐标 (m)',
                            (value) =>
                                xPosition = double.tryParse(value ?? ''))),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _buildNumberField(
                            'Y 坐标 (m)',
                            (value) =>
                                yPosition = double.tryParse(value ?? ''))),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(labelText: '技术要求'),
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  onSaved: (value) => technicalRequirements = value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField(String label, Function(String?) onSave) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      onSaved: onSave,
    );
  }
}
