class Playlist {
  final String id;
  final String title;
  final String thumbnailUrl;

  Playlist({required this.id, required this.title, required this.thumbnailUrl});

  factory Playlist.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'];
    return Playlist(
      id: json['id'],
      title: snippet['title'],
      thumbnailUrl: snippet['thumbnails']['medium']['url'],
    );
  }
}
