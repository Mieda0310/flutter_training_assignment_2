import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SimpleVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const SimpleVideoPlayer({super.key, required this.videoUrl});

  @override
  State<SimpleVideoPlayer> createState() => _SimpleVideoPlayerState();
}

class _SimpleVideoPlayerState extends State<SimpleVideoPlayer> {
  late VideoPlayerController controller;
  bool isReady = false;

  @override
  void initState() {
    super.initState();

    // 動画再生コントローラーに動画を渡し、再生時にplayで再生可能
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

    _init();
  }

  // クラスを呼んだ時に自動で発火させている
  Future<void> _init() async {
    await controller.initialize();

    if (!mounted) return;

    setState(() {
      isReady = true;
    });

    // ページ遷移時に自動再生するならコメントアウトを外しておく
    // controller.play();

    // 動画再生終了時に検知する
    controller.addListener(videoListener);
  }

  @override
  void dispose() {
    controller.removeListener(videoListener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return const Center(child: CircularProgressIndicator());
    }

    // StackとはWidgetを重ねて表示するもの
    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
        IconButton(
          onPressed: () {
            // 動画再生ON・OFFを切り替え
            setState(() {
              if (controller.value.isPlaying) {
                controller.pause();
              } else {
                controller.play();
              }
            });
          },
          icon: Icon(
            controller.value.isPlaying
                ? Icons.pause_circle_filled
                : Icons.play_circle_fill,
            size: 64,
            color: controller.value.isPlaying ? Colors.white12 : Colors.white60,
          ),
        ),
      ],
    );
  }

  void videoListener() {
    if (controller.value.position >= controller.value.duration) {
      // 動画終了した際に再生ボタンに切り替える
      controller.pause();
      controller.seekTo(Duration.zero);

      setState(() {});
    }
  }
}
