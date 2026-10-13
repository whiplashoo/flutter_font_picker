import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Visual customization for [FontPicker] widgets.
///
/// Use as a [ThemeExtension] for app-wide defaults, and/or pass an instance to
/// [FontPicker.theme] to override for a single picker.
///
/// ```dart
/// ThemeData(
///   extensions: [
///     FontPickerTheme(
///       activeChipBackgroundColor: Colors.teal,
///       chipFontSize: 12,
///     ),
///   ],
/// )
/// ```
@immutable
class FontPickerTheme extends ThemeExtension<FontPickerTheme> {
  const FontPickerTheme({
    this.activeChipBackgroundColor,
    this.activeChipForegroundColor,
    this.inactiveChipForegroundColor,
    this.chipFontSize,
    this.chipHeight,
    this.fontListItemStyle,
    this.fontListItemInfoStyle,
    this.selectedTileColor,
    this.searchHintStyle,
    this.languageDropdownStyle,
    this.previewFontSize,
    this.emptyStateStyle,
    this.selectButtonStyle,
  });

  /// Background of selected category / variant chips.
  /// Defaults to [ColorScheme.primary].
  final Color? activeChipBackgroundColor;

  /// Foreground of selected category / variant chips.
  /// Defaults to [ColorScheme.onPrimary].
  final Color? activeChipForegroundColor;

  /// Foreground of unselected category / variant chips.
  /// Defaults to the ambient body text color.
  final Color? inactiveChipForegroundColor;

  /// Font size for category and variant chip labels. Defaults to `12`.
  final double? chipFontSize;

  /// Height of category and variant chips. Defaults to `32`.
  final double? chipHeight;

  /// Style for each font family name in the list (family is still applied
  /// from Google Fonts). Defaults to the ambient body style.
  final TextStyle? fontListItemStyle;

  /// Style for the category / variant count next to each font name.
  /// Defaults to italic grey at `11`.
  final TextStyle? fontListItemInfoStyle;

  /// Background of the currently selected font list tile.
  /// Defaults to [ThemeData.focusColor].
  final Color? selectedTileColor;

  /// Hint style for the search field. Defaults to size `14`.
  final TextStyle? searchHintStyle;

  /// Style for the language dropdown. Defaults to size `12`.
  final TextStyle? languageDropdownStyle;

  /// Font size for the live preview field. Defaults to the Google Font style.
  final double? previewFontSize;

  /// Style for the empty-results message.
  /// Defaults to [ThemeData.hintColor].
  final TextStyle? emptyStateStyle;

  /// Style for the trailing "Select" button.
  final ButtonStyle? selectButtonStyle;

  /// The effective theme for the nearest [FontPicker], with nulls filled from
  /// the ambient [Theme] / [ThemeExtension].
  static FontPickerTheme of(BuildContext context) {
    final local = FontPickerThemeScope.maybeOf(context);
    final extension = Theme.of(context).extension<FontPickerTheme>();
    return const FontPickerTheme()
        .merge(extension)
        .merge(local)
        .withDefaults(Theme.of(context));
  }

  /// Fills null fields from [theme] / built-in defaults matching prior hardcoding.
  FontPickerTheme withDefaults(ThemeData theme) {
    final bodyColor = theme.textTheme.bodyMedium?.color;

    return FontPickerTheme(
      activeChipBackgroundColor:
          activeChipBackgroundColor ?? theme.colorScheme.primary,
      activeChipForegroundColor:
          activeChipForegroundColor ?? theme.colorScheme.onPrimary,
      inactiveChipForegroundColor: inactiveChipForegroundColor ?? bodyColor,
      chipFontSize: chipFontSize ?? 12.0,
      chipHeight: chipHeight ?? 32.0,
      fontListItemStyle: TextStyle(color: bodyColor).merge(fontListItemStyle),
      fontListItemInfoStyle: TextStyle(
        fontStyle: FontStyle.italic,
        fontSize: 11.0,
        color: Colors.grey,
        fontFamily: theme.textTheme.bodyMedium?.fontFamily,
      ).merge(fontListItemInfoStyle),
      selectedTileColor: selectedTileColor ?? theme.focusColor,
      searchHintStyle: const TextStyle(fontSize: 14.0).merge(searchHintStyle),
      languageDropdownStyle: TextStyle(
        fontSize: 12.0,
        color: bodyColor,
      ).merge(languageDropdownStyle),
      previewFontSize: previewFontSize,
      emptyStateStyle: TextStyle(color: theme.hintColor).merge(emptyStateStyle),
      selectButtonStyle: selectButtonStyle,
    );
  }

  /// Prefers non-null fields from [other].
  FontPickerTheme merge(FontPickerTheme? other) {
    if (other == null) return this;

    return FontPickerTheme(
      activeChipBackgroundColor:
          other.activeChipBackgroundColor ?? activeChipBackgroundColor,
      activeChipForegroundColor:
          other.activeChipForegroundColor ?? activeChipForegroundColor,
      inactiveChipForegroundColor:
          other.inactiveChipForegroundColor ?? inactiveChipForegroundColor,
      chipFontSize: other.chipFontSize ?? chipFontSize,
      chipHeight: other.chipHeight ?? chipHeight,
      fontListItemStyle: fontListItemStyle?.merge(other.fontListItemStyle) ??
          other.fontListItemStyle,
      fontListItemInfoStyle:
          fontListItemInfoStyle?.merge(other.fontListItemInfoStyle) ??
              other.fontListItemInfoStyle,
      selectedTileColor: other.selectedTileColor ?? selectedTileColor,
      searchHintStyle:
          searchHintStyle?.merge(other.searchHintStyle) ?? other.searchHintStyle,
      languageDropdownStyle:
          languageDropdownStyle?.merge(other.languageDropdownStyle) ??
              other.languageDropdownStyle,
      previewFontSize: other.previewFontSize ?? previewFontSize,
      emptyStateStyle:
          emptyStateStyle?.merge(other.emptyStateStyle) ?? other.emptyStateStyle,
      selectButtonStyle: other.selectButtonStyle ?? selectButtonStyle,
    );
  }

  @override
  FontPickerTheme copyWith({
    Color? activeChipBackgroundColor,
    Color? activeChipForegroundColor,
    Color? inactiveChipForegroundColor,
    double? chipFontSize,
    double? chipHeight,
    TextStyle? fontListItemStyle,
    TextStyle? fontListItemInfoStyle,
    Color? selectedTileColor,
    TextStyle? searchHintStyle,
    TextStyle? languageDropdownStyle,
    double? previewFontSize,
    TextStyle? emptyStateStyle,
    ButtonStyle? selectButtonStyle,
  }) {
    return FontPickerTheme(
      activeChipBackgroundColor:
          activeChipBackgroundColor ?? this.activeChipBackgroundColor,
      activeChipForegroundColor:
          activeChipForegroundColor ?? this.activeChipForegroundColor,
      inactiveChipForegroundColor:
          inactiveChipForegroundColor ?? this.inactiveChipForegroundColor,
      chipFontSize: chipFontSize ?? this.chipFontSize,
      chipHeight: chipHeight ?? this.chipHeight,
      fontListItemStyle: fontListItemStyle ?? this.fontListItemStyle,
      fontListItemInfoStyle:
          fontListItemInfoStyle ?? this.fontListItemInfoStyle,
      selectedTileColor: selectedTileColor ?? this.selectedTileColor,
      searchHintStyle: searchHintStyle ?? this.searchHintStyle,
      languageDropdownStyle:
          languageDropdownStyle ?? this.languageDropdownStyle,
      previewFontSize: previewFontSize ?? this.previewFontSize,
      emptyStateStyle: emptyStateStyle ?? this.emptyStateStyle,
      selectButtonStyle: selectButtonStyle ?? this.selectButtonStyle,
    );
  }

  @override
  FontPickerTheme lerp(FontPickerTheme? other, double t) {
    if (other is! FontPickerTheme) return this;

    return FontPickerTheme(
      activeChipBackgroundColor:
          Color.lerp(activeChipBackgroundColor, other.activeChipBackgroundColor, t),
      activeChipForegroundColor:
          Color.lerp(activeChipForegroundColor, other.activeChipForegroundColor, t),
      inactiveChipForegroundColor: Color.lerp(
        inactiveChipForegroundColor,
        other.inactiveChipForegroundColor,
        t,
      ),
      chipFontSize: _lerpDouble(chipFontSize, other.chipFontSize, t),
      chipHeight: _lerpDouble(chipHeight, other.chipHeight, t),
      fontListItemStyle:
          TextStyle.lerp(fontListItemStyle, other.fontListItemStyle, t),
      fontListItemInfoStyle:
          TextStyle.lerp(fontListItemInfoStyle, other.fontListItemInfoStyle, t),
      selectedTileColor: Color.lerp(selectedTileColor, other.selectedTileColor, t),
      searchHintStyle: TextStyle.lerp(searchHintStyle, other.searchHintStyle, t),
      languageDropdownStyle:
          TextStyle.lerp(languageDropdownStyle, other.languageDropdownStyle, t),
      previewFontSize: _lerpDouble(previewFontSize, other.previewFontSize, t),
      emptyStateStyle: TextStyle.lerp(emptyStateStyle, other.emptyStateStyle, t),
      selectButtonStyle: t < 0.5 ? selectButtonStyle : other.selectButtonStyle,
    );
  }

  static double? _lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) return null;
    return lerpDouble(a ?? b!, b ?? a!, t);
  }
}

/// Provides a [FontPickerTheme] override to the picker subtree.
class FontPickerThemeScope extends InheritedWidget {
  const FontPickerThemeScope({
    super.key,
    required this.theme,
    required super.child,
  });

  final FontPickerTheme theme;

  static FontPickerTheme? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FontPickerThemeScope>()
        ?.theme;
  }

  @override
  bool updateShouldNotify(FontPickerThemeScope oldWidget) =>
      theme != oldWidget.theme;
}
