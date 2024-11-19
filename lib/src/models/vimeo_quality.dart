class VimeoQuality {
  final String label;
  final String url;
  final int width;
  final int height;

  const VimeoQuality({
    required this.label,
    required this.url,
    required this.width,
    required this.height,
  });

  factory VimeoQuality.fromJson(Map<String, dynamic> json) {
    return VimeoQuality(
      label: json['quality'] ?? 'auto',
      url: json['url'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
    );
  }
}