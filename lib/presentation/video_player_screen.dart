import 'package:ar_industrial/core/utils/size_utils.dart';
import 'package:ar_industrial/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatelessWidget {
  final VideoPlayerController controller;
  final Future<void> initializeFuture;
  final VoidCallback onTap;
  final bool isPlaying;

  const VideoPlayerScreen({
    required this.controller,
    required this.initializeFuture,
    required this.onTap,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FutureBuilder(
        future: initializeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(controller),
                  if (!isPlaying)
                    Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 50.0,
                      ),
                    ),
                ],
              ),
            );
          } else {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              enabled: true,
              child: Container(
                width: width,
                height: 200,
                  color: Colors.black,
              ),
            );
          }
        },
      ),
    );
  }
}

class VideoPlayerManager extends StatefulWidget {
  final List<String> videoUrls;

  const VideoPlayerManager({required this.videoUrls});

  @override
  _VideoPlayerManagerState createState() => _VideoPlayerManagerState();
}

class _VideoPlayerManagerState extends State<VideoPlayerManager> {
  late List<VideoPlayerController> _controllers;
  late List<Future<void>> _initializeFutures;
  int _currentlyPlayingIndex = -1;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.videoUrls.length,
      (index) => VideoPlayerController.asset(widget.videoUrls[index]),
    );
    _initializeFutures =
        List.generate(widget.videoUrls.length, (index) => _controllers[index].initialize());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _playVideo(int index) {
    if (_currentlyPlayingIndex != index) {
      if (_currentlyPlayingIndex != -1) {
        _controllers[_currentlyPlayingIndex].pause();
      }
      setState(() {
        _currentlyPlayingIndex = index;
      });
      _controllers[index].play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getPadding(all: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly    ,
        children: List.generate(
          widget.videoUrls.length,
          (index) => Column(
            children: [
              VideoPlayerScreen(
                controller: _controllers[index],
                initializeFuture: _initializeFutures[index],
                onTap: () => _playVideo(index),
                isPlaying: _currentlyPlayingIndex == index,
              ),
              SizedBox(height: getVerticalSize(10),),
              Text(index==0?"360 Animation": "Working Animation",style:  AppStyle.txtMontserratSemiBold16Black,)
            ],
          ),
        ),
      ),
    );
  }
}