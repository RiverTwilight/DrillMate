import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_handler/share_handler.dart';
import 'package:hgeology_app/constants.dart';
import 'package:hgeology_app/pages/new_media_page.dart';
import 'package:hgeology_app/pages/tabs/memo_library_tab.dart';
import 'package:hgeology_app/pages/tabs/more_tab.dart';
import 'package:hgeology_app/pages/review_page.dart';
import 'package:hgeology_app/widget/bottom_nav.dart';
import 'package:hgeology_app/pages/tabs/project_library_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/widget/introduction.dart';
import 'package:hgeology_app/widget/dialog/intro_oral.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hgeology_app/pages/tabs/statistic_tab.dart';
import 'package:hgeology_app/widget/typing_text.dart';
import 'package:hgeology_app/init.dart';
import 'package:hgeology_app/gen/strings.g.dart';

void showIntroductionBottomSheet(BuildContext context) {
  final PageController pageController = PageController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.zero),
    ),
    builder: (BuildContext bc) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: IntroductionWidget(
          pageController: pageController,
          pages: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  TypingText(
                    loop: true,
                    text: const ['Hello', "你好", "こんにちは", "안녕하세요", "Bonjour"],
                    duration: const Duration(milliseconds: 150),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.fastEaseInToSlowEaseOut);
                    },
                    child: const Icon(Icons.arrow_forward),
                  )
                ],
              ),
            ),
            UsageIntroduction(handleNextPage: () {
              pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastEaseInToSlowEaseOut);
            }),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "./assets/illustrations/undraw_things_to_say_re_jpcg.svg",
                        width: 120,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Text(
                        t.dialog.introduction.page_3.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Text(t.dialog.introduction.page_3.body),
                      const SizedBox(
                        height: 20,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_downward),
                      )
                    ]),
              ),
            )
          ],
          onFinished: () {
            // Navigator.pop(context); // Close the bottom sheet when finished
          },
        ),
      );
    },
  );
}

enum HomeTab {
  library(Icons.ondemand_video_rounded),
  review(Icons.import_contacts_rounded),
  statistic(Icons.data_saver_off_rounded),
  more(Icons.widgets_rounded);

  const HomeTab(this.icon);

  final IconData icon;
}

List<CustomBottomNavigationBarItem> bottomNavigationBarItems = [
  CustomBottomNavigationBarItem(
    icon: HomeTab.values[0].icon,
    title: t.mediaLibraryTab.tabName,
  ),
  CustomBottomNavigationBarItem(
    icon: HomeTab.values[1].icon,
    title: t.reviewTab.title,
  ),
  CustomBottomNavigationBarItem(
    icon: HomeTab.values[2].icon,
    title: t.statisticTab.title,
  ),
  CustomBottomNavigationBarItem(
    icon: HomeTab.values[3].icon,
    title: t.moreTab.title,
  )
];

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

final List<Widget> _pages = [
  const ProjectLibraryPage(),
  const BookmarkLibraryPage(),
  StatisticPage(),
  const MorePage(),
];

class _HomePageState extends ConsumerState<HomePage> {
  HomeTab _currentTab = HomeTab.library;
  bool _initialized = false;

  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  void _goToPage(SharedMedia payload) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewMediaPage(
          sharePayload: payload,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await postInit(context, ref, true, _goToPage);
    });
  }

  void initializeAsyncTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('first_time')) {
        // ignore: use_build_context_synchronously
        showIntroductionBottomSheet(context);
      }
      await prefs.setBool('first_time', false);
      if (prefs.containsKey(verifyBackupKey)) {
        // TODO Re-invoke veiry
      }
    } catch (e) {
      // print('An error occurred: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      initializeAsyncTasks();
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Widget body = PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
          onPageChanged: (index) {
            setState(() {
              _currentTab = HomeTab.values[index];
            });
          },
        );

        if (constraints.maxWidth > 600) {
          // Larger screen
          return Scaffold(
            body: Row(
              children: [
                CustomBottomNavigationBar(
                  currentIndex: _currentTab.index,
                  onTap: _onItemTapped,
                  items: bottomNavigationBarItems,
                ),
                Expanded(
                  child: body,
                ),
              ],
            ),
          );
        } else {
          // Smaller screen
          return Scaffold(
            body: body,
            bottomNavigationBar: CustomBottomNavigationBar(
              currentIndex: _currentTab.index,
              onTap: _onItemTapped,
              items: bottomNavigationBarItems,
            ),
          );
        }
      },
    );
  }
}
