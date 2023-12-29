import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class StyleUpVideoItem extends StatefulWidget {
  final String videoPath;
  const StyleUpVideoItem({
    Key? key,
    required this.videoPath,
  }) : super(key: key);

  @override
  State<StyleUpVideoItem> createState() => _StyleUpVideoItemState();
}

class _StyleUpVideoItemState extends State<StyleUpVideoItem> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('${widget.videoPath}');
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    // _controller.play();
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoPath),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 0) {
          _controller.pause();
        } else {
          _controller.play();
        }
      },
      child: VideoPlayer(_controller),
    );
  }
}
