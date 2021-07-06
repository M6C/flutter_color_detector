// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

ColorApi welcomeFromJson(String str) => ColorApi.fromJson(json.decode(str));

String welcomeToJson(ColorApi data) => json.encode(data.toJson());

class ColorApi {
    ColorApi({
        this.hex,
        this.rgb,
        this.hsl,
        this.hsv,
        this.name,
        this.cmyk,
        this.xyz,
        this.image,
        this.contrast,
        this.links,
        this.embedded,
    });

    final Hex? hex;
    final Rgb? rgb;
    final Hsl? hsl;
    final Hsv? hsv;
    final Name? name;
    final Cmyk? cmyk;
    final Xyz? xyz;
    final Image? image;
    final Contrast? contrast;
    final Links? links;
    final Embedded? embedded;

    factory ColorApi.fromJson(Map<String, dynamic> json) => ColorApi(
        hex: json["hex"] == null ? null : Hex.fromJson(json["hex"]),
        rgb: json["rgb"] == null ? null : Rgb.fromJson(json["rgb"]),
        hsl: json["hsl"] == null ? null : Hsl.fromJson(json["hsl"]),
        hsv: json["hsv"] == null ? null : Hsv.fromJson(json["hsv"]),
        name: json["name"] == null ? null : Name.fromJson(json["name"]),
        cmyk: json["cmyk"] == null ? null : Cmyk.fromJson(json["cmyk"]),
        xyz: json["XYZ"] == null ? null : Xyz.fromJson(json["XYZ"]),
        image: json["image"] == null ? null : Image.fromJson(json["image"]),
        contrast: json["contrast"] == null ? null : Contrast.fromJson(json["contrast"]),
        links: json["_links"] == null ? null : Links.fromJson(json["_links"]),
        embedded: json["_embedded"] == null ? null : Embedded.fromJson(json["_embedded"]),
    );

    Map<String, dynamic> toJson() => {
        "hex": hex == null ? null : hex!.toJson(),
        "rgb": rgb == null ? null : rgb!.toJson(),
        "hsl": hsl == null ? null : hsl!.toJson(),
        "hsv": hsv == null ? null : hsv!.toJson(),
        "name": name == null ? null : name!.toJson(),
        "cmyk": cmyk == null ? null : cmyk!.toJson(),
        "XYZ": xyz == null ? null : xyz!.toJson(),
        "image": image == null ? null : image!.toJson(),
        "contrast": contrast == null ? null : contrast!.toJson(),
        "_links": links == null ? null : links!.toJson(),
        "_embedded": embedded == null ? null : embedded!.toJson(),
    };
}

class Cmyk {
    Cmyk({
        this.fraction,
        this.value,
        this.c,
        this.m,
        this.y,
        this.k,
    });

    final CmykFraction? fraction;
    final String? value;
    final int? c;
    final int? m;
    final int? y;
    final int? k;

    factory Cmyk.fromJson(Map<String, dynamic> json) => Cmyk(
        fraction: json["fraction"] == null ? null : CmykFraction.fromJson(json["fraction"]),
        value: json["value"] == null ? null : json["value"],
        c: json["c"] == null ? null : json["c"],
        m: json["m"] == null ? null : json["m"],
        y: json["y"] == null ? null : json["y"],
        k: json["k"] == null ? null : json["k"],
    );

    Map<String, dynamic> toJson() => {
        "fraction": fraction == null ? null : fraction!.toJson(),
        "value": value == null ? null : value,
        "c": c == null ? null : c,
        "m": m == null ? null : m,
        "y": y == null ? null : y,
        "k": k == null ? null : k,
    };
}

class CmykFraction {
    CmykFraction({
        this.c,
        this.m,
        this.y,
        this.k,
    });

    final double? c;
    final double? m;
    final double? y;
    final double? k;

    factory CmykFraction.fromJson(Map<String, dynamic> json) => CmykFraction(
        c: json["c"] == null ? null : json["c"].toDouble(),
        m: json["m"] == null ? null : json["m"].toDouble(),
        y: json["y"] == null ? null : json["y"].toDouble(),
        k: json["k"] == null ? null : json["k"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "c": c == null ? null : c,
        "m": m == null ? null : m,
        "y": y == null ? null : y,
        "k": k == null ? null : k,
    };
}

class Contrast {
    Contrast({
        this.value,
    });

    final String? value;

    factory Contrast.fromJson(Map<String, dynamic> json) => Contrast(
        value: json["value"] == null ? null : json["value"],
    );

    Map<String, dynamic> toJson() => {
        "value": value == null ? null : value,
    };
}

class Embedded {
    Embedded();

    factory Embedded.fromJson(Map<String, dynamic> json) => Embedded(
    );

    Map<String, dynamic> toJson() => {
    };
}

class Hex {
    Hex({
        this.value,
        this.clean,
    });

    final String? value;
    final String? clean;

    factory Hex.fromJson(Map<String, dynamic> json) => Hex(
        value: json["value"] == null ? null : json["value"],
        clean: json["clean"] == null ? null : json["clean"],
    );

    Map<String, dynamic> toJson() => {
        "value": value == null ? null : value,
        "clean": clean == null ? null : clean,
    };
}

class Hsl {
    Hsl({
        this.fraction,
        this.h,
        this.s,
        this.l,
        this.value,
    });

    final HslFraction? fraction;
    final int? h;
    final int? s;
    final int? l;
    final String? value;

    factory Hsl.fromJson(Map<String, dynamic> json) => Hsl(
        fraction: json["fraction"] == null ? null : HslFraction.fromJson(json["fraction"]),
        h: json["h"] == null ? null : json["h"],
        s: json["s"] == null ? null : json["s"],
        l: json["l"] == null ? null : json["l"],
        value: json["value"] == null ? null : json["value"],
    );

    Map<String, dynamic> toJson() => {
        "fraction": fraction == null ? null : fraction!.toJson(),
        "h": h == null ? null : h,
        "s": s == null ? null : s,
        "l": l == null ? null : l,
        "value": value == null ? null : value,
    };
}

class HslFraction {
    HslFraction({
        this.h,
        this.s,
        this.l,
    });

    final double? h;
    final double? s;
    final double? l;

    factory HslFraction.fromJson(Map<String, dynamic> json) => HslFraction(
        h: json["h"] == null ? null : json["h"].toDouble(),
        s: json["s"] == null ? null : json["s"].toDouble(),
        l: json["l"] == null ? null : json["l"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "h": h == null ? null : h,
        "s": s == null ? null : s,
        "l": l == null ? null : l,
    };
}

class Hsv {
    Hsv({
        this.fraction,
        this.value,
        this.h,
        this.s,
        this.v,
    });

    final HsvFraction? fraction;
    final String? value;
    final int? h;
    final int? s;
    final int? v;

    factory Hsv.fromJson(Map<String, dynamic> json) => Hsv(
        fraction: json["fraction"] == null ? null : HsvFraction.fromJson(json["fraction"]),
        value: json["value"] == null ? null : json["value"],
        h: json["h"] == null ? null : json["h"],
        s: json["s"] == null ? null : json["s"],
        v: json["v"] == null ? null : json["v"],
    );

    Map<String, dynamic> toJson() => {
        "fraction": fraction == null ? null : fraction!.toJson(),
        "value": value == null ? null : value,
        "h": h == null ? null : h,
        "s": s == null ? null : s,
        "v": v == null ? null : v,
    };
}

class HsvFraction {
    HsvFraction({
        this.h,
        this.s,
        this.v,
    });

    final double? h;
    final double? s;
    final double? v;

    factory HsvFraction.fromJson(Map<String, dynamic> json) => HsvFraction(
        h: json["h"] == null ? null : json["h"].toDouble(),
        s: json["s"] == null ? null : json["s"].toDouble(),
        v: json["v"] == null ? null : json["v"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "h": h == null ? null : h,
        "s": s == null ? null : s,
        "v": v == null ? null : v,
    };
}

class Image {
    Image({
        this.bare,
        this.named,
    });

    final String? bare;
    final String? named;

    factory Image.fromJson(Map<String, dynamic> json) => Image(
        bare: json["bare"] == null ? null : json["bare"],
        named: json["named"] == null ? null : json["named"],
    );

    Map<String, dynamic> toJson() => {
        "bare": bare == null ? null : bare,
        "named": named == null ? null : named,
    };
}

class Links {
    Links({
        this.self,
    });

    final Self? self;

    factory Links.fromJson(Map<String, dynamic> json) => Links(
        self: json["self"] == null ? null : Self.fromJson(json["self"]),
    );

    Map<String, dynamic> toJson() => {
        "self": self == null ? null : self!.toJson(),
    };
}

class Self {
    Self({
        this.href,
    });

    final String? href;

    factory Self.fromJson(Map<String, dynamic> json) => Self(
        href: json["href"] == null ? null : json["href"],
    );

    Map<String, dynamic> toJson() => {
        "href": href == null ? null : href,
    };
}

class Name {
    Name({
        this.value,
        this.closestNamedHex,
        this.exactMatchName,
        this.distance,
    });

    final String? value;
    final String? closestNamedHex;
    final bool? exactMatchName;
    final int? distance;

    factory Name.fromJson(Map<String, dynamic> json) => Name(
        value: json["value"] == null ? null : json["value"],
        closestNamedHex: json["closest_named_hex"] == null ? null : json["closest_named_hex"],
        exactMatchName: json["exact_match_name"] == null ? null : json["exact_match_name"],
        distance: json["distance"] == null ? null : json["distance"],
    );

    Map<String, dynamic> toJson() => {
        "value": value == null ? null : value,
        "closest_named_hex": closestNamedHex == null ? null : closestNamedHex,
        "exact_match_name": exactMatchName == null ? null : exactMatchName,
        "distance": distance == null ? null : distance,
    };
}

class Rgb {
    Rgb({
        this.fraction,
        this.r,
        this.g,
        this.b,
        this.value,
    });

    final RgbFraction? fraction;
    final int? r;
    final int? g;
    final int? b;
    final String? value;

    factory Rgb.fromJson(Map<String, dynamic> json) => Rgb(
        fraction: json["fraction"] == null ? null : RgbFraction.fromJson(json["fraction"]),
        r: json["r"] == null ? null : json["r"],
        g: json["g"] == null ? null : json["g"],
        b: json["b"] == null ? null : json["b"],
        value: json["value"] == null ? null : json["value"],
    );

    Map<String, dynamic> toJson() => {
        "fraction": fraction == null ? null : fraction!.toJson(),
        "r": r == null ? null : r,
        "g": g == null ? null : g,
        "b": b == null ? null : b,
        "value": value == null ? null : value,
    };
}

class RgbFraction {
    RgbFraction({
        this.r,
        this.g,
        this.b,
    });

    final double? r;
    final double? g;
    final double? b;

    factory RgbFraction.fromJson(Map<String, dynamic> json) => RgbFraction(
        r: json["r"] == null ? null : json["r"].toDouble(),
        g: json["g"] == null ? null : json["g"].toDouble(),
        b: json["b"] == null ? null : json["b"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "r": r == null ? null : r,
        "g": g == null ? null : g,
        "b": b == null ? null : b,
    };
}

class Xyz {
    Xyz({
        this.fraction,
        this.value,
        this.x,
        this.y,
        this.z,
    });

    final XyzFraction? fraction;
    final String? value;
    final int? x;
    final int? y;
    final int? z;

    factory Xyz.fromJson(Map<String, dynamic> json) => Xyz(
        fraction: json["fraction"] == null ? null : XyzFraction.fromJson(json["fraction"]),
        value: json["value"] == null ? null : json["value"],
        x: json["X"] == null ? null : json["X"],
        y: json["Y"] == null ? null : json["Y"],
        z: json["Z"] == null ? null : json["Z"],
    );

    Map<String, dynamic> toJson() => {
        "fraction": fraction == null ? null : fraction!.toJson(),
        "value": value == null ? null : value,
        "X": x == null ? null : x,
        "Y": y == null ? null : y,
        "Z": z == null ? null : z,
    };
}

class XyzFraction {
    XyzFraction({
        this.x,
        this.y,
        this.z,
    });

    final double? x;
    final double? y;
    final double? z;

    factory XyzFraction.fromJson(Map<String, dynamic> json) => XyzFraction(
        x: json["X"] == null ? null : json["X"].toDouble(),
        y: json["Y"] == null ? null : json["Y"].toDouble(),
        z: json["Z"] == null ? null : json["Z"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "X": x == null ? null : x,
        "Y": y == null ? null : y,
        "Z": z == null ? null : z,
    };
}
