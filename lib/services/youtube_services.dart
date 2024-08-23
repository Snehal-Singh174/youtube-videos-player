import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:youtube_playlist/models/video.dart';

import '../models/playlist.dart';

class YouTubeService {
  final String apiKey;
  final String channelId;

  YouTubeService({required this.apiKey, required this.channelId});

  Future<List<Playlist>> fetchPlaylists() async {
    final String url =
        'https://www.googleapis.com/youtube/v3/playlists?part=snippet&channelId=$channelId&key=$apiKey&maxResults=50';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> playlists = data['items'];
      List<Playlist> playlistList = playlists.map((item) {
        final snippet = item['snippet'];
        return Playlist(
          id: item['id'],
          title: snippet['title'],
          thumbnailUrl: snippet['thumbnails']['default']
              ['url'], // Use 'medium' or 'high' for better resolution
        );
      }).toList();

      // Check for more pages of results
      String? nextPageToken = data['nextPageToken'];
      while (nextPageToken != null) {
        final nextUrl =
            'https://www.googleapis.com/youtube/v3/playlists?part=snippet&channelId=$channelId&key=$apiKey&maxResults=50&pageToken=$nextPageToken';
        final nextResponse = await http.get(Uri.parse(nextUrl));

        if (nextResponse.statusCode == 200) {
          final nextData = json.decode(nextResponse.body);
          final nextPlaylists = nextData['items'];
          playlistList.addAll(nextPlaylists.map((item) {
            final snippet = item['snippet'];
            return Playlist(
              id: item['id'],
              title: snippet['title'],
              thumbnailUrl: snippet['thumbnails']['default']['url'],
            );
          }).toList());
          nextPageToken = nextData['nextPageToken'];
        } else {
          nextPageToken = null;
        }
      }

      return playlistList;
    } else {
      throw Exception('Failed to load playlists');
    }
  }

  Future<List<Video>> fetchVideos(String playlistId) async {
    final String url =
        'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=${playlistId}&key=$apiKey&maxResults=50';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> videosJson = data['items'];
      List<Video> fetchedVideos =
          videosJson.map((json) => Video.fromJson(json)).toList();
      return fetchedVideos;
    } else {
      throw Exception('Failed to load playlists');
    }
  }
}
