# flutter_font_picker [![Pub Version](https://img.shields.io/pub/v/flutter_font_picker?label=flutter_font_picker&labelColor=333940&logo=dart)](https://pub.dev/packages/flutter_font_picker)

## A Flutter widget that lets the user select and apply a Google Font from a custom dropdown.


<p align="center">
<img width="40%" src="https://user-images.githubusercontent.com/9117427/129091647-549ab203-501b-4654-9d1c-da74f494cb07.gif"/>
</p>

Provides a `FontPicker` widget that can be used in a route or dialog as a UI for choosing a font from Google Fonts.

Depends on the [google_fonts](https://pub.dev/packages/google_fonts) package for loading and displaying the fonts.

Localizations available for 🇪🇸🇩🇪🇮🇹🇵🇹🇫🇷🇵🇱🇳🇱🇯🇵. 

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

Check the example project for more usages (route, dialog, and themed pickers).

<p align="center">
  <img width="40%" src="https://github.com/user-attachments/assets/77804f9d-cb4b-44f6-b6c7-8615ff62506d"/>
  &nbsp;&nbsp;&nbsp;
  <img width="40%" src="https://github.com/user-attachments/assets/af8bd747-da85-40af-8a10-c2442546d524"/>
  <img width="40%" src="https://github.com/user-attachments/assets/6cda01f3-4135-4f37-9e4b-f0ab0f4f8034"/>
  &nbsp;&nbsp;&nbsp;
  <img width="40%" src="https://github.com/user-attachments/assets/193f4d79-4670-472a-988c-9dfa0a996a92"/>
</p>

## FontPicker settings

- `onFontChanged`: (required) the callback that returns a PickerFont object with all the details and methods for the user's selected font.
- `googleFonts`: A list of Google fonts to use in the font picker. By default it contains all fonts included in `constants.dart` (~1453). **You should only use a limited number of them for performance and data saving**, as each font is downloaded and stored to the app's storage when it comes into view. Using up to 100-200 fonts should work fine.
- `initialFontFamily`: The font family to use initially in the font picker. Defaults to 'Roboto'.
- `showFontInfo`: Whether to show font details (category, number of variants) next to each font tile in the list.
- `showFontVariants`: Whether to show font variants (weights and styles) in the font picker. If set to false, user will only be able to select the default variant of each font.
- `showInDialog`: Set this to true if you want to use the font picker inside an AlertDialog (check examples).
- `recentsCount`: Fonts that the user selected before are saved to be shown at the start of the list. Sets how many you want saved as recents.
- `lang`: The language in which to show the UI. Defaults to English (`'en'`). Other options are 🇪🇸🇩🇪🇮🇹🇵🇹🇫🇷🇵🇱🇳🇱🇯🇵 (`'es'`, `'de'`, `'it'`, `'pt'`, `'fr'`, `'pl'`, `'nl'`, `'ja'`). If you need a translation in another language: take a look at the `dictionary` variable in `translations.dart`, and send me (or fix) the translations for your language.
- `theme`: Optional `FontPickerTheme` overrides for this picker (see below).

## Theming (`FontPickerTheme`)

Customize colors and text styles via `FontPickerTheme`, a `ThemeExtension`. Pass it to a single picker, or register it on your app `ThemeData` for defaults everywhere.

**Per picker:**

```dart
FontPicker(
  theme: FontPickerTheme(
    activeChipBackgroundColor: Colors.teal,
    chipFontSize: 12,
    previewFontSize: 18,
  ),
  onFontChanged: (font) { /* ... */ },
)
```

**App-wide:**

```dart
ThemeData(
  extensions: [
    FontPickerTheme(
      activeChipBackgroundColor: Colors.teal,
      fontListItemInfoStyle: TextStyle(fontSize: 12, color: Colors.blueGrey),
    ),
  ],
)
```

Resolution order: `FontPicker.theme` → `ThemeData.extensions` → Material theme defaults.

Notable fields: `activeChipBackgroundColor`, `activeChipForegroundColor`, `inactiveChipForegroundColor`, `chipFontSize`, `fontListItemStyle`, `fontListItemInfoStyle`, `selectedTileColor`, `searchHintStyle`, `languageDropdownStyle`, `previewFontSize`, `emptyStateStyle`, `selectButtonStyle`.

## FontPicker features

The user can:

- Browse a list of any Google fonts you want.
- Select a variant (font weight and/or style) for each font.
- Filter the fonts by category (serif, sans-serif, handwriting, etc.) or available font glyphs (Latin, Greek, Cyrillic, etc.). Filters can be combined with search.
- Search the fonts by name.
- See the most recently used fonts at the top of the list.

### Credits

Inspired by the [FontPicker jQuery plugin](https://github.com/av01d/fontpicker-jquery-plugin).
