import 'package:flutter/material.dart';
import 'package:flutter_font_picker/constants/constants.dart';

class FontLanguage extends StatefulWidget {
  final ValueChanged<String?> onFontLanguageSelected;
  final String selectedFontLanguage;
  const FontLanguage(
      {Key? key,
      required this.selectedFontLanguage,
      required this.onFontLanguageSelected})
      : super(key: key);

  @override
  _FontLanguageState createState() => _FontLanguageState();
}

class _FontLanguageState extends State<FontLanguage> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: widget.selectedFontLanguage,
        isDense: true,
        style: TextStyle(fontSize: 12.0),
        icon: const Icon(Icons.arrow_drop_down_sharp),
        onChanged: widget.onFontLanguageSelected,
        items: GOOGLE_FONT_LANGS.keys
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(GOOGLE_FONT_LANGS[value]!),
          );
        }).toList(),
      ),
    );
  }
}
