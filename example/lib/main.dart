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
            onFontChanged: (font) => {print(font)},
            pickerFont: 'Source Sans Pro',
            googleFonts:
                'Alegreya,Boogaloo,Coiny,Dosis,Emilys Candy,Faster One,Lato'
                    .split(',')),
      ),
    );
  }
}
