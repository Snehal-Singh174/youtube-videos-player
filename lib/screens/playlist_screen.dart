import 'package:flutter/material.dart';
import 'package:youtube_playlist/screens/playlist_video_screen.dart';
import 'package:youtube_playlist/utilities/keys.dart';

import '../models/playlist.dart';
import '../services/youtube_services.dart';
import '../widgets/playlist_card.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  PlaylistScreenState createState() => PlaylistScreenState();
}

class PlaylistScreenState extends State<PlaylistScreen> {
  List<Playlist> playlists = [];
  bool isLoading = true;
  YouTubeService youTubeService =
      YouTubeService(apiKey: API_KEY, channelId: CHANNEL_ID);

  @override
  void initState() {
    super.initState();
    fetchPlaylists();
  }

  Future<void> fetchPlaylists() async {
    try {
      List<Playlist> fetchedPlaylists = await youTubeService.fetchPlaylists();
      setState(() {
        playlists = fetchedPlaylists;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching playlists: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Playlists'),
        backgroundColor: Colors.redAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of items per row
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio:
                      3 / 2, // Adjust to make the cards look better
                ),
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  return PlaylistCard(
                    playlist: playlists[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaylistVideoScreen(
                            playlistId: playlists[index].id,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
