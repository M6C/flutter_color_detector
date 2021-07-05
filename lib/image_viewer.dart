import 'package:flutter/material.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:photo_view/photo_view.dart';


class ImageViewer extends StatefulWidget {
  Color _currentColor = Color.fromRGBO(0, 0, 0, 1.0);
  ImageProvider provider;

  ImageViewer({Key? key, required this.provider,}) : super(key: key);

  @override
  _ImageViewer createState() => _ImageViewer();
}

// A widget that displays the picture taken by the user.
class _ImageViewer extends State<ImageViewer> {
  PhotoViewScaleStateController? _controller = PhotoViewScaleStateController();

  @override
  Widget build(BuildContext context) {
    return ImagePixels(
      imageProvider: widget.provider,
      builder:  (BuildContext context, ImgDetails img) {
        return PhotoView(
          backgroundDecoration: BoxDecoration(color:widget._currentColor),
          imageProvider: widget.provider,
          scaleStateController: _controller,
          onTapDown: (controller, detail, value) {
            print(detail);
            Offset of = detail.localPosition;
            Color color = img.pixelColorAt!(of.dx.toInt(), of.dy.toInt());
            print("pixelColorAt x:${of.dx.toInt()} y:${of.dy.toInt()} rgb:${color.red}.${color.green}.${color.blue}");
            setState(() {
              widget._currentColor = Color.fromRGBO(color.red, color.green, color.blue, 1.0);
            });
          },
        );
      },
    );
  }
}