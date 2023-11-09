class BilibiliMetaData {
  /// Youtube video ID of the currently loaded video.
  final String videoId;

  /// Total duration of the currently loaded video.
  final Duration duration;

  /// Creates [YoutubeMetaData] for Youtube Video.
  const BilibiliMetaData({
    this.videoId = '',
    this.duration = const Duration(),
  });

  /// Creates [BilibiliMetadata] from raw json video data.
  factory BilibiliMetaData.fromRawData(dynamic rawData) {
    final data = rawData as Map<String, dynamic>;
    final durationInMs = ((data['duration'] ?? 0).toDouble() * 1000).floor();
    return BilibiliMetaData(
      videoId: data['videoId'],
      duration: Duration(milliseconds: durationInMs),
    );
  }

  @override
  String toString() {
    return '$runtimeType('
        'videoId: $videoId, '
        'duration: ${duration.inSeconds} sec.)';
  }
}
