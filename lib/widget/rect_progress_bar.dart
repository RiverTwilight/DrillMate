import 'package:flutter/material.dart';

class RectProgressBar extends StatefulWidget {
  final double progress;

  RectProgressBar({required this.progress});

  @override
  _RectProgressBarState createState() => _RectProgressBarState();
}

class _RectProgressBarState extends State<RectProgressBar> {
  ValueNotifier<double> _progressNotifier = ValueNotifier<double>(0.0);
  bool _firstListenerCall = true;
  bool _showChangeValue = false;

  @override
  void initState() {
    _progressNotifier.addListener(_progressListener);
    super.initState();
  }

  void _progressListener() {
    if (_firstListenerCall) {
      _firstListenerCall = false;
      return;
    }

    setState(() {
      _showChangeValue = true;
    });

    Future.delayed(const Duration(milliseconds: 1500)).then((_) {
      setState(() {
        _showChangeValue = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (widget.progress != _progressNotifier.value) {
      _progressNotifier.value = widget.progress;
    }

    return Row(
      children: [
        Icon(
          Icons.emoji_events_sharp,
          color: widget.progress < 1
              ? Theme.of(context).brightness == Brightness.dark
                  ? Colors.white12
                  : Colors.black12
              : Color.fromARGB(255, 234, 173, 76),
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: width > 600 ? 150 : 110,
          height: 12.0,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: LinearProgressIndicator(
              backgroundColor: const Color(0xffD9D9D9),
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              value: widget.progress,
            ),
          ),
        ),
        const SizedBox(width: 3),
        AnimatedOpacity(
          opacity: _showChangeValue ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Text(
            "+10",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontFamily: "SmileySans",
            ),
          ),
        )
      ],
    );
  }
}
