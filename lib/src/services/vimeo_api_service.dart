import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vimeo_metadata.dart';
import '../models/vimeo_quality.dart';

class VimeoApiService {
  static const String _baseUrl = 'https://api.vimeo.com';
  
  Future<VimeoMetadata> getVideoMetadata(String videoId, Map<String, String>? headers) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/videos/$videoId'),
        headers: {
          'Accept': 'application/vnd.vimeo.*+json;version=3.4',
          ...?headers,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return VimeoMetadata.fromJson(data);
      } else {
        throw Exception('Failed to load video metadata: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<VimeoQuality>> getVideoQualities(String videoId, Map<String, String>? headers) async {
    final metadata = await getVideoMetadata(videoId, headers);
    return metadata.qualities;
  }
}