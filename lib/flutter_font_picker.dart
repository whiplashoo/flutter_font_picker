/// A Flutter widget that lets the user select and apply a Google Font from a custom dropdown.
///
/// Provides a `FontPicker` widget that can be used in a route or dialog as a UI for choosing a font from Google Fonts.
///
/// ## Simple Example
/// Inside your build method, use a button that when pressed, will navigate to the font picker screen:
///
/// ```dart
/// PickerFont? _selectedFont;
///
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
/// The `onFontChanged` function retrieves the font that the user selects with an object containing details like the font's name, weight, style, etc.
///
/// **You can then use its `toTextStyle()` method to style any text with the selected font:**
///
/// ```dart
/// Text('This will be styled with the font: $_selectedFont.fontFamily',
///       style: selectedFont.toTextStyle()),
/// ```
library flutter_font_picker;

export 'package:flutter_font_picker/src/models/picker_font.dart';
export 'package:flutter_font_picker/src/ui/font_picker.dart';
