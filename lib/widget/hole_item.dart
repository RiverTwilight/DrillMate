import 'package:flutter/material.dart';
import 'package:hgeology_app/models/hole.dart';
import 'package:hgeology_app/widget/plus_badage.dart';

class HoleItem extends StatefulWidget {
  final Hole hole;
  final Function(Hole) onNavigate;

  const HoleItem({
    required this.hole,
    required this.onNavigate,
    super.key,
  });

  @override
  _HoleItemState createState() => _HoleItemState();
}

class _HoleItemState extends State<HoleItem> {
  bool _showActions = false;

  void _toggleActions() {
    setState(() {
      _showActions = !_showActions;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.hole.holeType);

    return Card(
      elevation: 1,
      child: InkWell(
        onTap: () {
          if (_showActions) {
            widget.onNavigate(widget.hole);
          } else {
            _toggleActions();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.hole.holeType ?? 'Unknown Type',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PlusBadge()
                ],
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    '设计深度: ${widget.hole.designDepth ?? 'N/A'}m',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '距离: ${widget.hole.offsetDistance ?? '124KM'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Created on: ${widget.hole.createdOn.toIso8601String()}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              if (_showActions)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionButton(context, Icons.mic, '记录', () {}),
                    _actionButton(context, Icons.cloud_upload, '上传', () {}),
                    _actionButton(context, Icons.bar_chart, '图表', () {}),
                    _actionButton(context, Icons.more_horiz, '更多', () {}),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton(BuildContext context, IconData icon, String label,
      VoidCallback onPressed) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            Text(label),
          ],
        ),
      ),
    );
  }
}
