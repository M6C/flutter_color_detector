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
  ImageProvider provider;

  ImageViewer({Key? key, required this.provider,}) : super(key: key);

  @override
  _ImageViewer createState() => _ImageViewer();
}

// A widget that displays the picture taken by the user.
class _ImageViewer extends State<ImageViewer> {
  PhotoViewScaleStateController? _controller = PhotoViewScaleStateController();
  static const double _padding_default = 8.0;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ImagePixels(
        imageProvider: widget.provider,
        builder:  (BuildContext context, ImgDetails img) {
          return PhotoView(
            // backgroundDecoration: BoxDecoration(color:widget._currentColor),
            imageProvider: widget.provider,
            scaleStateController: _controller,
            onTapDown: (controller, detail, value) {
              print(detail);
              Offset at = detail.localPosition;
              Color color = getColorAt(img, at);
              print("pixelColorAt at:[${at.dx.toInt()},${at.dy.toInt()}] rgb:[${color.red},${color.green},${color.blue}]");
              setState(() {
                widget._currentColor = Color.fromRGBO(color.red, color.green, color.blue, 1.0);
              });
            },
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

  List<int> getPixel(int val, int? max) {
    int size = 20;
    int xS = val - size~/2;
    if (xS < 0) xS = 0;
    int xE = xS + 20;
    if (max != null && xE > max) xE = max;
    return [xS, xE];
  }

  Color getColorAt(ImgDetails img, Offset at) {
    List<int> xES = getPixel(at.dx.toInt(), img.width);
    List<int> yES = getPixel(at.dy.toInt(), img.height);

    int r = 0, g = 0, b = 0; double o = 1.0;
    List<Color> colors = [];
    for(int x=xES[0] ; x<xES[1] ; x++) {
      for(int y=yES[0] ; y<yES[1] ; y++) {
        Color c = img.pixelColorAt!(x, y);
        r += c.red; g += c.green; b += c.blue;
        colors.add(c);
        print("getColorAt [$x,$y] = ${colors.last}");
      }
    }
    int s = colors.length;
    if (s > 0)
      return Color.fromRGBO(r~/s, g~/s, b~/s, o);
    else
      return img.pixelColorAt!(at.dx.toInt(), at.dy.toInt());
  }
  //
  // Color getAverageRGBCircle(ImgDetails img, int x, int y, int radius) {
  //   int r = 0;
  //   int g = 0;
  //   int b = 0;
  //   int num = 0;
  //   int width = img.width ?? 0;
  //   int height = img.height ?? 0;
  //   /* Iterate through a bounding box in which the circle lies */
  //   for (int i = x - radius; i < x + radius; i++) {
  //     for (int j = y - radius; j < y + radius; j++) {
  //       /* If the pixel is outside the canvas, skip it */
  //       if (i < 0 || i >= width || j < 0 || j >= height)
  //         continue;
  //
  //       /* If the pixel is outside the circle, skip it */
  //       if (dist(x, y, i, j) > r)
  //         continue;
  //
  //       /* Get the color from the image, add to a running sum */
  //       Color c = img.get(i, j);
  //       r += red(c);
  //       g += green(c);
  //       b += blue(c);
  //       num++;
  //     }
  //   }
  //   /* Return the mean of the R, G, and B components */
  //   return color(r/num, g/num, b/num);
  // }

  Future<String> getColorName(Color color) {
    Completer<String> ret = Completer();
    String url = 'https://www.thecolorapi.com/id?rgb=${color.red},${color.green},${color.blue}';
    print("getColorName rgb:${color.red}.${color.green}.${color.blue}");

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