import 'package:flutter/material.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';

import 'package:device_preview/device_preview.dart'; // required when useDevicePreview==true
import 'flexible.dart';

/// Set [useDevicePreview] to allow testing layouts on virtual device screens
const useDevicePreview = false;

void main() {
  if(useDevicePreview) {
    //TEST various on various device screens//
    runApp(DevicePreview(
            builder: (context) => const MyApp(), // Wrap your app
            enabled: true,
          ));
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Font Picker Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'Font Picker Demo'),
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
  String _selectedFont = 'Roboto';

  late TextStyle? _selectedFontTextStyle = GoogleFonts.getFont(_selectedFont);

  bool _showFontVariants = true;

  bool _showFontInfo = true;

  bool _showListPreviewSampleTextInput = false;

  String _listPreviewSampleText = '';

  double _sampleTextFontSize = 14.0;

  double _fontPickerListFontSize = 16.0;

  double _previewFontSize = 24.0;

  FontListType _fontListType = FontListType.subset;

  late List<String> _myGoogleFonts = _subsetListOfGoogleFonts;

  final List<String> _completeGoogleFonts = GoogleFonts.asMap().keys.toList();

  final List<String> _subsetListOfGoogleFonts = [
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
    "Nabla",
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
    "Zilla Slab",
  ];

  void _onFontListTypeChange( FontListType? val ) {
    setState(() {
      _fontListType = val ?? FontListType.subset;
      if(_fontListType == FontListType.subset) {
        _myGoogleFonts = _subsetListOfGoogleFonts;
      } else {
        _myGoogleFonts = _completeGoogleFonts;
      }
    });
  }

  bool? configPanelExpanded;

  List<Widget> buildFlexibleOptionsCustomizationPanel(BuildContext context) {
    final size = MediaQuery.of(context).size; 
    var willSplitRows = Splittable.willSplitRows(context);
    final bool useExpandPanel = willSplitRows || (size.height<400);
    // if we are going to use the expand panel because short then FORCE split
    if(useExpandPanel && !willSplitRows) willSplitRows = true;

    // we set the initial value of configPanelExpanded depending on
    // how we initially have to render it.  If we don't initially have
    // to split the rows then we will init it to 'expanded', that way if the
    // window shrinks and we are forced to use it it will already be expanded,
    // (as it is when it is NOT rendered in a panel)
    configPanelExpanded ??= !useExpandPanel;

    final mainAxisAlignment = willSplitRows ? MainAxisAlignment.start 
                                      : MainAxisAlignment.center;
    final controlPanelItems = <Widget>[
              ...Splittable.splittableRow(
                context: context,
                splitOn: Radio<FontListType>,
                splitWidgetBehavior:SplitWidgetBehavior.includeInNextRow,
                mainAxisAlignment: mainAxisAlignment,
                children: <Widget>[
                  const Text(
                    'List of fonts is :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Radio<FontListType>(
                    value: FontListType.subset,
                    groupValue: _fontListType,
                    onChanged: _onFontListTypeChange,
                  ),
                  const Text(
                    'Subset of GoogleFonts',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Radio<FontListType>(
                    value: FontListType.complete,
                    groupValue: _fontListType,
                    onChanged: _onFontListTypeChange,
                  ),
                  const Text(
                    'All GoogleFonts',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
             ...Splittable.splittableRow(
                context: context,
                splitEveryN: 4,
                splitWidgetBehavior:SplitWidgetBehavior.exclude,
                mainAxisAlignment: mainAxisAlignment,
                children: <Widget>[
                  const Text(
                    'Show font variants :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Checkbox(
                    value: _showFontVariants,
                    onChanged: (checked) {
                      setState(() {
                        _showFontVariants = checked ?? false;
                      });
                    },
                  ),
                  const SizedBox(width: 30),
                  const Text(
                    'Show font info :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Checkbox(
                    value: _showFontInfo,
                    onChanged: (checked) {
                      setState(() {
                        _showFontInfo = checked ?? false;
                      });
                    },
                  ),
                ],
              ),
             ...Splittable.splittableRow(
                context: context,
                forceSplit: useExpandPanel || size.width<=850,
                splitAtIndices: [ 1 ],
                splitWidgetBehavior:SplitWidgetBehavior.exclude,
                mainAxisAlignment: mainAxisAlignment,
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: !useExpandPanel ? 300 : size.width*0.8,
                    ),
                    child: FontListPreviewSample(
                      onSampleTextChanged: (newSample) {
                        setState(() {
                          _listPreviewSampleText = newSample;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 30),
                  const Text(
                    'Editing of list preview sample text :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Checkbox(
                    value: _showListPreviewSampleTextInput,
                    onChanged: (checked) {
                      setState(() {
                        _showListPreviewSampleTextInput = checked ?? false;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height:10),
              ...Splittable.splittableRow(
                context: context,
                splitOn: Slider,
                splitWidgetBehavior:SplitWidgetBehavior.includeInNextRow,
                mainAxisAlignment: mainAxisAlignment,
                children: <Widget>[
                  Text(
                    'Font size for sample text : ${_sampleTextFontSize}px',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Slider(
                    min: 10.0,
                    max: 64.0,
                    value: _sampleTextFontSize,
                    onChanged: (value) {
                      setState(() {
                        _sampleTextFontSize = value.round().toDouble();
                      });
                    },
                  ),
                ],
              ),
              ...Splittable.splittableRow(
                context: context,
                splitOn: Slider,
                splitWidgetBehavior:SplitWidgetBehavior.includeInNextRow,
                mainAxisAlignment: mainAxisAlignment,
                children: <Widget>[
                  Text(
                    'Font size for fonts in picker list : ${_fontPickerListFontSize}px',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Slider(
                    min: 10.0,
                    max: 64.0,
                    value: _fontPickerListFontSize,
                    onChanged: (value) {
                      setState(() {
                        _fontPickerListFontSize = value.round().toDouble();
                      });
                    },
                  ),
                ],
              ),
              if(!willSplitRows) Padding(
                        padding: const EdgeInsets.all(12.0),
                        child:Container( height: 2, color: Colors.black ),
                      ),
    ];

    final controlPanelColumn = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ...controlPanelItems,
                  ],
                );

    // Return either the control panel widgets directly or place them in a 
    // ExpansionPanelList/ExpansionPanel.
    return [
      if(!useExpandPanel) ...[
            const SizedBox(height: 12),
            const Text(
              'Optional settings to configure FontPicker() :',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 12),
          ],
      !useExpandPanel ?
        controlPanelColumn
      : ExpansionPanelList(
        animationDuration: const Duration(milliseconds:500),
        expandIconColor: Colors.green,
        expandedHeaderPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        elevation:1,
        children: [
            ExpansionPanel(
              backgroundColor: const Color.fromARGB(255,220,220,220),
              body: Container(
                padding: const EdgeInsets.fromLTRB(20, 8, 10, 0),
                child: controlPanelColumn,
              ),
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Container(
                    color: Colors.teal,
                    padding: const EdgeInsets.fromLTRB(20.0, 14.0, 6.0, 0),
                    child: const Text('FontPicker() configuration settings : ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                  );
              },
              isExpanded: configPanelExpanded!,
              canTapOnHeader : true,
          ),
          ],
        expansionCallback: (int item, bool status) {
          setState(() {
            configPanelExpanded = !configPanelExpanded!;
          });
        },
      ),
      const SizedBox(height: 12),
   ];
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;   

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: IntrinsicHeight(child: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 5.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ...buildFlexibleOptionsCustomizationPanel(context),
                    const Text(
                      'Examples of FontPicker() (using above settings):',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      child: const Text('Pick a font (with a screen)'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FontPicker(
                              recentsCount: 10,
                              onFontChanged: (font) {
                                setState(() {
                                  _selectedFont = font.fontFamily;
                                  _selectedFontTextStyle = font.toTextStyle();
                                });
                                debugPrint(
                                  "${font.fontFamily} with font weight ${font.fontWeight} and font style ${font.fontStyle}. FontSpec: ${font.toFontSpec()}",
                                );
                              },
                              googleFonts: _myGoogleFonts,
                              showFontVariants: _showFontVariants,
                              showFontInfo: _showFontInfo,
                              showListPreviewSampleTextInput: _showListPreviewSampleTextInput,
                              listPreviewSampleText: _listPreviewSampleText,
                              previewSampleTextFontSize: _sampleTextFontSize,
                              fontSizeForListPreview: _fontPickerListFontSize,

                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height:16),
                    ElevatedButton(
                      child: const Text('Pick a font (with a dialog)'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: SingleChildScrollView(
                                child: SizedBox(
                                  width: double.maxFinite,
                                  child: FontPicker(
                                    showInDialog: true,
                                    initialFontFamily: 'Anton',
                                    onFontChanged: (font) {
                                      setState(() {
                                        _selectedFont = font.fontFamily;
                                        _selectedFontTextStyle = font.toTextStyle();
                                      });
                                      debugPrint(
                                        "${font.fontFamily} with font weight ${font.fontWeight} and font style ${font.fontStyle}. FontSpec: ${font.toFontSpec()}",
                                      );
                                    },
                                    googleFonts: _myGoogleFonts,
                                    showFontVariants: _showFontVariants,
                                    showFontInfo: _showFontInfo,
                                    showListPreviewSampleTextInput: _showListPreviewSampleTextInput,
                                    listPreviewSampleText: _listPreviewSampleText,
                                    previewSampleTextFontSize: _sampleTextFontSize,
                                    fontSizeForListPreview: _fontPickerListFontSize,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: size.width>500 ? 500 : size.width,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Pick a font: ',
                                textAlign: TextAlign.right,
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              textAlign: TextAlign.center,
                              style: _selectedFontTextStyle?.copyWith(fontSize:_fontPickerListFontSize),
                              decoration: InputDecoration(
                                suffixIcon: const Icon(Icons.arrow_drop_down_sharp),
                                hintText: _selectedFont,
                                border: InputBorder.none,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FontPicker(
                                      onFontChanged: (font) {
                                        setState(() {
                                          _selectedFont = font.fontFamily;
                                          _selectedFontTextStyle = font.toTextStyle();
                                        });
                                        debugPrint(
                                          "${font.fontFamily} with font weight ${font.fontWeight} and font style ${font.fontStyle}. FontSpec: ${font.toFontSpec()}",
                                        );
                                      },
                                      googleFonts: _myGoogleFonts,
                                      showFontVariants: _showFontVariants,
                                      showFontInfo: _showFontInfo,
                                      showListPreviewSampleTextInput: _showListPreviewSampleTextInput,
                                      listPreviewSampleText: _listPreviewSampleText,
                                      previewSampleTextFontSize: _sampleTextFontSize,
                                      fontSizeForListPreview: _fontPickerListFontSize,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child:Container( height: 2, color: Colors.black ),
                    ),
                    ...Splittable.splittableRow(
                      context: context,
                      splitOn: Slider,
                      splitWidgetBehavior:SplitWidgetBehavior.includeInNextRow,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Preview font size : ${_previewFontSize}px',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        Slider(
                          min: 10.0,
                          max: 96.0,
                          value: _previewFontSize,
                          onChanged: (value) {
                            setState(() {
                              _previewFontSize = value.round().toDouble();
                            });
                          },
                        ),
                      ],
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.minHeight,
                        maxHeight: viewportConstraints.maxHeight,
                      ),
                      child: IntrinsicHeight(child:
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blueGrey,
                                width: 2.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: ClipRect(
                                clipBehavior: Clip.hardEdge,
                                child: OverflowBox(
                                  alignment: Alignment.center,
                                  minWidth: 0.0,
                                  minHeight: viewportConstraints.minHeight,
                                  maxWidth: double.infinity,
                                  maxHeight: viewportConstraints.maxHeight,//double.infinity,   
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Font: $_selectedFont',
                                        style: _selectedFontTextStyle?.copyWith(fontSize:_previewFontSize),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        'The quick brown fox jumped',
                                        style: _selectedFontTextStyle?.copyWith(fontSize:_previewFontSize),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        'over the lazy dog',
                                        style: _selectedFontTextStyle?.copyWith(fontSize:_previewFontSize),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),),
          );
        },
      ),
    );
  }
}



class FontListPreviewSample extends StatefulWidget {
  const FontListPreviewSample({super.key, this.initialSampleText = '', required this.onSampleTextChanged});

  final String initialSampleText;
  final ValueChanged<String> onSampleTextChanged;

  @override
  _FontListPreviewSampleState createState() => _FontListPreviewSampleState();
}

class _FontListPreviewSampleState extends State<FontListPreviewSample> {
  bool _isSampleFocused = false;
  late final TextEditingController sampleController;

  @override
  void initState() {
    super.initState();
    sampleController = TextEditingController(text:widget.initialSampleText);
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Focus(
        onFocusChange: (focus) {
          setState(() {
            _isSampleFocused = focus;
          });
        },
        child: TextFormField(
          controller: sampleController,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.list,
            ),
            label:  const Text(
                    'List preview sample text',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
            suffixIcon: _isSampleFocused
                ? IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      sampleController.clear();
                      widget.onSampleTextChanged('');
                    },
                  )
                : null,
            hintText: 'Optional sample text to add to each font preview in list',
            hintStyle: const TextStyle(fontSize: 14.0),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
          onChanged: widget.onSampleTextChanged,
        ),
      ),
    );
  }
}
