import 'package:flutter/material.dart';

import '../constants/translations.dart';

class FontLanguage extends StatefulWidget {
  final ValueChanged<String?> onFontLanguageSelected;
  final String selectedFontLanguage;
  final List<String> languagesToDisplay;

  const FontLanguage({
    super.key,
    required this.languagesToDisplay,
    required this.selectedFontLanguage,
    required this.onFontLanguageSelected,
  });

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
        style: TextStyle(
          fontSize: 12.0,
          color: DefaultTextStyle.of(context).style.color,
        ),
        icon: const Icon(Icons.arrow_drop_down_sharp),
        onChanged: widget.onFontLanguageSelected,
        items: widget.languagesToDisplay
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(translations.d[value] ??
                value), // Provide language translation IF we have one,
            // otherwise the language subset as it is.
          );
        }).toList(),
      ),
    );
  }
}
