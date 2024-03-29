import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_color_detector/ColorUtils.dart';
import 'package:flutter_color_detector/painter/preview_painter.dart';
import 'package:flutter_color_detector/painter/shape_painter.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatefulWidget {
  Color _currentColor = Color.fromRGBO(0, 0, 0, 1.0);
  Rect _currentRect = Rect.fromLTRB(0.0, 0.0, 0.0, 0.0);
  Map<Offset, Color> _currentPositionColors = {};
  ImageProvider provider;

  ImageViewer({Key? key, required this.provider,}) : super(key: key);

  @override
  _ImageViewer createState() => _ImageViewer();
}

// A widget that displays the picture taken by the user.
class _ImageViewer extends State<ImageViewer> {
  PhotoViewScaleStateController? _scaleStateController;
  PhotoViewController? _controller;
  GlobalKey _photoKey = GlobalKey();
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
    if (scaleState.isScaleStateZooming) _scaleStateController?.scaleState = PhotoViewScaleState.initial;
  }

  @override
  Widget build(BuildContext context) {
    return
      Stack(children: [
      ImagePixels(
        imageProvider: widget.provider,
        builder:  (BuildContext context, ImgDetails img) {
          return CustomPaint(
            child:
              // Image(image: widget.provider,)
              PhotoView(
                basePosition: Alignment.topLeft,
                key: _photoKey,
                backgroundDecoration: BoxDecoration(color:ColorUtils.inverseColor(widget._currentColor)),
                imageProvider: widget.provider,
                controller: _controller,
                scaleStateController: _scaleStateController,
                onTapDown: (controller, detail, value) {
                  // Offset at = Offset.zero;
                  // Offset at = Offset(img.width!/2-10, img.height!/2-10);//Offset.zero;
                  Offset at = detail.localPosition;
                  setState(() {
                    print("onTapDown img:${img.width},${img.height} ctrl.scale:${_controller?.scale} value.scale:${value.scale} value.position:${value.position}");
                    print("onTapDown at1:${at.dx},${at.dy}");

                    var scale = 1.0;//_controller!.scale ?? 1.0;
                    widget._currentRect = getColorRect(img, at, scale:scale);

                    // at = Offset(at.dx / (1-(_controller?.scale ?? 1.0)), at.dy / (1-(_controller?.scale ?? 1.0)));
                    // at = Offset(at.dx * (_controller?.scale ?? 1.0), at.dy * (_controller?.scale ?? 1.0));
                    // at = Offset(at.dx + (at.dx * (1-(_controller?.scale ?? 1.0))), at.dy/* + (at.dy * (1-(_controller?.scale ?? 1.0)))*/);
                    at = Offset(at.dx + (at.dx * (1.0-(_controller?.scale ?? 1.0))), at.dy + (at.dy * (1.0-(_controller?.scale ?? 1.0)))); // +- OK
                    // Add Fix Adjustment
                    int sensX = 1; double shiftX = 7;
                    int sensY = 1; double shiftY = 9;
                    at = Offset(at.dx+(sensX*(shiftX)), at.dy+(sensY*shiftY));

                    // RenderBox? box = _photoKey.currentContext?.findRenderObject() as RenderBox?;
                    // Offset? position = box?.localToGlobal(Offset.zero); //this is global position
                    // Offset pos = Offset(position?.dx ?? 0.0, position?.dy ?? 0.0);
                    // print("PhotoView Position $pos");

                    print("onTapDown at2:${at.dx},${at.dy}");

                    widget._currentColor = getColorAt(img, at, scale:scale);
                    widget._currentPositionColors = getPositionsColorsAt(img, at, scale:scale);
                  });
                },
              ),
              foregroundPainter: ShapePainter(widget._currentRect, color: Colors.red),//ColorUtils.inverseColor(widget._currentColor)),
          );
        },
      )
      ,
      CustomPaint(
        painter: PreviewPainter(widget._currentPositionColors),
        child: Container(width: 100, height: 100,),
      )
      ,
      Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: _padding_default),
              child: FutureBuilder<List<String>>(
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
    ],)
    ;
  }

  List<int> getPixel(int val, int? max, {double scale = 1.0}) {
    // int depth = 10000000;
    // print("getPixel ${(1/scale)} ${((1/scale) * depth)} ${(20 * ((1/scale) * depth))} ${(20 * ((1/scale) * depth)) ~/ depth}");
    int radius = 20;//(20 * ((1/scale) * depth)) ~/ depth;
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
    Map<Offset, Color> colors = getPositionsColorsAt(img, at, scale: scale);
    colors.forEach((o, c) { r += c.red; g += c.green; b += c.blue; });
    int s = colors.length;
    if (s > 0)
      ret = Color.fromRGBO(r~/s, g~/s, b~/s, o);
    else
      ret = img.pixelColorAt!(at.dx.toInt(), at.dy.toInt());
    print("getColorAt rgb:[${ret.red},${ret.green},${ret.blue}] at:[${at.dx.toInt()},${at.dy.toInt()}] rect:[${rect.left},${rect.top}/${rect.right},${rect.bottom}]");
    return ret;
  }

  Map<Offset, Color> getPositionsColorsAt(ImgDetails img, Offset at, {double scale = 1.0}) {
    Rect rect = getColorRect(img, at, scale:scale);

    // double s = 1.0-scale;
    // double h = 1.0;//(img.width ?? 1.0)/(img.height ?? 1.0);
    // rect = Rect.fromLTRB(rect.left+(rect.left*s*h), rect.top-(rect.top*s*h), rect.right+(rect.right*s*h), rect.bottom-(rect.bottom*s*h));

    Map<Offset, Color> colors = {};
    for(int x=rect.left.toInt() ; x<rect.right.toInt() ; x++) {
      for(int y=rect.top.toInt() ; y<rect.bottom.toInt() ; y++) {
        colors.putIfAbsent(Offset(x.toDouble(),y.toDouble()), () => img.pixelColorAt!(x, y));
        // print("getPositionsColorsAt ${colors.keys.last} = ${colors.values.last}");
      }
    }
    return colors;
  }

  Rect getColorRect(ImgDetails img, Offset at, {double scale = 1.0}) {
    List<int> xSE = getPixel(at.dx.toInt(), img.width, scale: scale);
    List<int> ySE = getPixel(at.dy.toInt(), img.height, scale: scale);

    return Rect.fromLTRB(xSE[0].toDouble(), ySE[0].toDouble(), xSE[1].toDouble(), ySE[1].toDouble());

    // Rect rect = Rect.fromCenter(center: at, width: 20, height: 20);
    //
    // double s = 1.0-scale;
    // rect = Rect.fromLTRB(rect.left-(rect.left*s), rect.top-(rect.top*s), rect.right-(rect.right*s), rect.bottom-(rect.bottom*s));
    //
    // return rect;
    // return Rect.fromCenter(center: at, width: 20, height: 20);
  }

  Future<String> getColorName(Color color) => Future.value(ColorUtils.getColorNameFromRgb(color.red, color.green, color.blue));
  // Future<String> getColorName(Color color) {
  //   Completer<String> ret = Completer();
  //   String url = 'https://www.thecolorapi.com/id?rgb=${color.red},${color.green},${color.blue}';
  //   print("getColorName url:$url");
  //
  //   http.get(Uri.parse(url)).then((response) {
  //     String? c;
  //     if (response.statusCode == 200) {
  //       c = ColorApi.fromJson(jsonDecode(response.body)).name?.value;
  //     }
  //     if (c == null)
  //       c = ColorUtils.getColorNameFromRgb(color.red, color.green, color.blue);
  //     ret.complete(c);
  //   });
  //   return ret.future;
  // }
}