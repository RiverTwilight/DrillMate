import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hgeology_app/gen/strings.g.dart';

class UsageIntroduction extends StatelessWidget {
  final VoidCallback handleNextPage;

  const UsageIntroduction({super.key, required this.handleNextPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              t.dialog.introduction.page_2.title,
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildListItem(
                  context,
                  './assets/illustrations/undraw_audio_player_re_cl20.svg',
                  t.dialog.introduction.page_2.feature_1.title,
                  t.dialog.introduction.page_2.feature_1.body,
                ),
                const SizedBox(
                  height: 24,
                ),
                _buildListItem(
                  context,
                  './assets/illustrations/undraw_video_streaming_re_v3qg.svg',
                  t.dialog.introduction.page_2.feature_2.title,
                  t.dialog.introduction.page_2.feature_2.body,
                ),
                const SizedBox(
                  height: 24,
                ),

                _buildListItem(
                  context,
                  './assets/illustrations/undraw_contemplating_re_ynec.svg',
                  t.dialog.introduction.page_2.feature_3.title,
                  t.dialog.introduction.page_2.feature_3.body,
                ),
                const SizedBox(
                  height: 24,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    t.dialog.introduction.page_2.footer,
                    textAlign: TextAlign.center,
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        handleNextPage();
                      },
                      child: Text(t.general.next),
                    ),
                  ],
                ),
                // Add more list items as needed
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context,
    String illustrationPath,
    String title,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            illustrationPath,
            width: 120,
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                Text(
                  subtitle,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
