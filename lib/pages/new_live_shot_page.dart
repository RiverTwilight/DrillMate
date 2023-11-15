import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hgeology_app/widget/card_base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/pages/take_picture_screen.dart';
import 'package:share_handler/share_handler.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class NewLiveShotPage extends ConsumerStatefulWidget {
  final SharedMedia? sharePayload;
  const NewLiveShotPage({Key? key, this.sharePayload}) : super(key: key);

  @override
  ConsumerState<NewLiveShotPage> createState() => _NewLiveShotPageState();
}

class _NewLiveShotPageState extends ConsumerState<NewLiveShotPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  String _description = "";
  final List<File> _photos = [];

  final List<String> _tags = [
    "编录员",
    "司钻员工",
    "描述员",
    "项目负责人",
    "工程师",
    "钻机设备",
    "其他"
  ];
  final List<String> _selectedTags = ["编录员"];

  void _handleTagSelection(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text("现场拍照"),
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
                icon: Icon(Icons.check))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Wrap(
                  spacing: 6.0,
                  children: _tags.map((tag) {
                    final isSelected = _selectedTags.contains(tag);
                    return FilterChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (_) => _handleTagSelection(tag),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: '备注'),
                  initialValue: '$_description',
                  keyboardType: TextInputType.text,
                  onSaved: (value) => _description = value ?? "",
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: CardBase(
                      child: InkWell(
                        onTap: _takePhoto,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
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
