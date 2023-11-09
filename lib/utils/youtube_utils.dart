String extractYoutubeVideoId(String url) {
  RegExp regExp = RegExp(
    r"^(?:https?://)?(?:www\.)?(?:youtu\.be/|youtube\.com/(?:embed/|v/|watch\?v=|watch\?.+&v=))((\w|-){11})(?:\S+)?$",
    caseSensitive: false,
    multiLine: false,
  );

  Match? match = regExp.firstMatch(url);

  if (match != null && match.groupCount >= 1) {
    return match.group(1)!; // the video id
  } else {
    // return null;
    // The provided string could not be parsed as a YouTube URL
    throw FormatException("Invalid YouTube URL");
  }
}
