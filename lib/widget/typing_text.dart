import 'package:flutter/material.dart';

class TypingText extends StatefulWidget {
  final List<String> text;
  final Duration duration;
  final TextStyle? style;
  final bool loop;

  TypingText({
    required this.text,
    this.duration = const Duration(milliseconds: 50),
    this.loop = false,
    required this.style,
  });

  @override
  _TypingTextState createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<int> _characterCount;
  late List<String> _currentTexts = List.filled(widget.text.length, "");
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _initTypingAnimation();
  }

  @override
  void didUpdateWidget(TypingText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if ((oldWidget.text == widget.text)) {
      _animationController.dispose();
      _currentTexts = List.filled(widget.text.length, "");
      _currentIndex = 0;
      _initTypingAnimation();
    }
  }

  void _initTypingAnimation() {
    _animationController = AnimationController(
      duration: widget.duration * widget.text[_currentIndex].length,
      vsync: this,
    );

    _characterCount = StepTween(
      begin: 0,
      end: widget.text[_currentIndex].length,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print("Comple");
        if (_currentIndex < widget.text.length - 1) {
          Future.delayed(Duration(seconds: 1)).then((_) {
            if (mounted) {
              setState(() {
                _currentIndex++;
              });
              _animationController.dispose();
              _initTypingAnimation();
            }
          });
        } else if (widget.loop) {
          Future.delayed(Duration(seconds: 1)).then((_) {
            if (mounted) {
              setState(() {
                _currentIndex = 0;
              });
              _animationController.dispose();
              _initTypingAnimation();
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _characterCount,
      builder: (BuildContext context, Widget? child) {
        String displayText;
        if (_animationController.isAnimating) {
          int count = _characterCount.value;
          displayText = widget.text[_currentIndex].substring(0, count);
        } else {
          displayText = widget.text[_currentIndex];
        }
        return Text(
          displayText,
          style: widget.style,
          overflow: TextOverflow.visible,
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
