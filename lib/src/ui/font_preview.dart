import 'package:flutter/material.dart';
import 'package:flutter_font_picker/src/constants/translations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/font_picker_theme.dart';

class FontPreview extends StatelessWidget {
  final String fontFamily;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  const FontPreview({
    super.key,
    required this.fontFamily,
    required this.fontWeight,
    required this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = FontPickerTheme.of(context);
    final previewStyle = GoogleFonts.getFont(
      fontFamily,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: theme.previewFontSize,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        textAlign: TextAlign.center,
        style: previewStyle,
        decoration: InputDecoration(
          hintText: translations.d['sampleText'],
          hintStyle: TextStyle(
            fontSize: theme.previewFontSize ?? 14.0,
            fontStyle: fontStyle,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
