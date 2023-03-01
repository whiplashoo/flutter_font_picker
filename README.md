# flutter_font_picker [![Pub Version](https://img.shields.io/pub/v/flutter_font_picker?label=flutter_font_picker&labelColor=333940&logo=dart)](https://pub.dev/packages/flutter_font_picker)

## A Flutter widget that lets the user select and apply a Google Font from a custom dropdown.


<p align="center">
<img width="40%" src="https://user-images.githubusercontent.com/9117427/129091647-549ab203-501b-4654-9d1c-da74f494cb07.gif"/>
</p>

Provides a `FontPicker` widget that can be used in a route or dialog as a UI for choosing a font from Google Fonts.

Depends on the [google_fonts](https://pub.dev/packages/google_fonts) package for loading and displaying the fonts.

A 'live' example of the `FontPicker` `example\main.dart` example program, running on the web platform (with additional device preview capabilities enabled) can be found [here](https://timmaffett.github.io/flutter_font_picker/).

Localizations available for 🇪🇸🇩🇪🇮🇹🇵🇹🇫🇷🇵🇱. 

## Simple Example

Inside your build method, use a button that when pressed, will navigate to the font picker screen:

```dart
PickerFont? _selectedFont;

ElevatedButton(
  child: Text('Pick a font'),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FontPicker(
              onFontChanged: (PickerFont font) {
                _selectedFont = font;
                print("${font.fontFamily} with font weight ${font.fontWeight} and font style ${font.fontStyle}.}");
              },
          ),
      ),
    );
  }),
```

The `onFontChanged` function retrieves the font that the user selects with an object containing details like the font's name, weight, style, etc. 

**You can then use its `toTextStyle()` method to style any text with the selected font:**

```dart
Text('This will be styled with the font: $_selectedFont.fontFamily',
      style: selectedFont.toTextStyle()),
```

Check the example project for more usages.

<p align="center">
  <img width="40%" src="https://user-images.githubusercontent.com/9117427/129081030-19a7df71-77d3-403e-89e9-8ad139b74540.jpg"/>
  &nbsp;&nbsp;&nbsp;
  <img width="40%" src="https://user-images.githubusercontent.com/9117427/129081023-67b0eb01-4bb1-47a2-b252-3a31536f8bb2.jpg"/>
</p>

## FontPicker settings

- `onFontChanged`: (required) the callback that returns a PickerFont object with all the details and methods for the user's selected font.
- `googleFonts`: A list of Google fonts to use in the font picker. By default it contains all 975 fonts included in constants.dart. **You should only use a limited number of them for performance and data saving**, as each font is downloaded and stored to the app's storage when it comes into view. Using up to 100-200 fonts should work fine.
- `initialFontFamily`: The font family to use initially in the font picker. Defaults to 'Roboto'.
- `showFontInfo`: Whether to show font details (category, number of variants) next to each font tile in the list.
- `showFontVariants`: Whether to show font variants (weights and styles) in the font picker. If set to false, user will only be able to select the default variant of each font.
- `showInDialog`: Set this to true if you want to use the font picker inside an AlertDialog (check examples).
- `recentsCount`: Fonts that the user selected before are saved to be shown at the start of the list. Sets how many you want saved as recents.
- `showFavoriteButtons`: Whether or not to add a 'favorites' star to each font in the picker list and allow the user to selected favorites that will be saved and displayed at the top of the picker list after the most recent selections and before the rest of the fonts.
- `favoritesCount`: Sets the maximum number of user picked favorites to allow and save in the users preferences.
- `previewSampleTextFontSize` - Font size used for preview sample text above list.
- `fontSizeForListPreview`: Font size to use for each font name within font picker list.  (Optional list preview sample text also uses this size). Defaults to 14.
- `showListPreviewSampleTextInput` - Set whether to include form field to allow user to change the list preview sample text.
- `listPreviewSampleText` - Optional sample text include to right of each font within picker list. Defaults to 16.
- `'lang'`: The language in which to show the UI. Defaults to English (`'en'`). Other options are 🇪🇸🇩🇪🇮🇹🇵🇹🇫🇷🇵🇱 (`'es'`, `'de'`, `'it'`, `'pt'`, `'fr', 'pl'`). If you need a translation in another language: take a look at the `dictionary` variable in `translations.dart`, and send me (or fix) the translations for your language . 

## FontPicker features

The user can:

- Browse a list of any Google fonts you want.
- Select a variant (font weight and/or style) for each font.
- Filter the fonts by category (serif, sans-serif, handwriting, etc.) or available font glyphs (Latin, Greek, Cyrillic, etc.).
- Search the fonts by name.
- See the most recently used fonts at the top of the list.

### Credits

Inspired by the [FontPicker jQuery plugin](https://github.com/av01d/fontpicker-jquery-plugin).
