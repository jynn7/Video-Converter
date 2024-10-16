import 'dart:async';

import 'package:flutter/material.dart';
import 'package:videoconverter/feature/videoconverter/video_converter_main.dart';
import 'package:window_manager/window_manager.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  // Set window properties
  windowManager.setMinimumSize(Size(700, 800)); // Minimum size
  windowManager.setResizable(false);
  windowManager.setMinimizable(true);
  windowManager.setMaximizable(true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const VideoConverterMain(title: 'Video Converter'),
    );
  }
}


