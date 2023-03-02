import 'package:flutter/material.dart';
import 'package:flutter_font_picker/src/constants/translations.dart';
import 'package:google_fonts/google_fonts.dart';

class FontPreview extends StatelessWidget {
  final String fontFamily;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final double fontSize;
  const FontPreview({
    super.key,
    required this.fontFamily,
    required this.fontWeight,
    required this.fontStyle,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        textAlign: TextAlign.center,
        style: GoogleFonts.getFont(
          fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
        ),
        decoration: InputDecoration(
          hintText: translations.d['sampleText'],
          hintStyle: TextStyle(
            fontSize: fontSize,
            fontStyle: fontStyle,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
