import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:hgeology_app/constants.dart';
import 'package:hgeology_app/pages/transcription.page.dart';
import 'package:hgeology_app/provider/media_provider.dart';
import 'package:hgeology_app/utils/speech_recognizer.dart';
import 'package:hgeology_app/widget/card_base.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_handler/share_handler.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HoleDetailPage extends ConsumerStatefulWidget {
  final SharedMedia? sharePayload;
  const HoleDetailPage({Key? key, this.sharePayload}) : super(key: key);

  @override
  ConsumerState<HoleDetailPage> createState() => _HoleDetailPageState();
}

class _HoleDetailPageState extends ConsumerState<HoleDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: const LeadingBackButton(),
          title: Text("勘探详情"),
          elevation: 0.0,
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 0),
          child: ListView(
            children: [
              // Icon buttons with text labels
              CardBase(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _iconButton(Icons.map, "Map"),
                      _iconButton(Icons.camera, "Camera"),
                      _iconButton(Icons.folder, "Folder"),
                      _iconButton(Icons.info, "Info"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton:
            _buildSpeedDial(), // Floating action button with sub-buttons
      ),
    );
  }

  Widget _iconButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: () {
            // Add your icon button action here
          },
        ),
        Text(label),
      ],
    );
  }

  SpeedDial _buildSpeedDial() {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      children: [
        SpeedDialChild(
          child: Icon(Icons.upload),
          label: 'Upload',
          onTap: () => print('Upload Pressed'),
        ),
        SpeedDialChild(
          child: Icon(Icons.add),
          label: 'Add',
          onTap: () => print('Add Pressed'),
        ),
      ],
    );
  }
}
