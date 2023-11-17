import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_handler/share_handler.dart';
import 'package:hgeology_app/constants.dart';
import 'package:hgeology_app/models/video.dart';
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
import 'package:uuid/uuid.dart';
import 'package:hgeology_app/provider.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';
import 'package:hgeology_app/gen/strings.g.dart';

// Here is the form page to create a project. Here is the project model.
// Please generate the form in Column widget based on this.
class NewProjectPage extends ConsumerStatefulWidget {
  final SharedMedia? sharePayload;
  const NewProjectPage({Key? key, this.sharePayload}) : super(key: key);

  @override
  ConsumerState<NewProjectPage> createState() => _NewProjectPageState();
}

class _NewProjectPageState extends ConsumerState<NewProjectPage> {
  bool _isProcessing = false;
  String? _errorText;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _managerIdController = TextEditingController();
  String? _selectedCategory;
  String? _selectedState;
  String? _selectedGrade;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildDropdown(String label, Map<String, String> options,
      ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      value: options.values
          .first, // Set the initial value to the first value of the options map
      onChanged: onChanged,
      items: options.entries
          .map((entry) => DropdownMenuItem<String>(
                value: entry.value,
                child: Text(entry.key),
              ))
          .toList(),
      validator: (value) => value == null ? 'Please select a $label' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: const LeadingBackButton(),
          title: Text("新建项目"),
          elevation: 0.0,
          backgroundColor: Theme.of(context).canvasColor,
          bottom: TabBar(
            tabs: [
              Tab(text: "创建项目"),
              Tab(text: "加入项目"),
            ],
          ),
        ),
        body: TabBarView(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 6),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: '项目名称'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter project name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  TextFormField(
                    controller: _serialNumberController,
                    decoration: const InputDecoration(labelText: '项目序列号'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter project serial number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  TextFormField(
                    controller: _managerIdController,
                    decoration: const InputDecoration(labelText: '项目经理ID'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter project manager ID';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  _buildDropdown(
                    '项目分类',
                    {
                      '地铁勘察类': 'Subway Survey',
                      '房建勘察类': 'House Building Survey',
                      '市政勘察类': 'Municipal Survey',
                      '规划勘察类': 'Planning Survey',
                      '桥梁勘察': 'Bridge Survey',
                      '机场勘察类': 'Airport Survey',
                      '公路勘察类': 'Highway Survey',
                    },
                    (newValue) => setState(() => _selectedCategory = newValue),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  _buildDropdown(
                    '项目阶段',
                    {
                      '初勘阶段': 'Initial Survey',
                      '详勘阶段': 'Detailed Survey',
                      '施工配合': 'Construction Cooperation',
                    },
                    (newValue) => setState(() => _selectedState = newValue),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  _buildDropdown(
                    '项目等级',
                    {
                      '甲级': 'Grade A',
                      '乙级': 'Grade B',
                      '丙级': 'Grade C',
                    },
                    (newValue) => setState(() => _selectedGrade = newValue),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Process form data
                      }
                    },
                    child: const Text('提交'),
                  ),
                ],
              ),
            ),
          ),
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 13.0, vertical: 6),
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _searchController,
                        decoration: InputDecoration(hintText: "项目序列号"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FloatingActionButton(
                        onPressed: () {},
                        child: const Icon(Icons.arrow_forward),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.qr_code),
                              SizedBox(
                                width: 12,
                              ),
                              Text("扫描二维码")
                            ]),
                      ),
                    ]),
              )),
        ]),
      ),
    );
  }
}
