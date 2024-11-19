import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'controllers/vimeo_player_controller.dart';
import 'models/vimeo_video_config.dart';
import 'widgets/player_controls.dart';

class VimeoPlayer extends StatefulWidget {
  final VimeoVideoConfig config;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color backgroundColor;

  const VimeoPlayer({
    super.key,
    required this.config,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.backgroundColor = Colors.black,
  });

  @override
  State<VimeoPlayer> createState() => _VimeoPlayerState();
}

class _VimeoPlayerState extends State<VimeoPlayer> {
  late final VimeoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VimeoPlayerController(widget.config);
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.backgroundColor,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            if (_controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_controller.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      _controller.error!,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return GestureDetector(
              onTap: _controller.toggleControls,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  FittedBox(
                    fit: widget.fit,
                    child: SizedBox(
                      width: _controller.videoController?.value.size.width ?? 0,
                      height: _controller.videoController?.value.size.height ?? 0,
                      child: VideoPlayer(_controller.videoController!),
                    ),
                  ),
                  if (widget.config.showControls)
                    PlayerControls(controller: _controller),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}