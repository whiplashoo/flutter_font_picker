## 1.1.5

* Feat: Filter display languages according to the active list of supported fonts. This eliminates languages from the list which there are no fonts supporting fonts present.
* Feat: Implemented option favorites feature which can be enabled by setting `showFavoriteButtons` to true.
* Feat: The `example\main.dart` example program has been enhanced to include a control panel that allows all possible options to `FontPicker()` to be played with and adjusted.  It also now includes a `useDevicePreview` constant that can be set to true to enable previewing `FontPicker()`'s behavior on a wide variety of possible flutter platforms, screensizes and device orientations.
* Feat:  Added ability to set font sizes and list preview text.
    - `previewSampleTextFontSize` - Font size used for preview sample text above list.
    - `fontSizeForListPreview`: Font size to use for each font name within font picker list.  (Optional list preview sample text also uses this size). Defaults to 14 (previously hardcoded).
    - `showListPreviewSampleTextInput` - Set whether to include form field to allow user to change the list preview sample text.
    - `listPreviewSampleText` - Optional sample text include to right of each font within picker list.

## 1.1.3

* Fix: Protect null `googleFontsDetails[]` references within `picker_font.dart` when newer GoogleFonts than those used to generate the `constants.dart` are used. Fixes #9.

## 1.1.2

* Feat: Added `showFontVariants` option to hide font variants in the font picker. If set to false, user will only be able to select the default variant of each font. Closes #7.

## 1.1.1

* Feat: Added translations for Polish 🇵🇱. Thanks to @szymekTS for providing these!

## 1.1.0

* Fix: Setting the `googleFonts` parameter didn't have any effect. Fixes #6.

## 1.0.0

* Feat: Added the ability to set the language for the UI. Translations are available for 🇪🇸🇩🇪🇮🇹🇵🇹🇫🇷. Use the `lang` option when initializing `FontPicker`. Fixes #5.

## 0.4.0

* Fix: Issue with non-supported by Google Fonts initialFontFamily (closed #4).

## 0.4.0

* Fix: Update dependencies to be compatible with Flutter 3.

## 0.3.3

* Fix: Setting `initialFontFamily` now works (defaulted always to Roboto before).

## 0.3.2

* Fix: Font variants' text color is now set to derive from Theme's onPrimary color.

## 0.3.1

* Fix: Font categories' text color is now set to derive from Theme's onPrimary color (closes #1).

## 0.3.0

* Refactor implementation files in /src.
* Fix issue in example in iOS not rendering the FontPicker in the AlertDialog.
* Add library-level and API documentation. 

## 0.2.1

* Fix hardcoded color values for dark themes.

## 0.2.0

* Expose models and constants to callers.
* Rename fromFontSpec constructor.

## 0.1.1

* Fix formatting.

## 0.1.0

* First working version.

- TODO: Basic fonts option (to be included in assets).
- TODO: Filter languages according to selected fonts on initialization.
- TODO: Implement favorites feature.