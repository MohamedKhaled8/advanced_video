import 'package:flutter/material.dart';
import 'package:advancedvideo/flutter_vimeo_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vimeo Player Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vimeo Player Example'),
      ),
      body: Center(
        child: VimeoPlayer(
          config: const VimeoVideoConfig(
            videoId: '824804225', // Demo video ID
            autoPlay: true,
            showControls: true,
            showDebugLog: true,
            headers: {
              'Authorization': 'bearer YOUR_ACCESS_TOKEN', // Add your Vimeo API token
            },
          ),
          width: MediaQuery.of(context).size.width,
          height: 300,
          fit: BoxFit.contain,
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}