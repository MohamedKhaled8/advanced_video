# Flutter Vimeo Player

A comprehensive Flutter package for playing Vimeo videos with advanced controls and features.

## Features

- 🎥 Full Vimeo API integration
- ⚡ Multiple playback speeds
- 🎮 Quality control
- 🛠️ Customizable player controls
- 📊 Debug logging
- 🎨 Customizable UI

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_vimeo_player: ^0.0.1
```

## Usage

```dart
import 'package:flutter_vimeo_player/flutter_vimeo_player.dart';

VimeoPlayer(
  config: VimeoVideoConfig(
    videoId: 'YOUR_VIDEO_ID',
    autoPlay: true,
    showControls: true,
    showDebugLog: true,
  ),
)
```

## Configuration

The `VimeoVideoConfig` class accepts the following parameters:

- `videoId`: The ID of the Vimeo video (required)
- `autoPlay`: Whether to start playing automatically (default: false)
- `showControls`: Whether to show player controls (default: true)
- `showDebugLog`: Whether to show debug logs (default: false)
- `headers`: Additional headers for API requests

## License

MIT License