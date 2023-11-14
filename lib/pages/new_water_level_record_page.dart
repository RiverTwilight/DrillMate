import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hgeology_app/pages/take_picture_screen.dart';
import 'package:hgeology_app/widget/card_base.dart';
import 'package:share_handler/share_handler.dart';
import 'package:hgeology_app/pages/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';
import 'package:hgeology_app/gen/strings.g.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class NewWaterLevelRecordPage extends ConsumerStatefulWidget {
  final SharedMedia? sharePayload;
  const NewWaterLevelRecordPage({Key? key, this.sharePayload})
      : super(key: key);

  @override
  ConsumerState<NewWaterLevelRecordPage> createState() =>
      _NewWaterLevelRecordPageState();
}

class _NewWaterLevelRecordPageState
    extends ConsumerState<NewWaterLevelRecordPage> {
  bool _isProcessing = false;
  String? _errorText;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  String _type = 'Default'; // Default type
  int _waterLevelLayerNum = 1; // Default layer number
  DateTime _recordTime = DateTime.now();
  final List<File> _photos = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _takePhoto() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TakePictureScreen(camera: firstCamera)),
    );

    if (result != null) {
      setState(() {
        _photos.add(File(result));
      });
    }
  }

  Future<void> _pickPhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _photos.add(File(pickedFile.path));
      });
    }
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
          title: Text("新建水位记录"),
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
                icon: const Icon(Icons.check))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(
                  height: 12,
                ),
                DropdownButtonFormField<String>(
                  value: _type,
                  onChanged: (newValue) => setState(() => _type = newValue!),
                  items: <String>['Default', 'Type 1', 'Type 2']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: '地下水类型'),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: '水位层号'),
                  initialValue: '$_waterLevelLayerNum',
                  keyboardType: TextInputType.number,
                  onSaved: (value) =>
                      _waterLevelLayerNum = int.tryParse(value ?? '') ?? 1,
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: '地下水深（m）'),
                  initialValue: '$_waterLevelLayerNum',
                  keyboardType: TextInputType.number,
                  onSaved: (value) =>
                      _waterLevelLayerNum = int.tryParse(value ?? '') ?? 1,
                ),
                const SizedBox(
                  height: 12,
                ),
                ListTile(
                  title: Text('记录时间: ${_recordTime.toIso8601String()}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _recordTime,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2025),
                    );
                    if (picked != null && picked != _recordTime) {
                      setState(() {
                        _recordTime = picked;
                      });
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child: CardBase(
                      child: InkWell(
                        onTap: _takePhoto,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Column(children: [
                            Icon(
                              Icons.camera_alt,
                              color: Colors.blue[800],
                            ),
                            Text("拍摄照片"),
                          ]),
                        ),
                      ),
                    )),
                    Expanded(
                        child: CardBase(
                      child: InkWell(
                        onTap: _pickPhoto,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Column(children: [
                            Icon(
                              Icons.photo,
                              color: Colors.blue[800],
                            ),
                            Text("选择照片"),
                          ]),
                        ),
                      ),
                    )),
                  ],
                ),
                ..._photos.map((photo) => Image.file(photo)).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
