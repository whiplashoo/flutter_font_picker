import 'package:flutter/material.dart';
import 'package:flutter_font_picker/src/constants/translations.dart';

import '../constants/constants.dart';
import '../models/font_picker_theme.dart';

class FontCategories extends StatefulWidget {
  final ValueChanged<List<String>> onFontCategoriesUpdated;

  /// Keep chips on one horizontally scrollable row (better in dialogs).
  final bool scrollable;

  const FontCategories({
    super.key,
    required this.onFontCategoriesUpdated,
    this.scrollable = false,
  });

  @override
  _FontCategoriesState createState() => _FontCategoriesState();
}

class _FontCategoriesState extends State<FontCategories> {
  /// Empty means no category filter (show all). Selecting chips narrows to those categories.
  final List<String> _selectedFontCategories = [];

  @override
  Widget build(BuildContext context) {
    final pickerTheme = FontPickerTheme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final chips = googleFontCategories.map((fontCategory) {
      final isSelected = _selectedFontCategories.contains(fontCategory);

      return FilterChip(
        label: Text(translations.d[fontCategory]!),
        selected: isSelected,
        showCheckmark: false,
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        labelStyle: TextStyle(
          fontSize: pickerTheme.chipFontSize,
          color: isSelected
              ? pickerTheme.activeChipForegroundColor
              : pickerTheme.inactiveChipForegroundColor,
        ),
        selectedColor: pickerTheme.activeChipBackgroundColor,
        backgroundColor: colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.4,
        ),
        side: BorderSide(
          color: isSelected
              ? pickerTheme.activeChipBackgroundColor!
              : colorScheme.outlineVariant,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        onSelected: (selected) {
          setState(() {
            if (selected) {
              _selectedFontCategories.add(fontCategory);
            } else {
              _selectedFontCategories.remove(fontCategory);
            }
          });
          widget.onFontCategoriesUpdated(
            List.from(_selectedFontCategories),
          );
        },
      );
    }).toList();

    if (widget.scrollable) {
      return SizedBox(
        height: 36.0,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: chips.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8.0),
          itemBuilder: (context, index) => chips[index],
        ),
      );
    }

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: chips,
    );
  }
}
