import '../models/vimeo_quality.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../controllers/vimeo_player_controller.dart';

class PlayerControls extends StatelessWidget {
  final VimeoPlayerController controller;

  const PlayerControls({
    super.key,
    required this.controller,
  });

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.isControlsVisible) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: controller.toggleControls,
      child: Container(
        color: Colors.black26,
        child: Stack(
          children: [
            // Center play/pause button
            Align(
              alignment: Alignment.center,
              child: IconButton(
                iconSize: 50,
                icon: Icon(
                  controller.videoController?.value.isPlaying ?? false
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (controller.videoController?.value.isPlaying ?? false) {
                    controller.videoController?.pause();
                  } else {
                    controller.videoController?.play();
                  }
                },
              ),
            ),

            // Bottom control bar
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Progress bar
                    VideoProgressIndicator(
                      controller.videoController!,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: Colors.red,
                        bufferedColor: Colors.white24,
                        backgroundColor: Colors.white12,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Controls row
                    Row(
                      children: [
                        // Time
                        Text(
                          '${_formatDuration(controller.position)} / '
                          '${_formatDuration(controller.videoController?.value.duration ?? Duration.zero)}',
                          style: const TextStyle(color: Colors.white),
                        ),

                        const Spacer(),

                        // Playback speed
                        PopupMenuButton<double>(
                          icon: const Icon(Icons.speed, color: Colors.white),
                          onSelected: controller.setPlaybackSpeed,
                          itemBuilder: (context) => [
                            0.25,
                            0.5,
                            0.75,
                            1.0,
                            1.25,
                            1.5,
                            1.75,
                            2.0,
                          ].map((speed) => PopupMenuItem(
                            value: speed,
                            child: Text(
                              '${speed}x',
                              style: TextStyle(
                                fontWeight: controller.playbackSpeed == speed
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          )).toList(),
                        ),

                        // Quality selector
                        PopupMenuButton<VimeoQuality>(
                          icon: const Icon(Icons.settings, color: Colors.white),
                          onSelected: controller.setQuality,
                          itemBuilder: (context) => 
                            controller.metadata?.qualities.map((quality) => PopupMenuItem(
                              value: quality,
                              child: Text(
                                quality.label,
                                style: TextStyle(
                                  fontWeight: controller.selectedQuality?.url == quality.url
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            )).toList() ?? [],
                        ),

                        // Fullscreen toggle
                        IconButton(
                          icon: const Icon(Icons.fullscreen, color: Colors.white),
                          onPressed: () {
                            // TODO: Implement fullscreen toggle
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Loading indicator
            if (controller.isBuffering)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}