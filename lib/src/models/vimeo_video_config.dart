class VimeoVideoConfig {
  final String videoId;
  final bool autoPlay;
  final bool showControls;
  final bool showDebugLog;
  final Map<String, String>? headers;

  const VimeoVideoConfig({
    required this.videoId,
    this.autoPlay = false,
    this.showControls = true,
    this.showDebugLog = false,
    this.headers,
  });
}