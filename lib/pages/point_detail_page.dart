import 'package:flutter/material.dart';
import 'package:hgeology_app/pages/form/new_hole_page.dart';
import 'package:hgeology_app/pages/form/new_mark_record_page.dart';
import 'package:hgeology_app/pages/form/new_sample_record_page.dart';
import 'package:hgeology_app/pages/form/stop_hole_apply_page.dart';
import 'package:hgeology_app/pages/new_rock_record_page.dart';
import 'package:hgeology_app/pages/new_water_level_record_page.dart';
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
          title: Text("勘探点详情"),
          elevation: 0.0,
          backgroundColor: Theme.of(context).canvasColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 0),
          child: ListView(
            children: [
              CardBase(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _iconButton(Icons.map, "开孔", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StopHoleApplyPage(),
                          ),
                        );
                      }),
                      _iconButton(Icons.camera, "探头参数", () {}),
                      _iconButton(Icons.folder, "探头检测", () {}),
                      _iconButton(Icons.stop_circle_rounded, "终孔", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StopHoleApplyPage(),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _buildSpeedDial(),
      ),
    );
  }

  Widget _iconButton(IconData icon, String label, void Function() onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
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
          child: const Icon(Icons.drive_file_rename_outline_rounded),
          label: '回尺记录',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewBackRulerRecordPage(),
              ),
            );
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.grain),
          label: '岩土记录',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewRockRecordPage(),
              ),
            );
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.water),
          label: '水位记录',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewWaterLevelRecordPage(),
              ),
            );
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.label),
          label: '标贯记录',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewMarkRecordPage(),
              ),
            );
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.sell_sharp),
          label: '取样记录',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewSampleRecordPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}
