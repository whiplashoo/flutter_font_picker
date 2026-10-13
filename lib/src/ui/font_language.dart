import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../constants/translations.dart';
import '../models/font_picker_theme.dart';

class FontLanguage extends StatefulWidget {
  final ValueChanged<String?> onFontLanguageSelected;
  final String selectedFontLanguage;
  const FontLanguage({
    super.key,
    required this.selectedFontLanguage,
    required this.onFontLanguageSelected,
  });

  @override
  _FontLanguageState createState() => _FontLanguageState();
}

class _FontLanguageState extends State<FontLanguage> {
  @override
  Widget build(BuildContext context) {
    final theme = FontPickerTheme.of(context);

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: widget.selectedFontLanguage,
        isDense: true,
        style: theme.languageDropdownStyle,
        icon: const Icon(Icons.arrow_drop_down_sharp),
        onChanged: widget.onFontLanguageSelected,
        items:
            googleFontLanguages.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(translations.d[value]!),
          );
        }).toList(),
      ),
    );
  }
}
