import 'package:flutter/material.dart';

import '../constants/translations.dart';
import '../models/font_picker_theme.dart';

/// Shared height for the search field and language dropdown row.
const double kFontPickerToolbarHeight = 40.0;

class FontSearch extends StatefulWidget {
  final ValueChanged<String> onSearchTextChanged;
  const FontSearch({super.key, required this.onSearchTextChanged});

  @override
  _FontSearchState createState() => _FontSearchState();
}

class _FontSearchState extends State<FontSearch> {
  bool _isSearchFocused = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pickerTheme = FontPickerTheme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: kFontPickerToolbarHeight,
      child: Focus(
        onFocusChange: (focus) {
          setState(() {
            _isSearchFocused = focus;
          });
        },
        child: TextField(
          controller: searchController,
          style: pickerTheme.searchHintStyle?.copyWith(
            color: colorScheme.onSurface,
            fontSize: 14.0,
            height: 1.2,
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor:
                colorScheme.surfaceContainerHighest.withValues(alpha: 0.65),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 36.0,
              minHeight: kFontPickerToolbarHeight,
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 36.0,
              minHeight: kFontPickerToolbarHeight,
            ),
            prefixIcon: Icon(
              Icons.search,
              size: 20.0,
              color: colorScheme.onSurfaceVariant,
            ),
            suffixIcon: _isSearchFocused || searchController.text.isNotEmpty
                ? IconButton(
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.cancel,
                      size: 18.0,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      searchController.clear();
                      widget.onSearchTextChanged('');
                      setState(() {});
                    },
                  )
                : null,
            hintText: translations.d["search"],
            hintStyle: pickerTheme.searchHintStyle?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 14.0,
              height: 1.2,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: colorScheme.primary.withValues(alpha: 0.4),
              ),
            ),
          ),
          onChanged: (value) {
            setState(() {});
            widget.onSearchTextChanged(value);
          },
        ),
      ),
    );
  }
}
