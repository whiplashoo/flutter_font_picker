library flutter_font_picker;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants/constants.dart';

class FontPicker extends StatefulWidget {
  final List<String> googleFonts;
  final int recentCount;
  final ValueChanged<PickerFont> onFontChanged;
  final String pickerFont;

  const FontPicker(
      {Key? key,
      required this.googleFonts,
      this.recentCount = 3,
      required this.onFontChanged,
      required this.pickerFont})
      : super(key: key);

  @override
  _FontPickerState createState() => _FontPickerState();
}

class _FontPickerState extends State<FontPicker> {
  late List<PickerFont> _availableFonts;
  late String _fontFamilySelected = "";
  FontWeight _fontWeightSelected = FontWeight.w400;
  FontStyle _fontStyleSelected = FontStyle.normal;

  @override
  void initState() {
    super.initState();
    _fontFamilySelected = widget.pickerFont;
    _availableFonts = widget.googleFonts
        .map((fontFamily) => PickerFont(fontFamily: fontFamily))
        .toList();
  }

  void changeFont(PickerFont selectedFont) {
    setState(() {
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
              style: GoogleFonts.getFont(_fontFamilySelected,
                  fontWeight: _fontWeightSelected,
                  fontStyle: _fontStyleSelected),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'The quick brown fox jumped over the lazy dog',
                  hintStyle: TextStyle(
                      fontStyle: _fontStyleSelected,
                      fontWeight: _fontWeightSelected)),
            )),
        Expanded(
            child: ListView.builder(
          itemCount: _availableFonts.length,
          itemBuilder: (context, index) {
            var f = _availableFonts[index];
            bool isBeingSelected = _fontFamilySelected == f.fontFamily;
            return ListTile(
              selected: isBeingSelected,
              selectedTileColor: Theme.of(context).focusColor,
              onTap: () {
                setState(() {
                  _fontFamilySelected = f.fontFamily;
                  _fontWeightSelected = FontWeight.w400;
                  _fontStyleSelected = FontStyle.normal;
                });
              },
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(f.fontFamily,
                    style: TextStyle(
                        fontFamily:
                            GoogleFonts.getFont(f.fontFamily).fontFamily)),
              ),
              subtitle: isBeingSelected
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Wrap(
                          children: f.variants.map((variant) {
                        bool isSelectedVariant;
                        if (variant == "italic" &&
                            _fontStyleSelected == FontStyle.italic) {
                          isSelectedVariant = true;
                        } else {
                          isSelectedVariant =
                              _fontWeightSelected.toString().contains(variant);
                        }
                        return SizedBox(
                          height: 30.0,
                          width: 60.0,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: isSelectedVariant
                                      ? Theme.of(context).primaryColor
                                      : null,
                                  textStyle: TextStyle(
                                    fontSize: 10.0,
                                  ),
                                  shape: StadiumBorder()),
                              child: Text(
                                variant,
                                style: TextStyle(
                                    fontStyle: variant == "italic"
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                    color: isSelectedVariant
                                        ? Colors.white
                                        : null),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (variant == "italic") {
                                    _fontStyleSelected == FontStyle.italic
                                        ? _fontStyleSelected = FontStyle.normal
                                        : _fontStyleSelected = FontStyle.italic;
                                  } else {
                                    _fontWeightSelected =
                                        FONT_WEIGHT_VALUES[variant]!;
                                  }
                                });
                              },
                            ),
                          ),
                        );
                      }).toList()),
                    )
                  : null,
              trailing: isBeingSelected
                  ? TextButton(
                      child: Text(
                        'SELECT',
                      ),
                      onPressed: () {
                        changeFont(PickerFont(
                            fontFamily: _fontFamilySelected,
                            fontWeight: _fontWeightSelected,
                            fontStyle: _fontStyleSelected));
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

  PickerFont(
      {required this.fontFamily,
      this.fontWeight = FontWeight.w400,
      this.fontStyle = FontStyle.normal})
      : variants = parseVariants(fontFamily),
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

  static List<String> parseVariants(String fontFamily) {
    var variants = fontsList[fontFamily]!["variants"]!.split(",");
    if (variants.any((v) => v.contains("i"))) {
      variants.add("italic");
    }
    variants.removeWhere((v) => v.endsWith("i"));
    return variants;
  }

  static String toFontSpec(PickerFont pickerFont) {
    String fontSpec = "${pickerFont.fontFamily}:${pickerFont.fontWeight}";
    return pickerFont.fontStyle == FontStyle.italic ? "${fontSpec}i" : fontSpec;
  }
}
