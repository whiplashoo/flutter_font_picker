import 'package:flutter/material.dart';
import 'package:flutter_font_picker/src/constants/translations.dart';

import '../constants/constants.dart';
import '../models/font_picker_theme.dart';

class FontCategories extends StatefulWidget {
  final ValueChanged<List<String>> onFontCategoriesUpdated;
  const FontCategories({super.key, required this.onFontCategoriesUpdated});

  @override
  _FontCategoriesState createState() => _FontCategoriesState();
}

class _FontCategoriesState extends State<FontCategories> {
  /// Empty means no category filter (show all). Selecting chips narrows to those categories.
  final List<String> _selectedFontCategories = [];

  @override
  Widget build(BuildContext context) {
    final theme = FontPickerTheme.of(context);

    return Wrap(
      children: googleFontCategories.map((fontCategory) {
        bool isSelectedCategory =
            _selectedFontCategories.contains(fontCategory);

        return SizedBox(
          height: theme.chipHeight,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: isSelectedCategory
                    ? theme.activeChipBackgroundColor
                    : null,
                textStyle: TextStyle(
                  fontSize: theme.chipFontSize,
                ),
                shape: const StadiumBorder(),
              ),
              child: Text(
                translations.d[fontCategory]!,
                style: TextStyle(
                  color: isSelectedCategory
                      ? theme.activeChipForegroundColor
                      : theme.inactiveChipForegroundColor,
                ),
              ),
              onPressed: () {
                setState(() {
                  if (_selectedFontCategories.contains(fontCategory)) {
                    _selectedFontCategories.remove(fontCategory);
                  } else {
                    _selectedFontCategories.add(fontCategory);
                  }
                });
                widget.onFontCategoriesUpdated(
                  List.from(_selectedFontCategories),
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}
