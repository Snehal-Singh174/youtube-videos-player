import 'package:flutter/material.dart';
import 'package:youtube_playlist/screens/video_player_screen.dart';

import '../models/video.dart';
import '../services/youtube_services.dart';
import '../utilities/keys.dart';

class PlaylistVideoScreen extends StatefulWidget {
  final String playlistId;

  const PlaylistVideoScreen({super.key, required this.playlistId});

  @override
  PlaylistVideoScreenState createState() => PlaylistVideoScreenState();
}

class PlaylistVideoScreenState extends State<PlaylistVideoScreen> {
  List<Video> videos = [];
  bool isLoading = true;
  YouTubeService youTubeService =
      YouTubeService(apiKey: API_KEY, channelId: CHANNEL_ID);

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    try {
      List<Video> fetchedVideos =
          await youTubeService.fetchVideos(widget.playlistId);
      setState(() {
        videos = fetchedVideos;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching videos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlist Videos'),
        backgroundColor: Colors.redAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(videos[index].thumbnailUrl),
                  title: Text(
                    videos[index].title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    // Navigate to Video Player Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen(
                          videoId: videos[index].id,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
