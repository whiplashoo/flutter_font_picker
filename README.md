# flutter_font_picker

## A custom Flutter widget that lets the user select a Google Font from a custom dropdown.

<p align="center">
  <img width="40%" src="https://user-images.githubusercontent.com/9117427/129081030-19a7df71-77d3-403e-89e9-8ad139b74540.jpg"/>
  &nbsp;&nbsp;&nbsp;
  <img width="40%" src="https://user-images.githubusercontent.com/9117427/129081023-67b0eb01-4bb1-47a2-b252-3a31536f8bb2.jpg"/>
</p>

Provides a `FontPicker` widget that can be used in a route or dialog as a UI for choosing a font from Google Fonts. Depends on the [google_fonts](https://pub.dev/packages/google_fonts) package for loading and displaying the fonts.

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




