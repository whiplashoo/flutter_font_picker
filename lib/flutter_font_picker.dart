library flutter_font_picker;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontPicker extends StatefulWidget {
  final List<String> googleFonts;
  final int recentsCount;
  final ValueChanged<PickerFont> onFontChanged;
  final String pickerFontSpec;

  const FontPicker(
      {Key? key,
      required this.googleFonts,
      this.recentsCount = 3,
      required this.onFontChanged,
      required this.pickerFontSpec})
      : super(key: key);

  @override
  _FontPickerState createState() => _FontPickerState();
}

class _FontPickerState extends State<FontPicker> {
  late PickerFont _currentFont;
  late List<PickerFont> _availableFonts;

  @override
  void initState() {
    super.initState();
    _currentFont = PickerFont.fromString(widget.pickerFontSpec);
    _availableFonts = widget.googleFonts
        .map((fontSpec) => PickerFont.fromString(fontSpec))
        .toList();
  }

  void changeFont(PickerFont selectedFont) {
    setState(() {
      _currentFont = selectedFont;
      widget.onFontChanged(selectedFont);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: 300.0,
            child: TextField(
              style: GoogleFonts.getFont(_currentFont.fontFamily),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'The quick brown fox jumped over the lazy dog'),
            )),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _availableFonts.map((googleFont) {
            return InkWell(
              onTap: () => changeFont(googleFont),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(googleFont.fontFamily,
                    style: GoogleFonts.getFont(googleFont.fontFamily).copyWith(
                        fontSize: 22.0,
                        fontWeight: googleFont.fontWeight,
                        fontStyle: googleFont.fontStyle)),
              ),
            );
          }).toList(),
        ))
      ],
    );
  }
}

class PickerFont {
  final String fontFamily;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  static const FONT_WEIGHT_VALUES = {
    "100": FontWeight.w100,
    "200": FontWeight.w200,
    "300": FontWeight.w300,
    "400": FontWeight.w400,
    "500": FontWeight.w500,
    "600": FontWeight.w600,
    "700": FontWeight.w700,
    "800": FontWeight.w800,
    "900": FontWeight.w900,
  };

  const PickerFont(
      {required this.fontFamily,
      this.fontWeight = FontWeight.w400,
      this.fontStyle = FontStyle.normal});

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
}
