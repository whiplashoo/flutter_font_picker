library flutter_font_picker;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants/constants.dart';

class FontPicker extends StatefulWidget {
  final List<String> googleFonts;
  final int recentsCount;
  final ValueChanged<PickerFont> onFontChanged;
  final String pickerFont;

  const FontPicker(
      {Key? key,
      required this.googleFonts,
      this.recentsCount = 3,
      required this.onFontChanged,
      required this.pickerFont})
      : super(key: key);

  @override
  _FontPickerState createState() => _FontPickerState();
}

class _FontPickerState extends State<FontPicker> {
  late PickerFont _currentFont;
  late List<PickerFont> _availableFonts;
  bool _choosingVariant = false;

  @override
  void initState() {
    super.initState();
    _currentFont = PickerFont(fontFamily: widget.pickerFont);
    _availableFonts = widget.googleFonts
        .map((fontFamily) => PickerFont(fontFamily: fontFamily))
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
            child: ListView.builder(
          itemCount: _availableFonts.length,
          itemBuilder: (context, index) {
            var f = _availableFonts[index];
            return ListTile(
              onTap: () {
                setState(() {
                  _choosingVariant = true;
                });
              },
              title: Text(f.fontFamily,
                  style: TextStyle(
                      fontFamily: GoogleFonts.getFont(f.fontFamily,
                              fontWeight: FontWeight.w400)
                          .fontFamily)),
              subtitle: _choosingVariant
                  ? Wrap(
                      children: f.variants
                          .where((element) => !element.contains("i"))
                          .map((variant) {
                      return SizedBox(
                        height: 25.0,
                        width: 60.0,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                textStyle: TextStyle(fontSize: 10.0),
                                shape: StadiumBorder()),
                            child: Text(variant),
                            onPressed: () {
                              print("VCVC");
                            },
                          ),
                        ),
                      );
                    }).toList())
                  : null,
              trailing: _choosingVariant
                  ? TextButton(
                      child: Text(
                        'SELECT',
                      ),
                      onPressed: () {
                        changeFont(f);
                      },
                    )
                  : null,
            );
          },
        ))
      ],
    );
  }
}

class PickerFont {
  final String fontFamily;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  List<String> variants;
  List<String> subsets;
  String category;
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

  PickerFont(
      {required this.fontFamily,
      this.fontWeight = FontWeight.w400,
      this.fontStyle = FontStyle.normal})
      : variants = fontsList[fontFamily]!["variants"]!.split(","),
        subsets = fontsList[fontFamily]!["subsets"]!.split(","),
        category = fontsList[fontFamily]!["category"]!;

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

  static String toFontSpec(PickerFont pickerFont) {
    String fontSpec = "${pickerFont.fontFamily}:${pickerFont.fontWeight}";
    return pickerFont.fontStyle == FontStyle.italic ? "${fontSpec}i" : fontSpec;
  }
}
