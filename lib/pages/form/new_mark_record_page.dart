import 'package:flutter/material.dart';
import 'package:share_handler/share_handler.dart';
import 'package:hgeology_app/constants.dart';
import 'package:hgeology_app/pages/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/pages/store/store_page.dart';
import 'package:hgeology_app/provider/data_provider.dart';
import 'package:hgeology_app/gen/strings.g.dart';
import 'package:http/http.dart' as http;

/// 标贯记录
class NewMarkRecordPage extends ConsumerStatefulWidget {
  final SharedMedia? sharePayload;
  const NewMarkRecordPage({Key? key, this.sharePayload}) : super(key: key);

  @override
  ConsumerState<NewMarkRecordPage> createState() => _NewMarkRecordPageState();
}

class _NewMarkRecordPageState extends ConsumerState<NewMarkRecordPage> {
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
          title: Text("新建标贯记录"),
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
                _buildStringTextField('钻杆长度 (m)'),
                const SizedBox(
                  height: 14,
                ),
                Row(
                  children: <Widget>[
                    const Icon(Icons.label),
                    const SizedBox(width: 10),
                    Expanded(child: _buildNumberTextField('起始 (m)')),
                    const SizedBox(width: 10),
                    Expanded(child: _buildNumberTextField('终止 (m)')),
                    const SizedBox(width: 10),
                    Expanded(child: _buildNumberTextField('击数 (m)')),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  children: <Widget>[
                    const Icon(Icons.label_outline),
                    const SizedBox(width: 10),
                    Expanded(child: _buildNumberTextField('起始 (m)')),
                    const SizedBox(width: 10),
                    Expanded(child: _buildNumberTextField('终止 (m)')),
                    const SizedBox(width: 10),
                    Expanded(child: _buildNumberTextField('击数 (m)')),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  children: <Widget>[
                    const Icon(Icons.label_outline),
                    const SizedBox(width: 10),
                    Expanded(child: _buildNumberTextField('起始 (m)')),
                    const SizedBox(width: 10),
                    Expanded(child: _buildNumberTextField('终止 (m)')),
                    const SizedBox(width: 10),
                    Expanded(child: _buildNumberTextField('击数 (m)')),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  children: <Widget>[
                    const Icon(Icons.label),
                    const SizedBox(width: 10),
                    Expanded(child: _buildNumberTextField('起始 (m)')),
                    const SizedBox(width: 10),
                    Expanded(child: _buildNumberTextField('终止 (m)')),
                    const SizedBox(width: 10),
                    Expanded(child: _buildNumberTextField('击数 (m)')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
