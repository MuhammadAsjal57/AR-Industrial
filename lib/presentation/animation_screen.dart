import 'package:ar_industrial/presentation/video_player_screen.dart';
import 'package:ar_industrial/theme/app_style.dart';
import 'package:flutter/material.dart';

class AnimationScreen extends StatelessWidget {
  const AnimationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Animations",style: AppStyle.txtMontserratSemiBold16,),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: Center(
          child: VideoPlayerManager(
            videoUrls: [
              'assets/videos/v2.mp4',
              'assets/videos/v1.mp4',
              
            ],
          ),
        ),
    );
  }
}