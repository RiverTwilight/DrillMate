import 'package:flutter/material.dart';

import 'raw_bilibili_player.dart';
import '../utils/errors.dart';
import '../utils/bilibili_player_controller.dart';
import '../utils/bilibili_meta_data.dart';

class BilibiliPlayer extends StatefulWidget {
  /// Sets [Key] as an identification to underlying web view associated to the player.
  final Key? key;

  /// A [BilibiliPlayerController] to control the player.
  final BilibiliPlayerController controller;

  final double? width;

  final double aspectRatio;

  final VoidCallback? onReady;

  final void Function(BilibiliMetaData metaData)? onEnded;

  const BilibiliPlayer({
    this.key,
    required this.controller,
    this.onReady,
    this.onEnded,
    this.aspectRatio = 16 / 9,
    this.width,
  });

  @override
  _BilibiliPlayerState createState() => _BilibiliPlayerState();
}

class _BilibiliPlayerState extends State<BilibiliPlayer> {
  late BilibiliPlayerController controller;

  late double _aspectRatio;
  bool _initialLoad = true;

  @override
  void initState() {
    super.initState();
    controller = widget.controller..addListener(listener);
    _aspectRatio = widget.aspectRatio;
  }

  @override
  void didUpdateWidget(BilibiliPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.controller.removeListener(listener);
    widget.controller.addListener(listener);
  }

  void listener() async {
    if (controller.value.isReady && _initialLoad) {
      _initialLoad = false;
      if (controller.flags.autoPlay) controller.play();
      if (controller.flags.mute) controller.mute();
      widget.onReady?.call();
      if (controller.flags.controlsVisibleAtStart) {
        controller.updateValue(
          controller.value.copyWith(isControlsVisible: true),
        );
      }
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    super.dispose();
  }

  Widget _buildPlayer({required Widget errorWidget}) {
    return AspectRatio(
      aspectRatio: _aspectRatio,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Transform.scale(
            scale: controller.value.isFullScreen
                ? (1 / _aspectRatio * MediaQuery.of(context).size.width) /
                    MediaQuery.of(context).size.height
                : 1,
            child: RawBilibiliPlayer(
              key: widget.key,
              onEnded: (BilibiliMetaData metaData) {
                if (controller.flags.loop) {
                  controller.load(controller.metadata.videoId,
                      startAt: controller.flags.startAt,
                      endAt: controller.flags.endAt);
                }

                // widget.onEnded?.call(metaData);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: Colors.black,
      child: InheritedBilibiliPlayer(
        controller: controller,
        child: Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width,
          child: _buildPlayer(
            errorWidget: Container(
              color: Colors.black87,
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 5.0),
                      Expanded(
                        child: Text(
                          errorString(
                            controller.value.errorCode,
                            videoId: controller.metadata.videoId.isNotEmpty
                                ? controller.metadata.videoId
                                : controller.initialVideoId,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Error Code: ${controller.value.errorCode}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BilibiliPlayerBuilderState extends State<BilibiliPlayerBuilder>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.player;
  }
}

class BilibiliPlayerBuilder extends StatefulWidget {
  final BilibiliPlayer player;
  final Widget Function(BuildContext context, Widget player) builder;

  const BilibiliPlayerBuilder({
    Key? key,
    required this.player,
    required this.builder,
  }) : super(key: key);

  @override
  _BilibiliPlayerBuilderState createState() => _BilibiliPlayerBuilderState();
}
