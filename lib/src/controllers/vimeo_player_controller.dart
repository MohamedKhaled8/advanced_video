import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import '../services/vimeo_api_service.dart';
import '../models/vimeo_video_config.dart';
import '../models/vimeo_metadata.dart';
import '../models/vimeo_quality.dart';

class VimeoPlayerController extends ChangeNotifier {
  final VimeoVideoConfig config;
  final VimeoApiService _apiService;
  VideoPlayerController? _videoController;
  VimeoMetadata? _metadata;
  bool _isLoading = true;
  String? _error;
  double _playbackSpeed = 1.0;
  VimeoQuality? _selectedQuality;
  bool _isBuffering = false;
  bool _isControlsVisible = true;
  Duration _position = Duration.zero;

  VimeoPlayerController(this.config) : _apiService = VimeoApiService();

  VideoPlayerController? get videoController => _videoController;
  VimeoMetadata? get metadata => _metadata;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get playbackSpeed => _playbackSpeed;
  VimeoQuality? get selectedQuality => _selectedQuality;
  bool get isBuffering => _isBuffering;
  bool get isControlsVisible => _isControlsVisible;
  Duration get position => _position;

  Future<void> initialize() async {
    try {
      _isLoading = true;
      notifyListeners();

      _metadata = await _apiService.getVideoMetadata(
        config.videoId,
        config.headers,
      );

      if (_metadata?.qualities.isEmpty ?? true) {
        throw Exception('No video qualities available');
      }

      _selectedQuality = _metadata?.qualities.first;
      await _initializeVideoController();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      if (config.showDebugLog) {
        print('VimeoPlayer Error: $e');
      }
      notifyListeners();
    }
  }

  Future<void> _initializeVideoController() async {
    final oldController = _videoController;
    final position = oldController?.value.position;

    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(_selectedQuality?.url ?? ''),
    );

    await _videoController?.initialize();
    oldController?.dispose();

    if (position != null) {
      await _videoController?.seekTo(position);
    }

    _videoController?.addListener(_videoListener);

    if (config.autoPlay) {
      await _videoController?.play();
    }
  }

  void _videoListener() {
    final controller = _videoController;
    if (controller != null) {
      _isBuffering = controller.value.isBuffering;
      _position = controller.value.position;
      notifyListeners();
    }
  }

  Future<void> setPlaybackSpeed(double speed) async {
    if (_videoController != null) {
      await _videoController!.setPlaybackSpeed(speed);
      _playbackSpeed = speed;
      notifyListeners();
    }
  }

  Future<void> setQuality(VimeoQuality quality) async {
    if (_selectedQuality?.url != quality.url) {
      _selectedQuality = quality;
      await _initializeVideoController();
      notifyListeners();
    }
  }

  void toggleControls() {
    _isControlsVisible = !_isControlsVisible;
    notifyListeners();
  }

  Future<void> seekTo(Duration position) async {
    await _videoController?.seekTo(position);
  }

  @override
  void dispose() {
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    super.dispose();
  }
}