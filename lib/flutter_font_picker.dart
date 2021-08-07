library flutter_font_picker;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontPicker extends StatefulWidget {
  final List<String> googleFonts;
  final int recentsCount;

  const FontPicker({Key? key, required this.googleFonts, this.recentsCount = 3})
      : super(key: key);

  @override
  _FontPickerState createState() => _FontPickerState();
}

class _FontPickerState extends State<FontPicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.googleFonts.map((googleFont) {
        return Text("The quick brown fox jumped over the lazy dog",
            style: GoogleFonts.getFont(googleFont));
      }).toList(),
    );
  }
}
