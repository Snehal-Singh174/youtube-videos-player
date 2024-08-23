class Video {
  final String id;
  final String title;
  final String thumbnailUrl;

  Video({required this.id, required this.title, required this.thumbnailUrl});

  factory Video.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'];
    return Video(
      id: snippet['resourceId']['videoId'],
      title: snippet['title'],
      thumbnailUrl: snippet['thumbnails']['medium']['url'],
    );
  }
}
