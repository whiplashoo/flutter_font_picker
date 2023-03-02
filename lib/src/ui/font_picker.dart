library flutter_font_picker;

import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../constants/translations.dart';
import '../models/picker_font.dart';
import 'font_picker_ui.dart';

//TODO: Basic fonts option (to be included in assets)

/// Creates a widget that lets the user select a Google font from a provided list.
///
/// Inside your [build] method, use a button that when pressed, will navigate to the font picker screen:
///
/// ```dart
/// PickerFont? _selectedFont;
/// ElevatedButton(
///   child: Text('Pick a font'),
///   onPressed: () {
///     Navigator.push(
///       context,
///       MaterialPageRoute(
///           builder: (context) => FontPicker(
///               onFontChanged: (PickerFont font) {
///                 _selectedFont = font;
///                 print("${font.fontFamily} with font weight ${font.fontWeight} and font style ${font.fontStyle}.}");
///               },
///           ),
///       ),
///     );
///   }),
/// ```
///
///  The [onFontChanged] function retrieves the font that the user selects with an object containing details like the font's name, weight, style, etc.
///
/// You can then use its [toTextStyle] method to style any text with the selected font:
///
/// ```dart
/// Text('This will be styled with the font: $_selectedFont.fontFamily',
///      style: selectedFont.toTextStyle()),
/// ```
///
/// Use the [showInDialog] property to set if it will be shown in a dialog or in its own separate route.
class FontPicker extends StatefulWidget {
  /// The Google fonts that may be selected from the font picker. Check the [googleFontsList] constant for a list of the 975 fonts available.
  ///
  /// * Note that a large number of fonts can degrade the performance of the widget, as each font is downloaded and applied as a preview in the font picker.
  final List<String> googleFonts;

  /// The callback that returns a [PickerFont] object with all the details and methods for the font that the user selected.
  final ValueChanged<PickerFont> onFontChanged;

  /// The font family to use initially in the font picker. Defaults to 'Roboto'.
  final String? initialFontFamily;

  /// Set whether to show font details (category, number of variants) next to each font tile in the list.
  final bool showFontInfo;

  /// Set whether to show font variants (weights and styles) in the font picker. If set to false, user will only be able to select the default variant of each font.
  final bool showFontVariants;

  /// Set to true if the font picker will be used in an [AlertDialog] (check examples for usage).
  final bool showInDialog;

  /// Set to true to add 'favorite' button to each font in font list.  Favorites will be shown at top of list after recent fonts and before other fonts.
  /// The users favorite font list is saved in [SharedPreferences]. [favoritesCount] sets the
  /// maximum number of favorite fonts the user will be allowed to choose.
  final bool showFavoriteButtons;

  /// Maximum number of user picked favorites to allow and saved in [SharedPreferences].
  final int favoritesCount;

  /// Fonts that the user selected before can be saved in [SharedPreferences] and shown at the start of the list. Sets how many you want saved as recents.
  final int recentsCount;

  /// The language in which to show the UI. Defaults to English.
  ///
  /// If you need a translation in another language: take a look at the dictionaries variable in constants.dart, and send me the translations for your language.
  final String lang;

  /// Set whether to include form field to allow user to change the list preview sample text.
  final bool showListPreviewSampleTextInput;

  /// Optional sample text include to right of each font within picker list.
  final String? listPreviewSampleText;

  /// Font size to use for each font name within font picker list.  (Optional list preview sample text also uses this size).
  final double fontSizeForListPreview;

  /// Font size used for preview sample text above list.
  final double previewSampleTextFontSize;

  /// Creates a widget that lets the user select a Google font from a provided list.
  ///
  /// The [onFontChanged] function retrieves the font that the user selects with an object containing details like the font's name, weight, style, etc.
  ///
  /// You can then use its [toTextStyle] method to style any text with the selected font.
  const FontPicker({
    super.key,
    this.googleFonts = googleFontsList,
    this.showFontInfo = true,
    this.showFontVariants = true,
    this.showInDialog = false,
    this.recentsCount = 3,
    this.showFavoriteButtons = false,
    this.favoritesCount = 15,
    required this.onFontChanged,
    this.initialFontFamily,
    this.lang = "en",
    this.showListPreviewSampleTextInput = false,
    this.listPreviewSampleText,
    this.fontSizeForListPreview = 16.0,
    this.previewSampleTextFontSize = 14.0,
  });

  @override
  _FontPickerState createState() => _FontPickerState();
}

class _FontPickerState extends State<FontPicker> {
  @override
  void initState() {
    super.initState();
    translations.language = widget.lang;
  }

  @override
  Widget build(BuildContext context) {
    return widget.showInDialog
        ? FontPickerUI(
            onFontChanged: widget.onFontChanged,
            googleFonts: widget.googleFonts,
            showFontInfo: widget.showFontInfo,
            showInDialog: widget.showInDialog,
            recentsCount: widget.recentsCount,
            initialFontFamily: widget.initialFontFamily ?? 'Roboto',
            lang: widget.lang,
            showFontVariants: widget.showFontVariants,
            showListPreviewSampleTextInput:
                widget.showListPreviewSampleTextInput,
            listPreviewSampleText: widget.listPreviewSampleText,
            fontSizeForListPreview: widget.fontSizeForListPreview,
            previewSampleTextFontSize: widget.previewSampleTextFontSize,
            showFavoriteButtons: widget.showFavoriteButtons,
            favoritesCount: widget.favoritesCount,
          )
        : Scaffold(
            appBar: AppBar(title: const Text("Pick a font:")),
            body: FontPickerUI(
              onFontChanged: widget.onFontChanged,
              googleFonts: widget.googleFonts,
              showFontInfo: widget.showFontInfo,
              showInDialog: widget.showInDialog,
              recentsCount: widget.recentsCount,
              initialFontFamily: widget.initialFontFamily ?? 'Roboto',
              lang: widget.lang,
              showFontVariants: widget.showFontVariants,
              showListPreviewSampleTextInput:
                  widget.showListPreviewSampleTextInput,
              listPreviewSampleText: widget.listPreviewSampleText,
              fontSizeForListPreview: widget.fontSizeForListPreview,
              previewSampleTextFontSize: widget.previewSampleTextFontSize,
              showFavoriteButtons: widget.showFavoriteButtons,
              favoritesCount: widget.favoritesCount,
            ),
          );
  }
}
