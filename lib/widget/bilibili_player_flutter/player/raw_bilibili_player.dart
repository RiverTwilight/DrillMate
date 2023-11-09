import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'bilibili_player.dart';
import '../enums/player_state.dart';
import '../utils/bilibili_meta_data.dart';
import '../utils/bilibili_player_controller.dart';

// Get all state by running
// `nano.EventType` in the console of the webview
// Find more methods here: https://player.bilibili.com/player.html?aid=701755455&bvid=BV12m4y1x7Lw&cid=1223171961&page=1
// This url will be redirected to the mobile version if you set the UA to mobile device

/// A raw Bilibili player widget which interacts with the underlying webview inorder to play Bilibili videos.
///
/// Use [BilibiliPlayer] instead.
class RawBilibiliPlayer extends StatefulWidget {
  /// Sets [Key] as an identification to underlying web view associated to the player.
  final Key? key;

  /// {@macro Bilibili_player_flutter.onEnded}
  final void Function(BilibiliMetaData metaData)? onEnded;

  /// Creates a [RawBilibiliPlayer] widget.
  RawBilibiliPlayer({
    this.key,
    this.onEnded,
  });

  @override
  _RawBilibiliPlayerState createState() => _RawBilibiliPlayerState();
}

class _RawBilibiliPlayerState extends State<RawBilibiliPlayer>
    with WidgetsBindingObserver {
  BilibiliPlayerController? controller;
  PlayerState? _cachedPlayerState;
  bool _isPlayerReady = false;
  bool _onLoadStopCalled = false;

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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_cachedPlayerState != null &&
            _cachedPlayerState == PlayerState.playing) {
          controller?.play();
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        _cachedPlayerState = controller!.value.playerState;
        controller?.pause();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    controller = BilibiliPlayerController.of(context);
    return IgnorePointer(
      ignoring: true,
      child: InAppWebView(
        key: widget.key,
        initialData: InAppWebViewInitialData(
          data: player,
          baseUrl: Uri.parse('https://www.bilibili.com'),
          encoding: 'utf-8',
          mimeType: 'text/html',
        ),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            userAgent: userAgent,
            mediaPlaybackRequiresUserGesture: false,
            transparentBackground: true,
            disableContextMenu: true,
            supportZoom: false,
            disableHorizontalScroll: false,
            disableVerticalScroll: false,
            useShouldOverrideUrlLoading: true,
          ),
          ios: IOSInAppWebViewOptions(
            allowsInlineMediaPlayback: true,
            allowsAirPlayForMediaPlayback: true,
            allowsPictureInPictureMediaPlayback: true,
          ),
          android: AndroidInAppWebViewOptions(
            useWideViewPort: false,
            useHybridComposition: controller!.flags.useHybridComposition,
          ),
        ),
        onWebViewCreated: (webController) {
          controller!.updateValue(
            controller!.value.copyWith(webViewController: webController),
          );
          webController
            ..addJavaScriptHandler(
              handlerName: 'Player_Prepared',
              callback: (_) {
                _isPlayerReady = true;
                if (_onLoadStopCalled) {
                  controller!.updateValue(
                    controller!.value.copyWith(isReady: true),
                  );
                }
              },
            )
            ..addJavaScriptHandler(
              handlerName: 'Player_Ended',
              callback: (args) {
                widget.onEnded?.call(controller!.metadata);
                controller!.updateValue(
                  controller!.value.copyWith(
                    playerState: PlayerState.ended,
                  ),
                );
              },
            )
            ..addJavaScriptHandler(
              handlerName: 'Player_RateChange',
              callback: (args) {
                final num rate = args.first;
                controller!.updateValue(
                  controller!.value.copyWith(playbackRate: rate.toDouble()),
                );
              },
            )
            ..addJavaScriptHandler(
              handlerName: 'Player_Error',
              callback: (args) {
                controller!.updateValue(
                  controller!.value.copyWith(errorCode: int.parse(args.first)),
                );
              },
            )
            ..addJavaScriptHandler(
              handlerName: 'Player_Pause',
              callback: (args) {
                controller!.updateValue(
                  controller!.value.copyWith(
                    playerState: PlayerState.paused,
                    isPlaying: false,
                  ),
                );
              },
            )
            ..addJavaScriptHandler(
              handlerName: 'Player_Play',
              callback: (args) {
                controller!.updateValue(
                  controller!.value.copyWith(
                    playerState: PlayerState.playing,
                    isPlaying: true,
                  ),
                );
              },
            )
            ..addJavaScriptHandler(
              handlerName: 'Player_Seeked',
              callback: (args) {
                final position = args.first * 1000;
                // final num buffered = args.last;
                controller!.updateValue(
                  controller!.value.copyWith(
                    position: Duration(seconds: position.floor()),
                    // buffered: buffered.toDouble(),
                  ),
                );
              },
            )
            ..addJavaScriptHandler(
              handlerName: 'VideoData',
              callback: (args) {
                controller!.updateValue(
                  controller!.value.copyWith(
                      metaData: BilibiliMetaData.fromRawData(args.first)),
                );
              },
            )
            ..addJavaScriptHandler(
              handlerName: 'VideoTime',
              callback: (args) {
                final position = args.first * 1000;
                controller!.updateValue(
                  controller!.value.copyWith(
                    position: Duration(milliseconds: position.floor()),
                  ),
                );
              },
            );
        },
        onLoadStop: (_, __) {
          _onLoadStopCalled = true;
          if (_isPlayerReady) {
            controller!.updateValue(
              controller!.value.copyWith(isReady: true),
            );
          }
        },
      ),
    );
  }

  String get player => '''
    <!DOCTYPE html>
    <html>
    <head>
        <style>
            html,
            body {
                margin: 0;
                padding: 0;
                background-color: #000000;
                overflow: hidden;
                height: 100%;
                width: 100%;
                pointer-events: none;
            }
            #player {
                width: 100%;
                height: 100%;
                padding: 0;
                margin: 0;
            }
            .bp-svgicon, .gsl-play-mask {
              display: none!important;
            }
        </style>
        <script
          crossorigin="anonymous"
          src="//s1.hdslb.com/bfs/static/player/main/core.7c522393.js"
        ></script>
        <script src="//s1.hdslb.com/bfs/static/nc/nc-loader-2.11.4.min.js"></script>
        <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'>
    </head>
    <body>
        <div id="player"></div>
        <script>        
            (function (SP) {
                window['__NanoStaticHttpKey'] = true;
                if (SP.refer) {
                    alert("asdfasdf");
                    window['__NanoEmbedRefer'] = true;
                } 
                const element = document.getElementById('player');

                const featureList = new Set(['noSendingBar', 'noLayerShadow', 'noLightOff', 'noSEsDanmaku', 'noEncHttp']);
                const controlsList = new Set(['noScreenWide', 'noScreenWeb']);
                const getGroupKind = function () {
                    if (SP.kind) return SP.kind;
                    if (SP.episodeId) return nano.GroupKind.Pgc;
                    return nano.GroupKind.Ugc;
                };
                const getChannelKind = function () {
                    return nano.ChannelKind.Embedded_Other;
                };
                const config = {
                    iid: null,
                    aid: SP.aid,
                    cid: SP.cid,
                    bvid: SP.bvid,
                    seasonId: SP.seasonId,
                    episodeId: SP.episodeId,
                    element: element,
                    kind: getGroupKind(),
                    channelKind: getChannelKind(),
                    t: SP.t,
                    p: SP.page,
                    muted: SP.muted,
                    poster: SP.poster,
                    autoplay: SP.autoplay,
                    featureList: featureList,
                    controlsList: controlsList,
                    enableHEVC: true,
                    enableAV1: true,
                    enableWMP: false,
                };

                const player = window.player = nano.createPlayer(config);

                player.connect();

                // For mobile device
                document.querySelector('video').setAttribute('playsinline', true);
                document.querySelector('video').setAttribute('webkit-playsinline', true);

                if (SP.danmaku != null) {
                    if (SP.danmaku) {
                        player.danmaku.close();
                    } else {
                        player.danmaku.open();
                    }
                }
            })({
              bvid: '${controller!.initialVideoId}',
              page: 1,
              autoplay: ${boolean(value: controller!.flags.autoPlay)},
              enableDankumu: ${boolean(value: controller!.flags.enableDanmuku)},
            });

            function sendVideoData() {
                var videoData = {
                    'duration': player.getDuration(),
                    'videoId': '${controller!.initialVideoId}'
                };
                window.flutter_inappwebview.callHandler('VideoData', videoData);
            }

            function startSendCurrentTimeInterval() {
                timerId = setInterval(function () {
                    window.flutter_inappwebview.callHandler('VideoTime', player.getCurrentTime());
                }, 100);
            }

            player.on('Player_Canplay', function (event) {
                sendVideoData();
                startSendCurrentTimeInterval();

                // Don't know why this works, do not change.
                if(!!!${boolean(value: controller!.flags.enableDanmuku)}){
                    player.danmaku.close();
                }

                // Currently got 403, not wokring
                const sourceUrl = player.getMediaInfo().playUrl;

                window.flutter_inappwebview.callHandler('Player_Prepared', event);
            });

            function clearSvg(){
                try { Array.from(document.querySelectorAll('svg')).forEach(e => e.remove()) } catch (e) {  }
            }
            
            player.on('Player_Error', function (event) {
                window.flutter_inappwebview.callHandler('Player_Error', event);
            });

            player.on('Player_RateChange', function (event) {
                window.flutter_inappwebview.callHandler('Player_RateChange', event);
            });

            player.on('Player_Ended', function (event) {
                window.flutter_inappwebview.callHandler('Player_Ended', event);
            });

            player.on('Player_Pause', function (event) {               
                clearSvg();
                window.flutter_inappwebview.callHandler('Player_Pause', event);
            });

            player.on('Player_Play', function (event) {
                clearSvg();
                window.flutter_inappwebview.callHandler('Player_Play', event);
            });

            player.on('Player_Seeked', function (event) {
                window.flutter_inappwebview.callHandler('Player_Ended', player.getCurrentTime());
            });

            function openDanmuku(){
               player.danmaku.open();
               return '';
            }

            function closeDanmuku(){
               player.danmaku.close();
               return '';
            }

            function play() {
                player.play();
                return '';
            }

            function pause() {
                player.pause();
                return '';
            }

            function mute() {
                player.setMuted(true);
                return '';
            }

            function unMute() {
                player.setMuted(false);
                return '';
            }

            function seekTo(position, seekAhead) {
                player.seek(position, seekAhead);
                return '';
            }

            function setPlaybackRate(rate) {
                player.setPlaybackRate(rate);
                return '';
            }
        </script>
    </body>
    </html>
  ''';

  String boolean({required bool value}) => value == true ? "'1'" : "'0'";

  String get userAgent => controller!.flags.forceHD
      ? 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36'
      : '';
}
