import 'package:flutter_svg/flutter_svg.dart';
import 'package:hgeology_app/pages/tabs/contact_tab.dart';
import 'package:share_handler/share_handler.dart';
import 'package:hgeology_app/constants.dart';
import 'package:hgeology_app/pages/new_project_page.dart';
import 'package:hgeology_app/pages/tabs/hole_library_tab.dart';
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

enum HomeTab {
  library(Icons.file_copy),
  review(Icons.hive_outlined),
  contact(Icons.supervised_user_circle_rounded),
  more(Icons.widgets_rounded);

  const HomeTab(this.icon);

  final IconData icon;
}

List<CustomBottomNavigationBarItem> bottomNavigationBarItems = [
  CustomBottomNavigationBarItem(
    icon: HomeTab.values[0].icon,
    title: t.projectLibraryTab.tabName,
  ),
  CustomBottomNavigationBarItem(
    icon: HomeTab.values[1].icon,
    title: t.holeListTab.tabName,
  ),
  CustomBottomNavigationBarItem(
    icon: HomeTab.values[2].icon,
    title: t.contactTab.tabName,
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
  const HoleLibraryPage(),
  const ContactPage(),
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
        builder: (context) => NewProjectPage(
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
        // showIntroductionBottomSheet(context);
        // Uncomment the above line to enable introdcution page
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
