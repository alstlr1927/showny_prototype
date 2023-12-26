import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_setting_test/camera/next_page.dart';
import 'package:flutter_setting_test/camera/provider/camera_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class CameraTest extends StatefulWidget {
  const CameraTest({super.key});

  @override
  State<CameraTest> createState() => _CameraTestState();
}

class _CameraTestState extends State<CameraTest> {
  late CameraProvider provider;
  @override
  void initState() {
    provider = CameraProvider(this);
    super.initState();
  }

  @override
  void dispose() {
    provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CameraProvider>.value(
      value: provider,
      builder: (context, _) {
        return Consumer<CameraProvider>(
          builder: (ctx, prov, child) {
            return Scaffold(
              // appBar: AppBar(),
              body: Builder(
                builder: (context) {
                  if (prov.isLoad) {
                    return Container();
                  } else {
                    print('load finish');
                    return Column(
                      children: [
                        Container(
                          height: 100,
                        ),
                        Expanded(
                          child: CameraAwesomeBuilder.custom(
                            builder: (cameraState, preview) {
                              return cameraState.when(
                                onPreparingCamera: (state) => const Center(
                                    child: CircularProgressIndicator()),
                                onPhotoMode: (state) {
                                  return TakePhotoUI(state);
                                },
                                onVideoMode: (state) =>
                                    RecordVideoUI(state, recording: false),
                                onVideoRecordingMode: (state) =>
                                    RecordVideoUI(state, recording: true),
                              );
                            },
                            saveConfig: SaveConfig.photoAndVideo(
                              initialCaptureMode: CaptureMode.photo,
                              videoOptions: VideoOptions(
                                enableAudio: true,
                                ios: CupertinoVideoOptions(
                                  fps: 30,
                                ),
                                android: AndroidVideoOptions(
                                  bitrate: 6000000,
                                  fallbackStrategy:
                                      QualityFallbackStrategy.higher,
                                ),
                              ),
                              exifPreferences:
                                  ExifPreferences(saveGPSLocation: false),
                            ),
                            sensorConfig: SensorConfig.single(
                              aspectRatio: CameraAspectRatios.ratio_16_9,
                              zoom: 0.0,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}

class TakePhotoUI extends StatefulWidget {
  final PhotoCameraState state;

  const TakePhotoUI(this.state, {super.key});

  @override
  State<TakePhotoUI> createState() => _TakePhotoUIState();
}

class _TakePhotoUIState extends State<TakePhotoUI> {
  @override
  void initState() {
    print('photo init');
    super.initState();
  }

  String path = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 9 / 16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _takeButton(),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.state.setState(CaptureMode.photo);
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 10,
                        height: 2,
                        color: widget.state.captureMode == CaptureMode.photo
                            ? Colors.black
                            : Colors.transparent,
                        margin: const EdgeInsets.only(bottom: 5),
                      ),
                      Text(
                        '사진',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: widget.state.captureMode == CaptureMode.photo
                              ? Colors.black
                              : Colors.black.withOpacity(.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                GestureDetector(
                  onTap: () {
                    widget.state.setState(CaptureMode.video);
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 10,
                        height: 2,
                        color: widget.state.captureMode == CaptureMode.video
                            ? Colors.black
                            : Colors.transparent,
                        margin: const EdgeInsets.only(bottom: 5),
                      ),
                      Text(
                        '동영상',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: widget.state.captureMode == CaptureMode.video
                              ? Colors.black
                              : Colors.black.withOpacity(.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _takeButton() {
    return GestureDetector(
      onTap: () {
        widget.state.when(
          onPhotoMode: (photoState) => photoState.takePhoto().then((value) {
            value.when(single: (request) {
              print('path : ${request.file?.path}');
              path = request.file?.path ?? '';
              setState(() {});
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NextPage(path: path),
                  ));
            });
          }),
        );
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 60,
          height: 60,
          margin: const EdgeInsets.only(bottom: 22),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Colors.white)),
              ),
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecordVideoUI extends StatefulWidget {
  final CameraState state;
  final bool recording;

  const RecordVideoUI(this.state, {super.key, required this.recording});

  @override
  State<RecordVideoUI> createState() => _RecordVideoUIState();
}

class _RecordVideoUIState extends State<RecordVideoUI> {
  @override
  void initState() {
    print('video init');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('recording : ${widget.recording}');
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AspectRatio(
          aspectRatio: 9 / 16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _takeButton(),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.state.setState(CaptureMode.photo);
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 10,
                        height: 2,
                        color: widget.state.captureMode == CaptureMode.photo
                            ? Colors.black
                            : Colors.transparent,
                        margin: const EdgeInsets.only(bottom: 5),
                      ),
                      Text(
                        '사진',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: widget.state.captureMode == CaptureMode.photo
                              ? Colors.black
                              : Colors.black.withOpacity(.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 18),
                GestureDetector(
                  onTap: () {
                    widget.state.setState(CaptureMode.video);
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 10,
                        height: 2,
                        color: widget.state.captureMode == CaptureMode.video
                            ? Colors.black
                            : Colors.transparent,
                        margin: const EdgeInsets.only(bottom: 5),
                      ),
                      Text(
                        '동영상',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: widget.state.captureMode == CaptureMode.video
                              ? Colors.black
                              : Colors.black.withOpacity(.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _takeButton() {
    return GestureDetector(
      onTap: () {
        widget.state.when(
          onPhotoMode: (photoState) => photoState.takePhoto(),
          onVideoMode: (videoState) => videoState.startRecording(),
          onVideoRecordingMode: (videoState) => videoState.stopRecording(),
        );
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 60,
          height: 60,
          margin: const EdgeInsets.only(bottom: 22),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(width: 1, color: Colors.white)),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: widget.recording ? 20 : 50,
                height: widget.recording ? 20 : 50,
                decoration: BoxDecoration(
                  color: const Color(0xffF14545),
                  borderRadius: !widget.recording
                      ? BorderRadius.circular(200)
                      : BorderRadius.zero,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomMediaPreview extends StatelessWidget {
  final MediaCapture? mediaCapture;
  final OnMediaTap onMediaTap;

  const CustomMediaPreview({
    super.key,
    required this.mediaCapture,
    required this.onMediaTap,
  });

  @override
  Widget build(BuildContext context) {
    return AwesomeOrientedWidget(
      child: AspectRatio(
        aspectRatio: 1,
        child: AwesomeBouncingWidget(
          onTap: mediaCapture != null && onMediaTap != null
              ? () => onMediaTap!(mediaCapture!)
              : null,
          child: ClipOval(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white10,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white38,
                  width: 2,
                ),
              ),
              child: Container(
                color: Colors.transparent,
                child: _buildMedia(mediaCapture),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMedia(MediaCapture? mediaCapture) {
    switch (mediaCapture?.status) {
      case MediaCaptureStatus.capturing:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Platform.isIOS
                ? const CupertinoActivityIndicator(color: Colors.white)
                : const CircularProgressIndicator(color: Colors.white),
          ),
        );
      case MediaCaptureStatus.success:
        if (mediaCapture!.isPicture) {
          if (kIsWeb) {
            // TODO Check if that works
            return FutureBuilder<Uint8List>(
                future: mediaCapture.captureRequest.when(
                  single: (single) => single.file!.readAsBytes(),
                  multiple: (multiple) =>
                      multiple.fileBySensor.values.first!.readAsBytes(),
                ),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return Image.memory(
                      snapshot.requireData,
                      fit: BoxFit.cover,
                      width: 300,
                    );
                  } else {
                    return Platform.isIOS
                        ? const CupertinoActivityIndicator(
                            color: Colors.white,
                          )
                        : const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          );
                  }
                });
          } else {
            return Image(
              fit: BoxFit.cover,
              image: ResizeImage(
                FileImage(
                  File(
                    mediaCapture.captureRequest.when(
                      single: (single) => single.file!.path,
                      multiple: (multiple) =>
                          multiple.fileBySensor.values.first!.path,
                    ),
                  ),
                ),
                width: 300,
              ),
            );
          }
        } else {
          return Ink(
            child: MiniVideoPlayer(
              filePath: mediaCapture.captureRequest.when(
                single: (single) => single.file!.path,
                multiple: (multiple) =>
                    multiple.fileBySensor.values.first!.path,
              ),
            ),
          );
        }
      case MediaCaptureStatus.failure:
        return const Icon(Icons.error);
      case null:
        return const SizedBox(
          width: 32,
          height: 32,
        );
    }
  }
}

class MiniVideoPlayer extends StatefulWidget {
  final String filePath;

  const MiniVideoPlayer({super.key, required this.filePath});

  @override
  State<StatefulWidget> createState() {
    return _MiniVideoPlayer();
  }
}

class _MiniVideoPlayer extends State<MiniVideoPlayer> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((value) => setState(() {
            _controller?.setLooping(true);
            _controller?.play();
          }));
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || _controller?.value.isInitialized != true) {
      return const Center(child: CircularProgressIndicator());
    }
    return VideoPlayer(_controller!);
  }
}
