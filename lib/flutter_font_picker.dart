library flutter_font_picker;

import 'package:flutter/material.dart';

import 'constants/constants.dart';
import 'models/picker_font.dart';
import 'ui/font_picker_content.dart';

//TODO: Basic fonts option (to be included in assets)
//TODO: Filter languages according to selected fonts on init
//TODO: Implement favorites/recents feature

class FontPicker extends StatefulWidget {
  final List<String> googleFonts;
  final ValueChanged<PickerFont> onFontChanged;
  final String initialFontFamily;
  final bool showFontInfo;
  final bool showInDialog;
  final int recentsCount;

  const FontPicker(
      {Key? key,
      this.googleFonts = GOOGLE_FONTS_LIST,
      this.showFontInfo = true,
      this.showInDialog = false,
      this.recentsCount = 3,
      required this.onFontChanged,
      this.initialFontFamily = 'Roboto'})
      : super(key: key);

  @override
  _FontPickerState createState() => _FontPickerState();
}

class _FontPickerState extends State<FontPicker> {
  @override
  Widget build(BuildContext context) {
    if (widget.showInDialog) {
      return FontPickerContent(
        onFontChanged: widget.onFontChanged,
        googleFonts: widget.googleFonts,
        showFontInfo: widget.showFontInfo,
        showInDialog: widget.showInDialog,
        recentsCount: widget.recentsCount,
        initialFontFamily: widget.initialFontFamily,
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text("Pick a font:"),
          ),
          body: FontPickerContent(
            onFontChanged: widget.onFontChanged,
            googleFonts: widget.googleFonts,
            showFontInfo: widget.showFontInfo,
            showInDialog: widget.showInDialog,
            recentsCount: widget.recentsCount,
            initialFontFamily: widget.initialFontFamily,
          ));
    }
  }
}
