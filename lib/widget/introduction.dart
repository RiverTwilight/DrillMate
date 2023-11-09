import 'package:flutter/material.dart';

class IntroductionWidget extends StatefulWidget {
  final List<Widget> pages;
  final VoidCallback onFinished;
  final PageController pageController;

  IntroductionWidget({
    required this.pages,
    required this.onFinished,
    required this.pageController,
    Key? key,
  }) : super(key: key);

  @override
  _IntroductionWidgetState createState() => _IntroductionWidgetState();
}

class _IntroductionWidgetState extends State<IntroductionWidget> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(() {
      final nextPage = widget.pageController.page!.round();
      if (nextPage != currentPageIndex) {
        setState(() {
          currentPageIndex = nextPage;
        });
        if (nextPage == widget.pages.length - 1) {
          widget.onFinished();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          LinearProgressIndicator(
            minHeight: 8,
            value: (currentPageIndex + 1) / widget.pages.length,
          ),
          Expanded(
            child: PageView(
              controller: widget.pageController,
              children: widget.pages,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.pageController.dispose();
    super.dispose();
  }
}
