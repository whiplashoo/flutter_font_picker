import 'package:flutter/material.dart';
import '../constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class PickerFont {
  final String fontFamily;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  List<String> variants;
  List<String> subsets;
  String category;
  bool isRecent;

  PickerFont(
      {required this.fontFamily,
      this.fontWeight = FontWeight.w400,
      this.fontStyle = FontStyle.normal,
      this.isRecent = false})
      : variants = parseVariants(fontFamily),
        subsets = GOOGLE_FONTS[fontFamily]!["subsets"]!.split(","),
        category = GOOGLE_FONTS[fontFamily]!["category"]!;

  factory PickerFont.fromString(String fontSpec) {
    final fontSpecSplit = fontSpec.split(":");
    if (fontSpecSplit.length == 1) {
      return PickerFont(fontFamily: fontSpecSplit[0]);
    } else {
      return PickerFont(
          fontFamily: fontSpecSplit[0],
          fontWeight:
              FONT_WEIGHT_VALUES[fontSpecSplit[1].replaceAll("i", "")] ??
                  FontWeight.w400,
          fontStyle: fontSpecSplit[1].contains("i")
              ? FontStyle.italic
              : FontStyle.normal);
    }
  }

  static List<String> parseVariants(String fontFamily) {
    var variants = GOOGLE_FONTS[fontFamily]!["variants"]!.split(",");
    if (variants.any((v) => v.contains("i"))) {
      variants.add("italic");
    }
    variants.removeWhere((v) => v.endsWith("i"));
    return variants;
  }

  String toFontSpec() {
    String fontWeightString = this.fontWeight.toString();
    String fontSpec =
        "${this.fontFamily}:${fontWeightString.substring(fontWeightString.length - 3)}";
    return this.fontStyle == FontStyle.italic ? "${fontSpec}i" : fontSpec;
  }

  TextStyle toTextStyle() {
    return GoogleFonts.getFont(this.fontFamily,
        fontWeight: this.fontWeight, fontStyle: this.fontStyle);
  }
}