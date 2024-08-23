import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;

  const VideoPlayerScreen({super.key, required this.videoId});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
    _controller.toggleFullScreenMode();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        body: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            onReady: () {
              print('Player is ready.');
            },
            onEnded: (YoutubeMetaData metaData) {
              Navigator.pop(context);
            },
          ),
          builder: (context, player) {
            return Column(
              children: [
                player,
                // Add more widgets below if needed
              ],
            );
          },
        ),
      ),
    );
  }
}
