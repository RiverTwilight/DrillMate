import 'package:flutter/material.dart';
import 'package:hgeology_app/widget/card_base.dart';

class CustomDataTable extends StatelessWidget {
  final List<MapEntry<String, String>> data;

  const CustomDataTable({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardBase(
      child: InkWell(
        child: Column(children: [
          const SizedBox(
            height: 12,
          ),
          ...data
              .map((entry) => _buildDataRow(entry.key, entry.value))
              .toList(),
          const SizedBox(
            height: 12,
          ),
        ]),
      ),
    );
  }

  Widget _buildDataRow(String name, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
