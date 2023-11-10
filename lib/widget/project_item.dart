import 'package:flutter/material.dart';
import 'package:hgeology_app/models/project.dart';

class ProjectItem extends StatelessWidget {
  final Project project;
  final Function(Project) onEdit;
  final Function(Project) onDelete;

  const ProjectItem({
    required this.project,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.projectName ??
                  'No name', // Fallback if projectName is null
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              project.createdOn ??
                  'Unknown date', // Fallback if createdOn is null
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 6),
            Text(
              project.projectSerialNumber ??
                  'No serial number', // Fallback if projectSerialNumber is null
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton.icon(
                    icon: Icon(Icons.list_alt_rounded),
                    label: Text('勘探列表'),
                    onPressed: () => onEdit(project),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    icon: Icon(Icons.upload),
                    label: Text('数据上传'),
                    onPressed: () => onDelete(project),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
