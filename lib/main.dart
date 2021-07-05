import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_color_detector/take_picture_screen.dart';

Future<void> main() async {
  final List<String> _galleryItems = [];

  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(galleryItems: _galleryItems),
    ),
  );
}
