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