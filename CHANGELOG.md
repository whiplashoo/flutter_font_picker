## 2.0.0

* Updated to depend on google_fonts package v6.3.2. It now includes the latest supported Google Fonts, their variants, weights, and categories. 
* Bumped Dart SDK to 3.0.0.

## 1.4.0

* Added Japanese translations 🇯🇵. Thanks to @Npepperlinux for providing these!

## 1.3.0

* Added Dutch translations 🇳🇱. Thanks to @tkortekaas for providing these!
* Updated to depend on google_fonts package version ^5.0.0. It now includes the latest supported Google Fonts, their variants, weights, and categories. 
* Updated Dart SDK constraint to >=3.0.0 <4.0.0.

## 1.2.0

* Updated to depend on google_fonts package v4.0.3. It now includes the latest supported Google Fonts, their variants, weights, and categories. 

## 1.1.4

* Add `constants.dart` generator tool found in generator directory.  Addresses #11. Thanks to @timmaffett for providing this!

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