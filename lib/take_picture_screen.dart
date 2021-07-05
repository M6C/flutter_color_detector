import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color_detector/display_picture_screen.dart';
import 'package:flutter_color_detector/galery_screen.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  Completer<CameraDescription> cameraDesc = Completer<CameraDescription>();
  Completer<CameraController> cameraCtrl = Completer<CameraController>();
  Completer<bool> cameraCtrlInit = Completer<bool>();

  CameraDescription? camera;
  final List<String> galleryItems;

  TakePictureScreen({Key? key, required this.galleryItems,}) : super(key: key) {

    // Obtain a list of the available cameras on the device.
    // Get a specific camera from the list of available cameras.
    availableCameras().then((value) => cameraDesc.complete(value.first));
  }

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    widget.cameraDesc.future.then((camera) {
        _controller = CameraController(
          // Get a specific camera from the list of available cameras.
          camera,
          // Define the resolution to use.
          ResolutionPreset.medium,
        );
        widget.cameraCtrl.complete(_controller);
      });

    widget.cameraCtrl.future.then((value) {
      _controller.initialize().then((value) => widget.cameraCtrlInit.complete(true));
      // Next, initialize the controller. This returns a Future.
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: widget.cameraCtrlInit.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            // await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();
            final path = image.path;

            setState(() {
              if (!widget.galleryItems.contains(path)) widget.galleryItems.add(path);
            });

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return DisplayPictureScreen(
                    // Pass the automatically generated path to
                    // the DisplayPictureScreen widget.
                    path,
                  );
                },
              ),
            );
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => GalleryScreen(galleryItems: widget.galleryItems,)));
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
