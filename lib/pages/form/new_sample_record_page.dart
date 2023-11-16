import 'package:flutter/material.dart';
import 'package:share_handler/share_handler.dart';
import 'package:hgeology_app/constants.dart';
import 'package:hgeology_app/pages/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/pages/store/store_page.dart';
import 'package:hgeology_app/provider/data_provider.dart';
import 'package:hgeology_app/gen/strings.g.dart';
import 'package:http/http.dart' as http;

class NewSampleRecordPage extends ConsumerStatefulWidget {
  final SharedMedia? sharePayload;
  const NewSampleRecordPage({Key? key, this.sharePayload}) : super(key: key);

  @override
  ConsumerState<NewSampleRecordPage> createState() =>
      _NewSampleRecordPageState();
}

class _NewSampleRecordPageState extends ConsumerState<NewSampleRecordPage> {
  bool _isProcessing = false;
  String? _errorText;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  Widget _buildNumberTextField(String label) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
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

  Widget _buildStringTextField(String label) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      // Add validation and saving logic
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
          title: Text("新建取样记录"),
          elevation: 0.0,
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          actions: [
            IconButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Handle form submission
                  }
                },
                icon: const Icon(Icons.check))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 6),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(
                  height: 18,
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: _buildNumberTextField('开始深度 (m)')),
                    const SizedBox(width: 10),
                    Expanded(child: _buildNumberTextField('结束深度 (m)')),
                  ],
                ),
                const SizedBox(
                  height: 14,
                ),
                _buildOptionField('取样类型'),
                const SizedBox(
                  height: 14,
                ),
                _buildStringTextField('取样序号')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
