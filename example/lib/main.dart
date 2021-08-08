import 'package:flutter/material.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Font Picker Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MyHomePage(title: 'Font Picker Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FontPicker(
            onFontChanged: (font) => {
                  print(
                      "${font.fontFamily} with font weight ${font.fontWeight} and font style ${font.fontStyle}. FontSpec: ${font.toFontSpec()}")
                },
            pickerFont: 'Source Sans Pro',
            googleFonts: [
              "Abril Fatface",
              "Aclonica",
              "Alegreya Sans",
              "Architects Daughter",
              "Archivo",
              "Archivo Narrow",
              "Bebas Neue",
              "Bitter",
              "Bree Serif",
              "Bungee",
              "Cabin",
              "Cairo",
              "Coda",
              "Comfortaa",
              "Comic Neue",
              "Cousine",
              "Croissant One",
              "Faster One",
              "Forum",
              "Great Vibes",
              "Heebo",
              "Inconsolata",
              "Josefin Slab",
              "Lato",
              "Libre Baskerville",
              "Lobster",
              "Lora",
              "Merriweather",
              "Montserrat",
              "Mukta",
              "Nunito",
              "Offside",
              "Open Sans",
              "Oswald",
              "Overlock",
              "Pacifico",
              "Playfair Display",
              "Poppins",
              "Raleway",
              "Roboto",
              "Roboto Mono",
              "Source Sans Pro",
              "Space Mono",
              "Spicy Rice",
              "Squada One",
              "Sue Ellen Francisco",
              "Trade Winds",
              "Ubuntu",
              "Varela",
              "Vollkorn",
              "Work Sans",
              "Zilla Slab"
            ]),
      ),
    );
  }
}
