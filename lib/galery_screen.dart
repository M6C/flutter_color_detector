import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_color_detector/image_viewer.dart';
import 'package:flutter_color_detector/take_picture_screen.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryScreen extends StatefulWidget {
  final List<String> galleryItems;

  GalleryScreen({Key? key, required this.galleryItems,}) : super(key: key);

  @override
  _GalleryScreen createState() => _GalleryScreen();
}

// A widget that displays the picture taken by the user.
class _GalleryScreen extends State<GalleryScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery Picture')),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions.customChild(
            child: ImageViewer(provider: FileImage(File(widget.galleryItems[index]))),
            initialScale: PhotoViewComputedScale.contained * 0.8,
            // heroAttributes: PhotoViewHeroAttributes(tag: galleryItems[index].id),
          );
        },
        itemCount: widget.galleryItems.length,
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              // value: event == null
              //     ? 0
              //     : event.cumulativeBytesLoaded / event.expectedTotalBytes,
            ),
          ),
        ),
        // backgroundDecoration: backgroundDecoration,
        // pageController: pageController,
        // onPageChanged: onPageChanged,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          try {
            // If the picture was taken, display it on a new screen.
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TakePictureScreen(
                  // Pass the appropriate camera to the TakePictureScreen widget.
                    galleryItems: widget.galleryItems
                ),
              ),
            );
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