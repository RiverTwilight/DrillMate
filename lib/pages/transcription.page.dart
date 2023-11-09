import 'package:flutter/material.dart';
import 'package:hgeology_app/widget/leading_back_button.dart';

class TranscriptionPage extends StatelessWidget {
  final List<Map<String, dynamic>> subtitles;

  TranscriptionPage({required this.subtitles});

  String getFullText(List<Map<String, dynamic>> subtitles) {
    List<String> words = [];

    for (var subtitle in subtitles) {
      words.add(subtitle['text']);
    }

    return words.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const LeadingBackButton(),
        title: Text('Transcription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            getFullText(subtitles),
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
