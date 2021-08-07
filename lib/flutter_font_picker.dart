library flutter_font_picker;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontPicker extends StatefulWidget {
  final List<String> googleFonts;
  final int recentsCount;
  final ValueChanged<String> onFontChanged;
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
  late String _currentFont;

  @override
  void initState() {
    super.initState();
    _currentFont = widget.pickerFont;
  }

  void changeFont(String fontSpec) {
    setState(() {
      _currentFont = fontSpec;
      widget.onFontChanged(fontSpec);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: 300.0,
            child: TextField(
              style: GoogleFonts.getFont(_currentFont),
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'The quick brown fox jumped over the lazy dog'),
            )),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.googleFonts.map((googleFont) {
            return InkWell(
              onTap: () => changeFont(googleFont),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(googleFont,
                    style: GoogleFonts.getFont(googleFont)
                        .copyWith(fontSize: 22.0)),
              ),
            );
          }).toList(),
        ))
      ],
    );
  }
}
