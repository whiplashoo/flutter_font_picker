// This program is for capturing a list of the fonts included in the googlefonts package specified within
// the root pubspec.yaml FOR THE PURPOSES of generator/update_constants.dart
// The list of fonts is copied from this running program's text edit box and then saved into
// a file within the generator directory.  The file is then passed to the generator using a
// command line argument.   See generator/readme.md for more info.
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Display List Of Fonts in PubSpec version of GoogleFonts package',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'Display List Of Fonts in PubSpec version of GoogleFonts package'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum FontListType { subset, complete }
class _MyHomePageState extends State<MyHomePage> {
  final List<String> _completeGoogleFonts = GoogleFonts.asMap().keys.toList();

  late final String _textOfGoogleFontsList;

  @override
  initState() {
    super.initState();
    _textOfGoogleFontsList = _completeGoogleFonts.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Current GoogleFonts Package Font List')),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView( child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SelectableText
            SelectableText(
              _textOfGoogleFontsList,
              style: TextStyle(fontSize: 10),
            ),
            const SizedBox(
              height: 30,
            ),
            const TextField(
              minLines: 3,
              maxLines: 10,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '''Above is a list of all fonts included in pubspec.yaml version of the GoogleFonts package.
Select All on the list of fonts above and copy to new file in /generator directory
and execute the update_constants.dart program.  See /generator/readme.md for more info.
''',
              ),
            ),
          ],),
        ),
      ),
    );
  }
}