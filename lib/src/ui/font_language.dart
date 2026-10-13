import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../constants/translations.dart';
import '../models/font_picker_theme.dart';
import 'font_search.dart';

class FontLanguage extends StatelessWidget {
  final ValueChanged<String?> onFontLanguageSelected;
  final String selectedFontLanguage;

  /// Icon-only control that opens a menu — better for narrow layouts (dialogs).
  final bool compact;

  const FontLanguage({
    super.key,
    required this.selectedFontLanguage,
    required this.onFontLanguageSelected,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return compact ? _buildCompact(context) : _buildExpanded(context);
  }

  Widget _buildCompact(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isFiltered = selectedFontLanguage != 'all';

    return SizedBox(
      height: kFontPickerToolbarHeight,
      width: kFontPickerToolbarHeight,
      child: Material(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(12.0),
        child: PopupMenuButton<String>(
          tooltip: translations.d[selectedFontLanguage],
          padding: EdgeInsets.zero,
          initialValue: selectedFontLanguage,
          onSelected: onFontLanguageSelected,
          itemBuilder: (context) {
            return googleFontLanguages.map((value) {
              return CheckedPopupMenuItem<String>(
                value: value,
                checked: value == selectedFontLanguage,
                child: Text(translations.d[value]!),
              );
            }).toList();
          },
          child: Icon(
            Icons.language,
            size: 20.0,
            color: isFiltered
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildExpanded(BuildContext context) {
    final pickerTheme = FontPickerTheme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: kFontPickerToolbarHeight,
      child: Material(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedFontLanguage,
                isDense: true,
                borderRadius: BorderRadius.circular(12.0),
                style: pickerTheme.languageDropdownStyle?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 14.0,
                  height: 1.2,
                ),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: colorScheme.onSurfaceVariant,
                ),
                onChanged: onFontLanguageSelected,
                items: googleFontLanguages
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(translations.d[value]!),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
