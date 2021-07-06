import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_color_detector/ColorApiModel.dart';
import 'package:flutter_color_detector/ColorUtils.dart';
import 'package:http/http.dart' as http;
import 'package:image_pixels/image_pixels.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatefulWidget {
  Color _currentColor = Color.fromRGBO(0, 0, 0, 1.0);
  Rect _currentRect = Rect.fromLTRB(0.0, 0.0, 0.0, 0.0);
  ImageProvider provider;

  ImageViewer({Key? key, required this.provider,}) : super(key: key);

  @override
  _ImageViewer createState() => _ImageViewer();
}

// A widget that displays the picture taken by the user.
class _ImageViewer extends State<ImageViewer> {
  PhotoViewScaleStateController? _scaleStateController;
  PhotoViewController? _controller;
  static const double _padding_default = 8.0;

  @override
  void initState() {
    super.initState();
    _controller = PhotoViewController()..outputStateStream.listen(listener);
    _scaleStateController = PhotoViewScaleStateController()..outputScaleStateStream.listen(onScaleState);
  }

  void listener(PhotoViewControllerValue scaleState) {
    print("listener scale:${scaleState.scale}");
  }

  void onScaleState(PhotoViewScaleState scaleState) {
    print("onScaleState isScaleStateZooming:${scaleState.isScaleStateZooming} index:${scaleState.index}");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ImagePixels(
        imageProvider: widget.provider,
        builder:  (BuildContext context, ImgDetails img) {
          return CustomPaint(
            child:
              PhotoView(
              // backgroundDecoration: BoxDecoration(color:widget._currentColor),
              imageProvider: widget.provider,
              controller: _controller,
              scaleStateController: _scaleStateController,
              onTapDown: (controller, detail, value) {
                Offset at = detail.localPosition;
                setState(() {
                  var scale = _controller!.scale ?? 1.0;
                  widget._currentColor = getColorAt(img, at/*, scale:scale*/);
                  widget._currentRect = getColorRect(img, at/*, scale:scale*/);
                });
              },
            ),
            foregroundPainter: ShapePainter(widget._currentRect, color: ColorUtils.inverseColor(widget._currentColor)),
          );
        },
      )
      ,
      Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.symmetric(vertical: _padding_default),
                child:
                  FutureBuilder<List<String>>(
                    future: Future.wait([
                      getColorName(widget._currentColor),
                    ]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Text(snapshot.data![0], style: TextStyle(color:widget._currentColor, fontSize: 24.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center,);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }
                  )
            ),
          ],
        ),
      )
    ],);
  }

  List<int> getPixel(int val, int? max, {double scale = 1.0}) {
    int depth = 10000000;
    // print("getPixel ${(1/scale)} ${(1/scale) * depth} ${((1/scale) * depth).toInt()} ${(20 * ((1/scale) * depth).toInt())}");
    int radius = (20 * ((1/scale) * depth).toInt()) ~/ depth;
    // print("getPixel val:$val max:$max scale:$scale radius:$radius");
    int size = radius;
    int xS = val - size~/2;
    if (xS < 0) xS = 0;
    int xE = xS + radius;
    if (max != null && xE > max) xE = max;
    return [xS, xE];
  }

  Color getColorAt(ImgDetails img, Offset at, {double scale = 1.0}) {
    Color? ret;
    Rect rect = getColorRect(img, at, scale:scale);

    int r = 0, g = 0, b = 0; double o = 1.0;
    List<Color> colors = [];
    for(int x=rect.left.toInt() ; x<rect.right.toInt() ; x++) {
      for(int y=rect.top.toInt() ; y<rect.bottom.toInt() ; y++) {
        Color c = img.pixelColorAt!(x, y);
        r += c.red; g += c.green; b += c.blue;
        colors.add(c);
        // print("getColorAt [$x,$y] = ${colors.last}");
      }
    }
    int s = colors.length;
    if (s > 0)
      ret = Color.fromRGBO(r~/s, g~/s, b~/s, o);
    else
      ret = img.pixelColorAt!(at.dx.toInt(), at.dy.toInt());
    // print("getColorAt at:[${at.dx.toInt()},${at.dy.toInt()}] rgb:[${ret.red},${ret.green},${ret.blue}]");
    return ret;
  }

  Rect getColorRect(ImgDetails img, Offset at, {double scale = 1.0}) {
    List<int> xSE = getPixel(at.dx.toInt(), img.width, scale: scale);
    List<int> ySE = getPixel(at.dy.toInt(), img.height, scale: scale);

    return Rect.fromLTRB(xSE[0].toDouble(), ySE[0].toDouble(), xSE[1].toDouble(), ySE[1].toDouble());
  }

  Future<String> getColorName(Color color) {
    Completer<String> ret = Completer();
    String url = 'https://www.thecolorapi.com/id?rgb=${color.red},${color.green},${color.blue}';
    print("getColorName url:$url");

    http.get(Uri.parse(url)).then((response) {
      String? c;
      if (response.statusCode == 200) {
        c = ColorApi.fromJson(jsonDecode(response.body)).name?.value;
      }
      if (c == null)
        c = ColorUtils.getColorNameFromRgb(color.red, color.green, color.blue);
      ret.complete(c);
    });
    return ret.future;
  }
}

class ShapePainter extends CustomPainter {
  Rect rect;
  Color color;
  double scale;

  ShapePainter(this.rect, {this.color = Colors.teal, this.scale = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.addRect(rect);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}