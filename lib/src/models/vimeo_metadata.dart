import 'package:advancedvideo/src/models/vimeo_quality.dart';


class VimeoMetadata {
  final String title;
  final String description;
  final String thumbnailUrl;
  final int duration;
  final List<VimeoQuality> qualities;

  const VimeoMetadata({
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.duration,
    required this.qualities,
  });

  factory VimeoMetadata.fromJson(Map<String, dynamic> json) {
    return VimeoMetadata(
      title: json['name'] ?? '',
      description: json['description'] ?? '',
      thumbnailUrl: json['pictures']?['sizes']?.last['link'] ?? '',
      duration: json['duration'] ?? 0,
      qualities: (json['files'] as List?)
          ?.map((q) => VimeoQuality.fromJson(q))
          .toList() ?? [],
    );
  }
}