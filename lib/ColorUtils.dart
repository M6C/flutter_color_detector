import 'package:flutter/material.dart';

class ColorUtils
{
  static int INT_MAX_VALUE = 2147483647;

  // http://www.1728.org/RGB3.htm
  // https://htmlcolorcodes.com/fr/
  static var mapBW = {
    // "Black":["000000","222222","444444",],
    // "Grey":["666666","888888","AAAAAA",],
    // "White":["CCCCCC","EEEEEE","FFFFFF"],
    "Black": ["000000", "202020", "404040",],
    "Grey": ["606060", "808080", "A0A0A0",],
    "White": ["C0C0C0", "E0E0E0", "FFFFFF"],
  };

  // https://www.rapidtables.com/web/color/maroon-color.html
  static var mapColor = {
    "Red":["FF0040","FF0020","FF0000","FF2000","FF4000",],
    "Orange":["FF6000","FF8000","FFAA00","FFBF00",],
    // "Brown": ["800000","964B00", "8B0000", "A52A2A", "B22222",
              // "DC143C", "8B4513", "D2691E", "CD853F", "DAA520", "F4A460", "BC8F8F", "D2B48C", "DEB887", "F5DEB3", "FFDEAD", "FFE4C4", "FFEBCD", "FFF8DC",
    // ],
    "Yellow":["FFEE00","FFFF00","DDFF00",],
    "Green":["CCFF00","AAFF00","808000","80FF00","60FF00","40FF00","20FF00","00FF00","00FF20","00FF40","00FF40","00FF60","00FF80","00FFAA",],
    "Blue":["00FFCC","00FFDD","00FFFF","00DDFF","00CCFF","0099FF","0080FF","0060FF","0040FF","0020FF","0000FF","2000FF","4000FF","6000FF",
              // "191970", "000080", "00008B", "0000CD", "4169E1", "483D8B", "6A5ACD", "7B68EE", "5F9EA0", "4682B4", "6495ED", "1E90FF", "B0C4DE", "00BFFF", "87CEEB", "87CEFA", "ADD8E6", "B0E0E6", "E6E6FA", "F0F8FF",
    ],
    "Violet":["8000FF","AA00FF","CC00FF","DD00FF"],
    "Fuchsia":["FF00FF","FF00EE","FF00CC"],
    "Pink":["FF00AA","FF0080","FF0060"],
  };

  static List<ColorName> colorFromMap() {
    List<ColorName> ret = [];
    mapColor.forEach((key, value) {
      for(String hex in value) {
        ret.add(ColorName.fromHex(key, hex));
      }
    });
    return ret;
  }

  static List<ColorName> bwFromMap() {
    List<ColorName> ret = [];
    mapBW.forEach((key, value) {
      for(String hex in value) {
        ret.add(ColorName.fromHex(key, hex));
      }
    });
    return ret;
  }

  static Color inverseColor(Color c, {bool? bw}) =>
      (bw ?? isBW(c)) ?
        (c.red * 0.299 + c.green * 0.587 + c.blue * 0.114) > 186 ? Colors.black : Colors.white
        :
          Color.fromRGBO(255-c.red, 255-c.green, 255-c.blue, c.opacity);

  static bool isBW(Color c, {int diff = 10}) => ((c.red-c.green).abs() <= diff) && ((c.green-c.blue).abs() <= diff) && ((c.red-c.blue).abs() <= diff);

  static String getColorNameFromRgb(int r, int g, int b) {
    bool isBWG = isBW(Color.fromRGBO(r, g, b, 1.0));
    print("isBWG:$isBWG");
    List<ColorName> colorList;
    if (isBWG) colorList = bwFromMap(); else  colorList = colorFromMap();//colorList12;//initColorList();
    ColorName? closestMatch;
    int minMSE = INT_MAX_VALUE;
    int mse;
    for (ColorName c in colorList) {
      mse = c.computeMSE(r, g, b);
      if (mse < minMSE) {
        minMSE = mse;
        closestMatch = c;
      }
    }
    if (closestMatch != null) {
      return closestMatch.getName();
    } else {
      return "No matched color name.";
    }
  }

  static String getColorNameFromHex(int hexColor)
  {
    int r = ((hexColor & 16711680) >> 16);
    int g = ((hexColor & 65280) >> 8);
    int b = (hexColor & 15);
    return getColorNameFromRgb(r, g, b);
  }

  // int colorToHex(Color c)
  // {
  //   return Integer.decode("0x" + Integer.toHexString(c.getRGB()).substring(2));
  // }

  static String getColorNameFromColor(Color color) => getColorNameFromRgb(color.red, color.green, color.blue);

  static List<ColorName> colorList12 = [
    new ColorName("Red",                 255, 000, 000), // 1
    new ColorName("Pink",                255, 000, 127), // 3
    new ColorName("Fuchsia",             255, 000, 255), // 2
    new ColorName("Violet",              125, 000, 255), // 3
    new ColorName("Blue",                000, 000, 255), // 1
    new ColorName("Blue Azure",          000, 127, 255), // 3
    new ColorName("Blue Cyan",           000, 255, 255), // 2
    new ColorName("Green Light",         000, 255, 127), // 3
    new ColorName("Green",               000, 255, 000), // 1
    new ColorName("Green Chartreuse",    127, 255, 000), // 3
    new ColorName("Yellow",              255, 255, 000), // 2
    new ColorName("Orange",              255, 127, 000), // 2

    // new ColorName("White",     255, 255, 255),
    // new ColorName("Silver",    192, 192, 192),
    // new ColorName("Gray",      128, 128, 128),
    // new ColorName("Black",     000, 000, 000),
    // new ColorName("Red",       255, 000, 000),
    // new ColorName("Maroon",    128, 000, 000),
    // new ColorName("Yellow",    255, 255, 000),
    // new ColorName("Olive",     128, 128, 000),
    // new ColorName("Lime",      000, 255, 000),
    // new ColorName("Green",     000, 128, 000),
    // new ColorName("Aqua",      000, 255, 255),
    // new ColorName("Teal",      000, 128, 128),
    // new ColorName("Blue",      000, 000, 255),
    // new ColorName("Navy",      000, 000, 128),
    // new ColorName("Fuchsi",    255, 000, 255),
    // new ColorName("Purple",    128, 000, 128),





  ];


  static List<ColorName> initColorList()
  {
    List<ColorName> colorList = [];
    // colorList.add(new ColorName("AliceBlue", 240, 248, 15));
    // colorList.add(new ColorName("AntiqueWhite", 250, 235, 215));
    // colorList.add(new ColorName("Aqua", 0, 15, 15));
    // colorList.add(new ColorName("Aquamarine", 7, 15, 212));
    // colorList.add(new ColorName("Azure", 240, 15, 15));
    // colorList.add(new ColorName("Beige", 245, 245, 220));
    // colorList.add(new ColorName("Bisque", 15, 228, 196));
    // colorList.add(new ColorName("Black", 0, 0, 0));
    // colorList.add(new ColorName("BlanchedAlmond", 15, 235, 205));
    // colorList.add(new ColorName("Blue", 0, 0, 15));
    // colorList.add(new ColorName("BlueViolet", 138, 43, 226));
    // colorList.add(new ColorName("Brown", 165, 42, 42));
    // colorList.add(new ColorName("BurlyWood", 222, 184, 135));
    // colorList.add(new ColorName("CadetBlue", 5, 158, 160));
    // colorList.add(new ColorName("Chartreuse", 7, 15, 0));
    // colorList.add(new ColorName("Chocolate", 210, 105, 30));
    // colorList.add(new ColorName("Coral", 15, 7, 80));
    // colorList.add(new ColorName("CornflowerBlue", 100, 149, 237));
    // colorList.add(new ColorName("Cornsilk", 15, 248, 220));
    // colorList.add(new ColorName("Crimson", 220, 20, 60));
    // colorList.add(new ColorName("Cyan", 0, 15, 15));
    // colorList.add(new ColorName("DarkBlue", 0, 0, 139));
    // colorList.add(new ColorName("DarkCyan", 0, 139, 139));
    // colorList.add(new ColorName("DarkGoldenRod", 184, 134, 11));
    // colorList.add(new ColorName("DarkGray", 169, 169, 169));
    // colorList.add(new ColorName("DarkGreen", 0, 100, 0));
    // colorList.add(new ColorName("DarkKhaki", 189, 183, 107));
    // colorList.add(new ColorName("DarkMagenta", 139, 0, 139));
    // colorList.add(new ColorName("DarkOliveGreen", 85, 107, 2));
    // colorList.add(new ColorName("DarkOrange", 15, 140, 0));
    // colorList.add(new ColorName("DarkOrchid", 153, 50, 204));
    // colorList.add(new ColorName("DarkRed", 139, 0, 0));
    // colorList.add(new ColorName("DarkSalmon", 233, 150, 122));
    // colorList.add(new ColorName("DarkSeaGreen", 8, 188, 8));
    // colorList.add(new ColorName("DarkSlateBlue", 72, 61, 139));
    // colorList.add(new ColorName("DarkSlateGray", 2, 4, 4));
    // colorList.add(new ColorName("DarkTurquoise", 0, 206, 209));
    // colorList.add(new ColorName("DarkViolet", 148, 0, 211));
    // colorList.add(new ColorName("DeepPink", 15, 20, 147));
    // colorList.add(new ColorName("DeepSkyBlue", 0, 11, 15));
    // colorList.add(new ColorName("DimGray", 105, 105, 105));
    // colorList.add(new ColorName("DodgerBlue", 30, 144, 15));
    // colorList.add(new ColorName("FireBrick", 178, 34, 34));
    // colorList.add(new ColorName("FloralWhite", 15, 250, 240));
    // colorList.add(new ColorName("ForestGreen", 34, 139, 34));
    // colorList.add(new ColorName("Fuchsia", 15, 0, 15));
    // colorList.add(new ColorName("Gainsboro", 220, 220, 220));
    // colorList.add(new ColorName("GhostWhite", 248, 248, 15));
    // colorList.add(new ColorName("Gold", 15, 215, 0));
    // colorList.add(new ColorName("GoldenRod", 218, 165, 32));
    // colorList.add(new ColorName("Gray", 128, 128, 128));
    // colorList.add(new ColorName("Green", 0, 128, 0));
    // colorList.add(new ColorName("GreenYellow", 173, 15, 2));
    // colorList.add(new ColorName("HoneyDew", 240, 15, 240));
    // colorList.add(new ColorName("HotPink", 15, 105, 180));
    // colorList.add(new ColorName("IndianRed", 205, 92, 92));
    // colorList.add(new ColorName("Indigo", 75, 0, 130));
    // colorList.add(new ColorName("Ivory", 15, 15, 240));
    // colorList.add(new ColorName("Khaki", 240, 230, 140));
    // colorList.add(new ColorName("Lavender", 230, 230, 250));
    // colorList.add(new ColorName("LavenderBlush", 15, 240, 245));
    // colorList.add(new ColorName("LawnGreen", 124, 252, 0));
    // colorList.add(new ColorName("LemonChiffon", 15, 250, 205));
    // colorList.add(new ColorName("LightBlue", 173, 216, 230));
    // colorList.add(new ColorName("LightCoral", 240, 128, 128));
    // colorList.add(new ColorName("LightCyan", 224, 15, 15));
    // colorList.add(new ColorName("LightGoldenRodYellow", 250, 250, 210));
    // colorList.add(new ColorName("LightGray", 211, 211, 211));
    // colorList.add(new ColorName("LightGreen", 144, 238, 144));
    // colorList.add(new ColorName("LightPink", 15, 182, 193));
    // colorList.add(new ColorName("LightSalmon", 15, 160, 122));
    // colorList.add(new ColorName("LightSeaGreen", 32, 178, 170));
    // colorList.add(new ColorName("LightSkyBlue", 135, 206, 250));
    // colorList.add(new ColorName("LightSlateGray", 119, 136, 153));
    // colorList.add(new ColorName("LightSteelBlue", 176, 196, 222));
    // colorList.add(new ColorName("LightYellow", 15, 15, 224));
    // colorList.add(new ColorName("Lime", 0, 15, 0));
    // colorList.add(new ColorName("LimeGreen", 50, 205, 50));
    // colorList.add(new ColorName("Linen", 250, 240, 230));
    // colorList.add(new ColorName("Magenta", 15, 0, 15));
    // colorList.add(new ColorName("Maroon", 128, 0, 0));
    // colorList.add(new ColorName("MediumAquaMarine", 102, 205, 170));
    // colorList.add(new ColorName("MediumBlue", 0, 0, 205));
    // colorList.add(new ColorName("MediumOrchid", 186, 85, 211));
    // colorList.add(new ColorName("MediumPurple", 147, 112, 219));
    // colorList.add(new ColorName("MediumSeaGreen", 60, 179, 113));
    // colorList.add(new ColorName("MediumSlateBlue", 123, 104, 238));
    // colorList.add(new ColorName("MediumSpringGreen", 0, 250, 154));
    // colorList.add(new ColorName("MediumTurquoise", 72, 209, 204));
    // colorList.add(new ColorName("MediumVioletRed", 199, 21, 133));
    // colorList.add(new ColorName("MidnightBlue", 25, 25, 112));
    // colorList.add(new ColorName("MintCream", 245, 15, 250));
    // colorList.add(new ColorName("MistyRose", 15, 228, 225));
    // colorList.add(new ColorName("Moccasin", 15, 228, 181));
    // colorList.add(new ColorName("NavajoWhite", 15, 222, 173));
    // colorList.add(new ColorName("Navy", 0, 0, 128));
    // colorList.add(new ColorName("OldLace", 253, 245, 230));
    // colorList.add(new ColorName("Olive", 128, 128, 0));
    // colorList.add(new ColorName("OliveDrab", 107, 142, 35));
    // colorList.add(new ColorName("Orange", 15, 165, 0));
    // colorList.add(new ColorName("OrangeRed", 15, 69, 0));
    // colorList.add(new ColorName("Orchid", 218, 112, 214));
    // colorList.add(new ColorName("PaleGoldenRod", 238, 232, 170));
    // colorList.add(new ColorName("PaleGreen", 152, 251, 152));
    // colorList.add(new ColorName("PaleTurquoise", 10, 238, 238));
    // colorList.add(new ColorName("PaleVioletRed", 219, 112, 147));
    // colorList.add(new ColorName("PapayaWhip", 15, 14, 213));
    // colorList.add(new ColorName("PeachPuff", 15, 218, 185));
    // colorList.add(new ColorName("Peru", 205, 133, 3));
    // colorList.add(new ColorName("Pink", 15, 192, 203));
    // colorList.add(new ColorName("Plum", 221, 160, 221));
    // colorList.add(new ColorName("PowderBlue", 176, 224, 230));
    // colorList.add(new ColorName("Purple", 128, 0, 128));
    // colorList.add(new ColorName("Red", 15, 0, 0));
    // colorList.add(new ColorName("RosyBrown", 188, 8, 8));
    // colorList.add(new ColorName("RoyalBlue", 65, 105, 225));
    // colorList.add(new ColorName("SaddleBrown", 139, 69, 19));
    // colorList.add(new ColorName("Salmon", 250, 128, 114));
    // colorList.add(new ColorName("SandyBrown", 244, 164, 96));
    // colorList.add(new ColorName("SeaGreen", 46, 139, 87));
    // colorList.add(new ColorName("SeaShell", 15, 245, 238));
    // colorList.add(new ColorName("Sienna", 160, 82, 45));
    // colorList.add(new ColorName("Silver", 192, 192, 192));
    // colorList.add(new ColorName("SkyBlue", 135, 206, 235));
    // colorList.add(new ColorName("SlateBlue", 106, 90, 205));
    // colorList.add(new ColorName("SlateGray", 112, 128, 144));
    // colorList.add(new ColorName("Snow", 15, 250, 250));
    // colorList.add(new ColorName("SpringGreen", 0, 15, 7));
    // colorList.add(new ColorName("SteelBlue", 70, 130, 180));
    // colorList.add(new ColorName("Tan", 210, 180, 140));
    // colorList.add(new ColorName("Teal", 0, 128, 128));
    // colorList.add(new ColorName("Thistle", 216, 11, 216));
    // colorList.add(new ColorName("Kaki", 15, 99, 71));
    // colorList.add(new ColorName("Turquoise", 64, 224, 208));
    // colorList.add(new ColorName("Violet", 238, 130, 238));
    // colorList.add(new ColorName("Wheat", 245, 222, 179));
    // colorList.add(new ColorName("White", 15, 15, 15));
    // colorList.add(new ColorName("WhiteSmoke", 245, 245, 245));
    // colorList.add(new ColorName("Yellow", 15, 15, 0));
    // colorList.add(new ColorName("YellowGreen", 154, 205, 50));


    colorList.add(new ColorName("black"                              , 0,0,0));
    colorList.add(new ColorName("gray0"                              , 0,0,128));
    colorList.add(new ColorName("navy"                               , 0,0,139));
    colorList.add(new ColorName("NavyBlue"                           , 0,0,139));
    colorList.add(new ColorName("blue4"                              , 0,0,205));
    colorList.add(new ColorName("DarkBlue"                           , 0,0,205));
    colorList.add(new ColorName("MediumBlue"                         , 0,0,238));
    colorList.add(new ColorName("blue3"                              , 0,0,255));
    colorList.add(new ColorName("blue2"                              , 0,0,255));
    colorList.add(new ColorName("blue"                               , 0,100,0));
    colorList.add(new ColorName("blue1"                              , 0,104,139));
    colorList.add(new ColorName("DarkGreen"                          , 0,128,0));
    colorList.add(new ColorName("DeepSkyBlue4"                       , 0,128,0));
    colorList.add(new ColorName("WebGreen"                           , 0,128,128));
    colorList.add(new ColorName("green"                              , 0,134,139));
    colorList.add(new ColorName("teal"                               , 0,139,0));
    colorList.add(new ColorName("turquoise4"                         , 0,139,69));
    colorList.add(new ColorName("green4"                             , 0,139,139));
    colorList.add(new ColorName("SpringGreen4"                       , 0,139,139));
    colorList.add(new ColorName("cyan4"                              , 0,154,205));
    colorList.add(new ColorName("DarkCyan"                           , 0,178,238));
    colorList.add(new ColorName("DeepSkyBlue3"                       , 0,191,255));
    colorList.add(new ColorName("DeepSkyBlue2"                       , 0,191,255));
    colorList.add(new ColorName("DeepSkyBlue"                        , 0,197,205));
    colorList.add(new ColorName("DeepSkyBlue1"                       , 0,205,0));
    colorList.add(new ColorName("turquoise3"                         , 0,205,102));
    colorList.add(new ColorName("green3"                             , 0,205,205));
    colorList.add(new ColorName("SpringGreen3"                       , 0,206,209));
    colorList.add(new ColorName("cyan3"                              , 0,229,238));
    colorList.add(new ColorName("DarkTurquoise"                      , 0,238,0));
    colorList.add(new ColorName("turquoise2"                         , 0,238,118));
    colorList.add(new ColorName("green2"                             , 0,238,238));
    colorList.add(new ColorName("SpringGreen2"                       , 0,245,255));
    colorList.add(new ColorName("cyan2"                              , 0,250,154));
    colorList.add(new ColorName("turquoise1"                         , 0,255,0));
    colorList.add(new ColorName("MediumSpringGreen"                  , 0,255,0));
    colorList.add(new ColorName("lime"                               , 0,255,0));
    colorList.add(new ColorName("green"                              , 0,255,0));
    colorList.add(new ColorName("green1"                             , 0,255,127));
    colorList.add(new ColorName("X11Green"                           , 0,255,127));
    colorList.add(new ColorName("SpringGreen"                        , 0,255,255));
    colorList.add(new ColorName("SpringGreen1"                       , 0,255,255));
    colorList.add(new ColorName("cyan1"                              , 0,255,255));
    colorList.add(new ColorName("aqua"                               , 2,102,102));
    colorList.add(new ColorName("cyan"                               , 3,3,3));
    colorList.add(new ColorName("gray40"                             , 5,5,5));
    colorList.add(new ColorName("gray1"                              , 8,8,8));
    colorList.add(new ColorName("gray2"                              , 10,10,10));
    colorList.add(new ColorName("gray3"                              , 13,13,13));
    colorList.add(new ColorName("gray4"                              , 15,15,15));
    colorList.add(new ColorName("gray5"                              , 16,78,139));
    colorList.add(new ColorName("gray6"                              , 18,18,18));
    colorList.add(new ColorName("DodgerBlue4"                        , 20,20,20));
    colorList.add(new ColorName("gray7"                              , 23,23,23));
    colorList.add(new ColorName("gray8"                              , 24,116,205));
    colorList.add(new ColorName("gray9"                              , 25,25,112));
    colorList.add(new ColorName("DodgerBlue3"                        , 26,26,26));
    colorList.add(new ColorName("MidnightBlue"                       , 28,28,28));
    colorList.add(new ColorName("gray10"                             , 28,134,238));
    colorList.add(new ColorName("gray11"                             , 30,144,255));
    colorList.add(new ColorName("DodgerBlue2"                        , 30,144,255));
    colorList.add(new ColorName("DodgerBlue"                         , 31,31,31));
    colorList.add(new ColorName("DodgerBlue1"                        , 32,178,170));
    colorList.add(new ColorName("gray12"                             , 33,33,33));
    colorList.add(new ColorName("LightSeaGreen"                      , 34,139,34));
    colorList.add(new ColorName("gray13"                             , 36,36,36));
    colorList.add(new ColorName("ForestGreen"                        , 38,38,38));
    colorList.add(new ColorName("gray14"                             , 39,64,139));
    colorList.add(new ColorName("gray15"                             , 41,41,41));
    colorList.add(new ColorName("RoyalBlue4"                         , 43,43,43));
    colorList.add(new ColorName("gray16"                             , 46,46,46));
    colorList.add(new ColorName("gray17"                             , 46,139,87));
    colorList.add(new ColorName("gray18"                             , 46,139,87));
    colorList.add(new ColorName("SeaGreen"                           , 47,79,79));
    colorList.add(new ColorName("SeaGreen4"                          , 48,48,48));
    colorList.add(new ColorName("DarkSlateGray"                      , 50,205,50));
    colorList.add(new ColorName("gray19"                             , 51,51,51));
    colorList.add(new ColorName("LimeGreen"                          , 54,54,54));
    colorList.add(new ColorName("gray20"                             , 54,100,139));
    colorList.add(new ColorName("gray21"                             , 56,56,56));
    colorList.add(new ColorName("SteelBlue4"                         , 58,95,205));
    colorList.add(new ColorName("gray22"                             , 59,59,59));
    colorList.add(new ColorName("RoyalBlue3"                         , 60,179,113));
    colorList.add(new ColorName("gray23"                             , 61,61,61));
    colorList.add(new ColorName("MediumSeaGreen"                     , 64,64,64));
    colorList.add(new ColorName("gray24"                             , 64,224,208));
    colorList.add(new ColorName("gray25"                             , 65,105,225));
    colorList.add(new ColorName("turquoise"                          , 66,66,66));
    colorList.add(new ColorName("RoyalBlue"                          , 67,110,238));
    colorList.add(new ColorName("gray26"                             , 67,205,128));
    colorList.add(new ColorName("RoyalBlue2"                         , 69,69,69));
    colorList.add(new ColorName("SeaGreen3"                          , 69,139,0));
    colorList.add(new ColorName("gray27"                             , 69,139,116));
    colorList.add(new ColorName("chartreuse4"                        , 70,130,180));
    colorList.add(new ColorName("aquamarine4"                        , 71,60,139));
    colorList.add(new ColorName("SteelBlue"                          , 71,71,71));
    colorList.add(new ColorName("SlateBlue4"                         , 72,61,139));
    colorList.add(new ColorName("gray28"                             , 72,118,255));
    colorList.add(new ColorName("DarkSlateBlue"                      , 72,209,204));
    colorList.add(new ColorName("RoyalBlue1"                         , 74,74,74));
    colorList.add(new ColorName("MediumTurquoise"                    , 74,112,139));
    colorList.add(new ColorName("gray29"                             , 75,0,130));
    colorList.add(new ColorName("SkyBlue4"                           , 77,77,77));
    colorList.add(new ColorName("indigo"                             , 78,238,148));
    colorList.add(new ColorName("gray30"                             , 79,79,79));
    colorList.add(new ColorName("SeaGreen2"                          , 79,148,205));
    colorList.add(new ColorName("gray31"                             , 82,82,82));
    colorList.add(new ColorName("SteelBlue3"                         , 82,139,139));
    colorList.add(new ColorName("gray32"                             , 83,134,139));
    colorList.add(new ColorName("DarkSlateGray4"                     , 84,84,84));
    colorList.add(new ColorName("CadetBlue4"                         , 84,139,84));
    colorList.add(new ColorName("gray33"                             , 84,255,159));
    colorList.add(new ColorName("PaleGreen4"                         , 85,26,139));
    colorList.add(new ColorName("SeaGreen1"                          , 85,107,47));
    colorList.add(new ColorName("purple4"                            , 87,87,87));
    colorList.add(new ColorName("DarkOliveGreen"                     , 89,89,89));
    colorList.add(new ColorName("gray34"                             , 92,92,92));
    colorList.add(new ColorName("gray35"                             , 92,172,238));
    colorList.add(new ColorName("gray36"                             , 93,71,139));
    colorList.add(new ColorName("SteelBlue2"                         , 94,94,94));
    colorList.add(new ColorName("MediumPurple4"                      , 95,158,160));
    colorList.add(new ColorName("gray37"                             , 96,123,139));
    colorList.add(new ColorName("CadetBlue"                          , 97,97,97));
    colorList.add(new ColorName("LightSkyBlue4"                      , 99,99,99));
    colorList.add(new ColorName("gray38"                             , 99,184,255));
    colorList.add(new ColorName("gray39"                             , 100,149,237));
    colorList.add(new ColorName("SteelBlue1"                         , 102,51,153));
    colorList.add(new ColorName("CornflowerBlue"                     , 102,139,139));
    colorList.add(new ColorName("RebeccaPurple"                      , 102,205,0));
    colorList.add(new ColorName("PaleTurquoise4"                     , 102,205,170));
    colorList.add(new ColorName("chartreuse3"                        , 102,205,170));
    colorList.add(new ColorName("MediumAquamarine"                   , 104,34,139));
    colorList.add(new ColorName("aquamarine3"                        , 104,131,139));
    colorList.add(new ColorName("DarkOrchid4"                        , 105,89,205));
    colorList.add(new ColorName("LightBlue4"                         , 105,105,105));
    colorList.add(new ColorName("SlateBlue3"                         , 105,105,105));
    colorList.add(new ColorName("DimGray"                            , 105,139,34));
    colorList.add(new ColorName("gray41"                             , 105,139,105));
    colorList.add(new ColorName("OliveDrab4"                         , 106,90,205));
    colorList.add(new ColorName("DarkSeaGreen4"                      , 107,107,107));
    colorList.add(new ColorName("SlateBlue"                          , 107,142,35));
    colorList.add(new ColorName("gray42"                             , 108,123,139));
    colorList.add(new ColorName("OliveDrab"                          , 108,166,205));
    colorList.add(new ColorName("SlateGray4"                         , 110,110,110));
    colorList.add(new ColorName("SkyBlue3"                           , 110,123,139));
    colorList.add(new ColorName("gray43"                             , 110,139,61));
    colorList.add(new ColorName("LightSteelBlue4"                    , 112,112,112));
    colorList.add(new ColorName("DarkOliveGreen4"                    , 112,128,144));
    colorList.add(new ColorName("gray44"                             , 115,115,115));
    colorList.add(new ColorName("SlateGray"                          , 117,117,117));
    colorList.add(new ColorName("gray45"                             , 118,238,0));
    colorList.add(new ColorName("gray46"                             , 118,238,198));
    colorList.add(new ColorName("chartreuse2"                        , 119,136,153));
    colorList.add(new ColorName("aquamarine2"                        , 120,120,120));
    colorList.add(new ColorName("LightSlateGray"                     , 121,205,205));
    colorList.add(new ColorName("gray47"                             , 122,55,139));
    colorList.add(new ColorName("DarkSlateGray3"                     , 122,103,238));
    colorList.add(new ColorName("MediumOrchid4"                      , 122,122,122));
    colorList.add(new ColorName("SlateBlue2"                         , 122,139,139));
    colorList.add(new ColorName("gray48"                             , 122,197,205));
    colorList.add(new ColorName("LightCyan4"                         , 123,104,238));
    colorList.add(new ColorName("CadetBlue3"                         , 124,205,124));
    colorList.add(new ColorName("MediumSlateBlue"                    , 124,252,0));
    colorList.add(new ColorName("PaleGreen3"                         , 125,38,205));
    colorList.add(new ColorName("LawnGreen"                          , 125,125,125));
    colorList.add(new ColorName("purple3"                            , 126,192,238));
    colorList.add(new ColorName("gray49"                             , 127,127,127));
    colorList.add(new ColorName("SkyBlue2"                           , 127,255,0));
    colorList.add(new ColorName("gray50"                             , 127,255,0));
    colorList.add(new ColorName("chartreuse"                         , 127,255,212));
    colorList.add(new ColorName("chartreuse1"                        , 127,255,212));
    colorList.add(new ColorName("aquamarine"                         , 128,0,0));
    colorList.add(new ColorName("aquamarine1"                        , 128,0,0));
    colorList.add(new ColorName("WebMaroon"                          , 128,0,128));
    colorList.add(new ColorName("maroon"                             , 128,0,128));
    colorList.add(new ColorName("WebPurple"                          , 128,128,0));
    colorList.add(new ColorName("purple"                             , 128,128,128));
    colorList.add(new ColorName("olive"                              , 128,128,128));
    colorList.add(new ColorName("WebGray"                            , 130,130,130));
    colorList.add(new ColorName("gray"                               , 131,111,255));
    colorList.add(new ColorName("gray51"                             , 131,139,131));
    colorList.add(new ColorName("SlateBlue1"                         , 131,139,139));
    colorList.add(new ColorName("honeydew4"                          , 132,112,255));
    colorList.add(new ColorName("azure4"                             , 133,133,133));
    colorList.add(new ColorName("LightSlateBlue"                     , 135,135,135));
    colorList.add(new ColorName("gray52"                             , 135,206,235));
    colorList.add(new ColorName("gray53"                             , 135,206,250));
    colorList.add(new ColorName("SkyBlue"                            , 135,206,255));
    colorList.add(new ColorName("LightSkyBlue"                       , 137,104,205));
    colorList.add(new ColorName("SkyBlue1"                           , 138,43,226));
    colorList.add(new ColorName("MediumPurple3"                      , 138,138,138));
    colorList.add(new ColorName("BlueViolet"                         , 139,0,0));
    colorList.add(new ColorName("gray54"                             , 139,0,0));
    colorList.add(new ColorName("DarkRed"                            , 139,0,139));
    colorList.add(new ColorName("red4"                               , 139,0,139));
    colorList.add(new ColorName("DarkMagenta"                        , 139,10,80));
    colorList.add(new ColorName("magenta4"                           , 139,26,26));
    colorList.add(new ColorName("DeepPink4"                          , 139,28,98));
    colorList.add(new ColorName("firebrick4"                         , 139,34,82));
    colorList.add(new ColorName("maroon4"                            , 139,35,35));
    colorList.add(new ColorName("VioletRed4"                         , 139,37,0));
    colorList.add(new ColorName("brown4"                             , 139,54,38));
    colorList.add(new ColorName("OrangeRed4"                         , 139,58,58));
    colorList.add(new ColorName("tomato4"                            , 139,58,98));
    colorList.add(new ColorName("IndianRed4"                         , 139,62,47));
    colorList.add(new ColorName("HotPink4"                           , 139,69,0));
    colorList.add(new ColorName("coral4"                             , 139,69,19));
    colorList.add(new ColorName("DarkOrange4"                        , 139,69,19));
    colorList.add(new ColorName("SaddleBrown"                        , 139,71,38));
    colorList.add(new ColorName("chocolate4"                         , 139,71,93));
    colorList.add(new ColorName("sienna4"                            , 139,71,137));
    colorList.add(new ColorName("PaleVioletRed4"                     , 139,76,57));
    colorList.add(new ColorName("orchid4"                            , 139,87,66));
    colorList.add(new ColorName("salmon4"                            , 139,90,0));
    colorList.add(new ColorName("LightSalmon4"                       , 139,90,43));
    colorList.add(new ColorName("orange4"                            , 139,95,101));
    colorList.add(new ColorName("tan4"                               , 139,99,108));
    colorList.add(new ColorName("LightPink4"                         , 139,101,8));
    colorList.add(new ColorName("pink4"                              , 139,102,139));
    colorList.add(new ColorName("DarkGoldenrod4"                     , 139,105,20));
    colorList.add(new ColorName("plum4"                              , 139,105,105));
    colorList.add(new ColorName("goldenrod4"                         , 139,115,85));
    colorList.add(new ColorName("RosyBrown4"                         , 139,117,0));
    colorList.add(new ColorName("burlywood4"                         , 139,119,101));
    colorList.add(new ColorName("gold4"                              , 139,121,94));
    colorList.add(new ColorName("PeachPuff4"                         , 139,123,139));
    colorList.add(new ColorName("NavajoWhite4"                       , 139,125,107));
    colorList.add(new ColorName("thistle4"                           , 139,125,123));
    colorList.add(new ColorName("bisque4"                            , 139,126,102));
    colorList.add(new ColorName("MistyRose4"                         , 139,129,76));
    colorList.add(new ColorName("wheat4"                             , 139,131,120));
    colorList.add(new ColorName("LightGoldenrod4"                    , 139,131,134));
    colorList.add(new ColorName("AntiqueWhite4"                      , 139,134,78));
    colorList.add(new ColorName("LavenderBlush4"                     , 139,134,130));
    colorList.add(new ColorName("khaki4"                             , 139,136,120));
    colorList.add(new ColorName("seashell4"                          , 139,137,112));
    colorList.add(new ColorName("cornsilk4"                          , 139,137,137));
    colorList.add(new ColorName("LemonChiffon4"                      , 139,139,0));
    colorList.add(new ColorName("snow4"                              , 139,139,122));
    colorList.add(new ColorName("yellow4"                            , 139,139,131));
    colorList.add(new ColorName("LightYellow4"                       , 140,140,140));
    colorList.add(new ColorName("ivory4"                             , 141,182,205));
    colorList.add(new ColorName("gray55"                             , 141,238,238));
    colorList.add(new ColorName("LightSkyBlue3"                      , 142,229,238));
    colorList.add(new ColorName("DarkSlateGray2"                     , 143,143,143));
    colorList.add(new ColorName("CadetBlue2"                         , 143,188,143));
    colorList.add(new ColorName("gray56"                             , 144,238,144));
    colorList.add(new ColorName("DarkSeaGreen"                       , 144,238,144));
    colorList.add(new ColorName("LightGreen"                         , 145,44,238));
    colorList.add(new ColorName("PaleGreen2"                         , 145,145,145));
    colorList.add(new ColorName("purple2"                            , 147,112,219));
    colorList.add(new ColorName("gray57"                             , 148,0,211));
    colorList.add(new ColorName("MediumPurple"                       , 148,148,148));
    colorList.add(new ColorName("DarkViolet"                         , 150,150,150));
    colorList.add(new ColorName("gray58"                             , 150,205,205));
    colorList.add(new ColorName("gray59"                             , 151,255,255));
    colorList.add(new ColorName("PaleTurquoise3"                     , 152,245,255));
    colorList.add(new ColorName("DarkSlateGray1"                     , 152,251,152));
    colorList.add(new ColorName("CadetBlue1"                         , 153,50,204));
    colorList.add(new ColorName("PaleGreen"                          , 153,153,153));
    colorList.add(new ColorName("DarkOrchid"                         , 154,50,205));
    colorList.add(new ColorName("gray60"                             , 154,192,205));
    colorList.add(new ColorName("DarkOrchid3"                        , 154,205,50));
    colorList.add(new ColorName("LightBlue3"                         , 154,205,50));
    colorList.add(new ColorName("YellowGreen"                        , 154,255,154));
    colorList.add(new ColorName("OliveDrab3"                         , 155,48,255));
    colorList.add(new ColorName("PaleGreen1"                         , 155,205,155));
    colorList.add(new ColorName("purple1"                            , 156,156,156));
    colorList.add(new ColorName("DarkSeaGreen3"                      , 158,158,158));
    colorList.add(new ColorName("gray61"                             , 159,121,238));
    colorList.add(new ColorName("gray62"                             , 159,182,205));
    colorList.add(new ColorName("MediumPurple2"                      , 160,32,240));
    colorList.add(new ColorName("SlateGray3"                         , 160,32,240));
    colorList.add(new ColorName("purple"                             , 160,82,45));
    colorList.add(new ColorName("X11Purple"                          , 161,161,161));
    colorList.add(new ColorName("sienna"                             , 162,181,205));
    colorList.add(new ColorName("gray63"                             , 162,205,90));
    colorList.add(new ColorName("LightSteelBlue3"                    , 163,163,163));
    colorList.add(new ColorName("DarkOliveGreen3"                    , 164,211,238));
    colorList.add(new ColorName("gray64"                             , 165,42,42));
    colorList.add(new ColorName("LightSkyBlue2"                      , 166,166,166));
    colorList.add(new ColorName("brown"                              , 168,168,168));
    colorList.add(new ColorName("gray65"                             , 169,169,169));
    colorList.add(new ColorName("gray66"                             , 171,130,255));
    colorList.add(new ColorName("DarkGray"                           , 171,171,171));
    colorList.add(new ColorName("MediumPurple1"                      , 173,173,173));
    colorList.add(new ColorName("gray67"                             , 173,216,230));
    colorList.add(new ColorName("gray68"                             , 173,255,47));
    colorList.add(new ColorName("LightBlue"                          , 174,238,238));
    colorList.add(new ColorName("GreenYellow"                        , 175,238,238));
    colorList.add(new ColorName("PaleTurquoise2"                     , 176,48,96));
    colorList.add(new ColorName("PaleTurquoise"                      , 176,48,96));
    colorList.add(new ColorName("maroon"                             , 176,176,176));
    colorList.add(new ColorName("X11Maroon"                          , 176,196,222));
    colorList.add(new ColorName("gray69"                             , 176,224,230));
    colorList.add(new ColorName("LightSteelBlue"                     , 176,226,255));
    colorList.add(new ColorName("PowderBlue"                         , 178,34,34));
    colorList.add(new ColorName("LightSkyBlue1"                      , 178,58,238));
    colorList.add(new ColorName("firebrick"                          , 178,223,238));
    colorList.add(new ColorName("DarkOrchid2"                        , 179,179,179));
    colorList.add(new ColorName("LightBlue2"                         , 179,238,58));
    colorList.add(new ColorName("gray70"                             , 180,82,205));
    colorList.add(new ColorName("OliveDrab2"                         , 180,205,205));
    colorList.add(new ColorName("MediumOrchid3"                      , 180,238,180));
    colorList.add(new ColorName("LightCyan3"                         , 181,181,181));
    colorList.add(new ColorName("DarkSeaGreen2"                      , 184,134,11));
    colorList.add(new ColorName("gray71"                             , 184,184,184));
    colorList.add(new ColorName("DarkGoldenrod"                      , 185,211,238));
    colorList.add(new ColorName("gray72"                             , 186,85,211));
    colorList.add(new ColorName("SlateGray2"                         , 186,186,186));
    colorList.add(new ColorName("MediumOrchid"                       , 187,255,255));
    colorList.add(new ColorName("gray73"                             , 188,143,143));
    colorList.add(new ColorName("PaleTurquoise1"                     , 188,210,238));
    colorList.add(new ColorName("RosyBrown"                          , 188,238,104));
    colorList.add(new ColorName("LightSteelBlue2"                    , 189,183,107));
    colorList.add(new ColorName("DarkOliveGreen2"                    , 189,189,189));
    colorList.add(new ColorName("DarkKhaki"                          , 190,190,190));
    colorList.add(new ColorName("gray74"                             , 190,190,190));
    colorList.add(new ColorName("gray"                               , 191,62,255));
    colorList.add(new ColorName("X11Gray"                            , 191,191,191));
    colorList.add(new ColorName("DarkOrchid1"                        , 191,239,255));
    colorList.add(new ColorName("gray75"                             , 192,192,192));
    colorList.add(new ColorName("LightBlue1"                         , 192,255,62));
    colorList.add(new ColorName("silver"                             , 193,205,193));
    colorList.add(new ColorName("OliveDrab1"                         , 193,205,205));
    colorList.add(new ColorName("honeydew3"                          , 193,255,193));
    colorList.add(new ColorName("azure3"                             , 194,194,194));
    colorList.add(new ColorName("DarkSeaGreen1"                      , 196,196,196));
    colorList.add(new ColorName("gray76"                             , 198,226,255));
    colorList.add(new ColorName("gray77"                             , 199,21,133));
    colorList.add(new ColorName("SlateGray1"                         , 199,199,199));
    colorList.add(new ColorName("MediumVioletRed"                    , 201,201,201));
    colorList.add(new ColorName("gray78"                             , 202,225,255));
    colorList.add(new ColorName("gray79"                             , 202,255,112));
    colorList.add(new ColorName("LightSteelBlue1"                    , 204,204,204));
    colorList.add(new ColorName("DarkOliveGreen1"                    , 205,0,0));
    colorList.add(new ColorName("gray80"                             , 205,0,205));
    colorList.add(new ColorName("red3"                               , 205,16,118));
    colorList.add(new ColorName("magenta3"                           , 205,38,38));
    colorList.add(new ColorName("DeepPink3"                          , 205,41,144));
    colorList.add(new ColorName("firebrick3"                         , 205,50,120));
    colorList.add(new ColorName("maroon3"                            , 205,51,51));
    colorList.add(new ColorName("VioletRed3"                         , 205,55,0));
    colorList.add(new ColorName("brown3"                             , 205,79,57));
    colorList.add(new ColorName("OrangeRed3"                         , 205,85,85));
    colorList.add(new ColorName("tomato3"                            , 205,91,69));
    colorList.add(new ColorName("IndianRed3"                         , 205,92,92));
    colorList.add(new ColorName("coral3"                             , 205,96,144));
    colorList.add(new ColorName("IndianRed"                          , 205,102,0));
    colorList.add(new ColorName("HotPink3"                           , 205,102,29));
    colorList.add(new ColorName("DarkOrange3"                        , 205,104,57));
    colorList.add(new ColorName("chocolate3"                         , 205,104,137));
    colorList.add(new ColorName("sienna3"                            , 205,105,201));
    colorList.add(new ColorName("PaleVioletRed3"                     , 205,112,84));
    colorList.add(new ColorName("orchid3"                            , 205,129,98));
    colorList.add(new ColorName("salmon3"                            , 205,133,0));
    colorList.add(new ColorName("LightSalmon3"                       , 205,133,63));
    colorList.add(new ColorName("orange3"                            , 205,133,63));
    colorList.add(new ColorName("peru"                               , 205,140,149));
    colorList.add(new ColorName("tan3"                               , 205,145,158));
    colorList.add(new ColorName("LightPink3"                         , 205,149,12));
    colorList.add(new ColorName("pink3"                              , 205,150,205));
    colorList.add(new ColorName("DarkGoldenrod3"                     , 205,155,29));
    colorList.add(new ColorName("plum3"                              , 205,155,155));
    colorList.add(new ColorName("goldenrod3"                         , 205,170,125));
    colorList.add(new ColorName("RosyBrown3"                         , 205,173,0));
    colorList.add(new ColorName("burlywood3"                         , 205,175,149));
    colorList.add(new ColorName("gold3"                              , 205,179,139));
    colorList.add(new ColorName("PeachPuff3"                         , 205,181,205));
    colorList.add(new ColorName("NavajoWhite3"                       , 205,183,158));
    colorList.add(new ColorName("thistle3"                           , 205,183,181));
    colorList.add(new ColorName("bisque3"                            , 205,186,150));
    colorList.add(new ColorName("MistyRose3"                         , 205,190,112));
    colorList.add(new ColorName("wheat3"                             , 205,192,176));
    colorList.add(new ColorName("LightGoldenrod3"                    , 205,193,197));
    colorList.add(new ColorName("AntiqueWhite3"                      , 205,197,191));
    colorList.add(new ColorName("LavenderBlush3"                     , 205,198,115));
    colorList.add(new ColorName("seashell3"                          , 205,200,177));
    colorList.add(new ColorName("khaki3"                             , 205,201,165));
    colorList.add(new ColorName("cornsilk3"                          , 205,201,201));
    colorList.add(new ColorName("LemonChiffon3"                      , 205,205,0));
    colorList.add(new ColorName("snow3"                              , 205,205,180));
    colorList.add(new ColorName("yellow3"                            , 205,205,193));
    colorList.add(new ColorName("LightYellow3"                       , 207,207,207));
    colorList.add(new ColorName("ivory3"                             , 208,32,144));
    colorList.add(new ColorName("gray81"                             , 209,95,238));
    colorList.add(new ColorName("VioletRed"                          , 209,209,209));
    colorList.add(new ColorName("MediumOrchid2"                      , 209,238,238));
    colorList.add(new ColorName("gray82"                             , 210,105,30));
    colorList.add(new ColorName("LightCyan2"                         , 210,180,140));
    colorList.add(new ColorName("chocolate"                          , 211,211,211));
    colorList.add(new ColorName("tan"                                , 212,212,212));
    colorList.add(new ColorName("LightGray"                          , 214,214,214));
    colorList.add(new ColorName("gray83"                             , 216,191,216));
    colorList.add(new ColorName("gray84"                             , 217,217,217));
    colorList.add(new ColorName("thistle"                            , 218,112,214));
    colorList.add(new ColorName("gray85"                             , 218,165,32));
    colorList.add(new ColorName("orchid"                             , 219,112,147));
    colorList.add(new ColorName("goldenrod"                          , 219,219,219));
    colorList.add(new ColorName("PaleVioletRed"                      , 220,20,60));
    colorList.add(new ColorName("gray86"                             , 220,220,220));
    colorList.add(new ColorName("crimson"                            , 221,160,221));
    colorList.add(new ColorName("gainsboro"                          , 222,184,135));
    colorList.add(new ColorName("plum"                               , 222,222,222));
    colorList.add(new ColorName("burlywood"                          , 224,102,255));
    colorList.add(new ColorName("gray87"                             , 224,224,224));
    colorList.add(new ColorName("MediumOrchid1"                      , 224,238,224));
    colorList.add(new ColorName("gray88"                             , 224,238,238));
    colorList.add(new ColorName("honeydew2"                          , 224,255,255));
    colorList.add(new ColorName("azure2"                             , 224,255,255));
    colorList.add(new ColorName("LightCyan"                          , 227,227,227));
    colorList.add(new ColorName("LightCyan1"                         , 229,229,229));
    colorList.add(new ColorName("gray89"                             , 230,230,250));
    colorList.add(new ColorName("gray90"                             , 232,232,232));
    colorList.add(new ColorName("lavender"                           , 233,150,122));
    colorList.add(new ColorName("gray91"                             , 235,235,235));
    colorList.add(new ColorName("DarkSalmon"                         , 237,237,237));
    colorList.add(new ColorName("gray92"                             , 238,0,0));
    colorList.add(new ColorName("gray93"                             , 238,0,238));
    colorList.add(new ColorName("red2"                               , 238,18,137));
    colorList.add(new ColorName("magenta2"                           , 238,44,44));
    colorList.add(new ColorName("DeepPink2"                          , 238,48,167));
    colorList.add(new ColorName("firebrick2"                         , 238,58,140));
    colorList.add(new ColorName("maroon2"                            , 238,59,59));
    colorList.add(new ColorName("VioletRed2"                         , 238,64,0));
    colorList.add(new ColorName("brown2"                             , 238,92,66));
    colorList.add(new ColorName("OrangeRed2"                         , 238,99,99));
    colorList.add(new ColorName("tomato2"                            , 238,106,80));
    colorList.add(new ColorName("IndianRed2"                         , 238,106,167));
    colorList.add(new ColorName("coral2"                             , 238,118,0));
    colorList.add(new ColorName("HotPink2"                           , 238,118,33));
    colorList.add(new ColorName("DarkOrange2"                        , 238,121,66));
    colorList.add(new ColorName("chocolate2"                         , 238,121,159));
    colorList.add(new ColorName("sienna2"                            , 238,122,233));
    colorList.add(new ColorName("PaleVioletRed2"                     , 238,130,98));
    colorList.add(new ColorName("orchid2"                            , 238,130,238));
    colorList.add(new ColorName("salmon2"                            , 238,149,114));
    colorList.add(new ColorName("violet"                             , 238,154,0));
    colorList.add(new ColorName("LightSalmon2"                       , 238,154,73));
    colorList.add(new ColorName("orange2"                            , 238,162,173));
    colorList.add(new ColorName("tan2"                               , 238,169,184));
    colorList.add(new ColorName("LightPink2"                         , 238,173,14));
    colorList.add(new ColorName("pink2"                              , 238,174,238));
    colorList.add(new ColorName("DarkGoldenrod2"                     , 238,180,34));
    colorList.add(new ColorName("plum2"                              , 238,180,180));
    colorList.add(new ColorName("goldenrod2"                         , 238,197,145));
    colorList.add(new ColorName("RosyBrown2"                         , 238,201,0));
    colorList.add(new ColorName("burlywood2"                         , 238,203,173));
    colorList.add(new ColorName("gold2"                              , 238,207,161));
    colorList.add(new ColorName("PeachPuff2"                         , 238,210,238));
    colorList.add(new ColorName("NavajoWhite2"                       , 238,213,183));
    colorList.add(new ColorName("thistle2"                           , 238,213,210));
    colorList.add(new ColorName("bisque2"                            , 238,216,174));
    colorList.add(new ColorName("MistyRose2"                         , 238,220,130));
    colorList.add(new ColorName("wheat2"                             , 238,221,130));
    colorList.add(new ColorName("LightGoldenrod2"                    , 238,223,204));
    colorList.add(new ColorName("LightGoldenrod"                     , 238,224,229));
    colorList.add(new ColorName("AntiqueWhite2"                      , 238,229,222));
    colorList.add(new ColorName("LavenderBlush2"                     , 238,230,133));
    colorList.add(new ColorName("seashell2"                          , 238,232,170));
    colorList.add(new ColorName("khaki2"                             , 238,232,205));
    colorList.add(new ColorName("PaleGoldenrod"                      , 238,233,191));
    colorList.add(new ColorName("cornsilk2"                          , 238,233,233));
    colorList.add(new ColorName("LemonChiffon2"                      , 238,238,0));
    colorList.add(new ColorName("snow2"                              , 238,238,209));
    colorList.add(new ColorName("yellow2"                            , 238,238,224));
    colorList.add(new ColorName("LightYellow2"                       , 240,128,128));
    colorList.add(new ColorName("ivory2"                             , 240,230,140));
    colorList.add(new ColorName("LightCoral"                         , 240,240,240));
    colorList.add(new ColorName("khaki"                              , 240,248,255));
    colorList.add(new ColorName("gray94"                             , 240,255,240));
    colorList.add(new ColorName("AliceBlue"                          , 240,255,240));
    colorList.add(new ColorName("honeydew"                           , 240,255,255));
    colorList.add(new ColorName("honeydew1"                          , 240,255,255));
    colorList.add(new ColorName("azure"                              , 242,242,242));
    colorList.add(new ColorName("azure1"                             , 244,164,96));
    colorList.add(new ColorName("gray95"                             , 245,222,179));
    colorList.add(new ColorName("SandyBrown"                         , 245,245,220));
    colorList.add(new ColorName("wheat"                              , 245,245,245));
    colorList.add(new ColorName("beige"                              , 245,245,245));
    colorList.add(new ColorName("WhiteSmoke"                         , 245,255,250));
    colorList.add(new ColorName("gray96"                             , 247,247,247));
    colorList.add(new ColorName("MintCream"                          , 248,248,255));
    colorList.add(new ColorName("gray97"                             , 250,128,114));
    colorList.add(new ColorName("GhostWhite"                         , 250,235,215));
    colorList.add(new ColorName("salmon"                             , 250,240,230));
    colorList.add(new ColorName("AntiqueWhite"                       , 250,250,210));
    colorList.add(new ColorName("linen"                              , 250,250,250));
    colorList.add(new ColorName("LightGoldenrodYellow"               , 252,252,252));
    colorList.add(new ColorName("gray98"                             , 253,245,230));
    colorList.add(new ColorName("gray99"                             , 255,0,0));
    colorList.add(new ColorName("OldLace"                            , 255,0,0));
    colorList.add(new ColorName("red"                                , 255,0,255));
    colorList.add(new ColorName("red1"                               , 255,0,255));
    colorList.add(new ColorName("magenta1"                           , 255,0,255));
    colorList.add(new ColorName("fuchsia"                            , 255,20,147));
    colorList.add(new ColorName("magenta"                            , 255,20,147));
    colorList.add(new ColorName("DeepPink"                           , 255,48,48));
    colorList.add(new ColorName("DeepPink1"                          , 255,52,179));
    colorList.add(new ColorName("firebrick1"                         , 255,62,150));
    colorList.add(new ColorName("maroon1"                            , 255,64,64));
    colorList.add(new ColorName("VioletRed1"                         , 255,69,0));
    colorList.add(new ColorName("brown1"                             , 255,69,0));
    colorList.add(new ColorName("OrangeRed"                          , 255,99,71));
    colorList.add(new ColorName("OrangeRed1"                         , 255,99,71));
    colorList.add(new ColorName("tomato"                             , 255,105,180));
    colorList.add(new ColorName("tomato1"                            , 255,106,106));
    colorList.add(new ColorName("HotPink"                            , 255,110,180));
    colorList.add(new ColorName("IndianRed1"                         , 255,114,86));
    colorList.add(new ColorName("HotPink1"                           , 255,127,0));
    colorList.add(new ColorName("coral1"                             , 255,127,36));
    colorList.add(new ColorName("DarkOrange1"                        , 255,127,80));
    colorList.add(new ColorName("chocolate1"                         , 255,130,71));
    colorList.add(new ColorName("coral"                              , 255,130,171));
    colorList.add(new ColorName("sienna1"                            , 255,131,250));
    colorList.add(new ColorName("PaleVioletRed1"                     , 255,140,0));
    colorList.add(new ColorName("orchid1"                            , 255,140,105));
    colorList.add(new ColorName("DarkOrange"                         , 255,160,122));
    colorList.add(new ColorName("salmon1"                            , 255,160,122));
    colorList.add(new ColorName("LightSalmon"                        , 255,165,0));
    colorList.add(new ColorName("LightSalmon1"                       , 255,165,0));
    colorList.add(new ColorName("orange"                             , 255,165,79));
    colorList.add(new ColorName("orange1"                            , 255,174,185));
    colorList.add(new ColorName("tan1"                               , 255,181,197));
    colorList.add(new ColorName("LightPink1"                         , 255,182,193));
    colorList.add(new ColorName("pink1"                              , 255,185,15));
    colorList.add(new ColorName("LightPink"                          , 255,187,255));
    colorList.add(new ColorName("DarkGoldenrod1"                     , 255,192,203));
    colorList.add(new ColorName("plum1"                              , 255,193,37));
    colorList.add(new ColorName("pink"                               , 255,193,193));
    colorList.add(new ColorName("goldenrod1"                         , 255,211,155));
    colorList.add(new ColorName("RosyBrown1"                         , 255,215,0));
    colorList.add(new ColorName("burlywood1"                         , 255,215,0));
    colorList.add(new ColorName("gold"                               , 255,218,185));
    colorList.add(new ColorName("gold1"                              , 255,218,185));
    colorList.add(new ColorName("PeachPuff"                          , 255,222,173));
    colorList.add(new ColorName("PeachPuff1"                         , 255,222,173));
    colorList.add(new ColorName("NavajoWhite"                        , 255,225,255));
    colorList.add(new ColorName("NavajoWhite1"                       , 255,228,181));
    colorList.add(new ColorName("thistle1"                           , 255,228,196));
    colorList.add(new ColorName("moccasin"                           , 255,228,196));
    colorList.add(new ColorName("bisque"                             , 255,228,225));
    colorList.add(new ColorName("bisque1"                            , 255,228,225));
    colorList.add(new ColorName("MistyRose"                          , 255,231,186));
    colorList.add(new ColorName("MistyRose1"                         , 255,235,205));
    colorList.add(new ColorName("wheat1"                             , 255,236,139));
    colorList.add(new ColorName("BlanchedAlmond"                     , 255,239,213));
    colorList.add(new ColorName("LightGoldenrod1"                    , 255,239,219));
    colorList.add(new ColorName("PapayaWhip"                         , 255,240,245));
    colorList.add(new ColorName("AntiqueWhite1"                      , 255,240,245));
    colorList.add(new ColorName("LavenderBlush"                      , 255,245,238));
    colorList.add(new ColorName("LavenderBlush1"                     , 255,245,238));
    colorList.add(new ColorName("seashell"                           , 255,246,143));
    colorList.add(new ColorName("seashell1"                          , 255,248,220));
    colorList.add(new ColorName("khaki1"                             , 255,248,220));
    colorList.add(new ColorName("cornsilk"                           , 255,250,205));
    colorList.add(new ColorName("cornsilk1"                          , 255,250,205));
    colorList.add(new ColorName("LemonChiffon"                       , 255,250,240));
    colorList.add(new ColorName("LemonChiffon1"                      , 255,250,250));
    colorList.add(new ColorName("FloralWhite"                        , 255,250,250));
    colorList.add(new ColorName("snow"                               , 255,255,0));
    colorList.add(new ColorName("snow1"                              , 255,255,0));
    colorList.add(new ColorName("yellow"                             , 255,255,224));
    colorList.add(new ColorName("yellow1"                            , 255,255,224));
    colorList.add(new ColorName("LightYellow"                        , 255,255,240));
    colorList.add(new ColorName("LightYellow1"                       , 255,255,240));
    colorList.add(new ColorName("ivory"                              , 255,255,255));
    colorList.add(new ColorName("ivory1"                             , 255,255,255));

    return colorList;
  }
}

class ColorName {
  int r;
  int g;
  int b;
  String name;

  ColorName(this.name, this.r, this.g, this.b);
  static ColorName fromHex(String name, String hex) {
    String hexColor = hex.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    Color color = Color(int.parse(hexColor, radix: 16));
    return ColorName(name, color.red, color.green, color.blue);
  }

  int computeMSE(int pixR, int pixG, int pixB)
  {
    return ((((pixR - r) * (pixR - r)) + ((pixG - g) * (pixG - g))) + ((pixB - b) * (pixB - b))) ~/ 3;
  }

  int getR()
  {
    return r;
  }

  int getG()
  {
    return g;
  }

  int getB()
  {
    return b;
  }

  String getName()
  {
    return name;
  }
}