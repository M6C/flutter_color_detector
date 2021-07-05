import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_color_detector/image_viewer.dart';
import 'package:photo_view/photo_view.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  DisplayPictureScreen(this.imagePath, {Key? key}) : super(key: key);

  @override
  _DisplayPictureState createState() => _DisplayPictureState();
}

// A widget that displays the picture taken by the user.
class _DisplayPictureState extends State<DisplayPictureScreen> {
  PhotoViewScaleStateController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = PhotoViewScaleStateController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void goBack(){
    _controller?.scaleState = PhotoViewScaleState.originalSize;
  }

  @override
  Widget build(BuildContext context) {
    var fileImage = FileImage(File(widget.imagePath));
    return Scaffold(
      appBar: AppBar(title: Text('Display Picture'/*, style: TextStyle(color: _currentColor)*/)),
      body: ImageViewer(provider: fileImage,)
    );
  }
}
