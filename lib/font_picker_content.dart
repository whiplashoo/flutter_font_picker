library flutter_font_picker;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/constants.dart';

//TODO: Basic fonts option (to be included in assets)
//TODO: Filter languages according to selected fonts on init
//TODO: Implement favorites/recents feature

class FontPickerContent extends StatefulWidget {
  final List<String> googleFonts;
  final ValueChanged<PickerFont> onFontChanged;
  final String initialFontFamily;
  final bool showFontInfo;
  final bool showInDialog;
  final int recentsCount;

  const FontPickerContent(
      {Key? key,
      this.googleFonts = GOOGLE_FONTS_LIST,
      this.showFontInfo = true,
      this.showInDialog = false,
      this.recentsCount = 3,
      required this.onFontChanged,
      required this.initialFontFamily})
      : super(key: key);

  @override
  _FontPickerContentState createState() => _FontPickerContentState();
}

class _FontPickerContentState extends State<FontPickerContent> {
  var _shownFonts = <PickerFont>[];
  var _allFonts = <PickerFont>[];
  var _recentFonts = <PickerFont>[];
  String? _selectedFontFamily;
  FontWeight _selectedFontWeight = FontWeight.w400;
  FontStyle _selectedFontStyle = FontStyle.normal;
  TextEditingController searchController = TextEditingController();
  String _selectedFontLanguage = 'all';
  List<String> _selectedFontCategories = List.from(GOOGLE_FONT_CATS);

  @override
  void initState() {
    _prepareShownFonts();
    super.initState();
  }

  Future _prepareShownFonts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var recents = prefs.getStringList(PREFS_RECENTS_KEY) ?? ["Aclonica"];
    setState(() {
      _recentFonts = recents.reversed
          .map((fontFamily) =>
              PickerFont(fontFamily: fontFamily, isRecent: true))
          .toList();
      _allFonts = _recentFonts + widget.googleFonts
          .where((fontFamily) => !recents.contains(fontFamily))
          .map((fontFamily) => PickerFont(fontFamily: fontFamily))
          .toList();
      _shownFonts = _allFonts;
    });
  }

  void changeFont(PickerFont selectedFont) {
    setState(() {
      widget.onFontChanged(selectedFont);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 5 / 6,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        iconSize: 16.0,
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          searchController.clear();
                          onSearchTextChanged('');
                        },
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none),
                  onChanged: onSearchTextChanged,
                ),
              ),
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedFontLanguage,
                  isDense: true,
                  style: TextStyle(fontSize: 12.0, color: Colors.black),
                  icon: const Icon(Icons.arrow_drop_down_sharp),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFontLanguage = newValue!;
                      if (newValue == 'all') {
                        _shownFonts = _allFonts;
                      } else {
                        _shownFonts = _allFonts
                            .where((f) => f.subsets.contains(newValue))
                            .toList();
                        print(_shownFonts.length);
                      }
                    });
                  },
                  items: GOOGLE_FONT_LANGS.keys
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(GOOGLE_FONT_LANGS[value]!),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
          Wrap(
              children: GOOGLE_FONT_CATS.map((fontCategory) {
            bool isSelectedCategory =
                _selectedFontCategories.contains(fontCategory);
            return SizedBox(
              height: 30.0,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: isSelectedCategory
                          ? Theme.of(context).primaryColor
                          : null,
                      textStyle: TextStyle(
                        fontSize: 10.0,
                      ),
                      shape: StadiumBorder()),
                  child: Text(fontCategory,
                      style: TextStyle(
                        color: isSelectedCategory ? Colors.white : null,
                      )),
                  onPressed: () {
                    setState(() {
                      isSelectedCategory
                          ? _selectedFontCategories.remove(fontCategory)
                          : _selectedFontCategories.add(fontCategory);
                      _shownFonts = _allFonts
                          .where((f) =>
                              _selectedFontCategories.contains(f.category))
                          .toList();
                    });
                  },
                ),
              ),
            );
          }).toList()),
          SizedBox(
              width: 300.0,
              child: TextField(
                style: GoogleFonts.getFont(
                    _selectedFontFamily ?? widget.initialFontFamily,
                    fontWeight: _selectedFontWeight,
                    fontStyle: _selectedFontStyle),
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'The quick brown fox jumped over the lazy dog',
                    hintStyle: TextStyle(
                        fontStyle: _selectedFontStyle,
                        fontWeight: _selectedFontWeight)),
              )),
          Expanded(
              child: ListView.builder(
            itemCount: _shownFonts.length,
            itemBuilder: (context, index) {
              PickerFont f = _shownFonts[index];
              bool isBeingSelected = _selectedFontFamily == f.fontFamily;
              String stylesString = widget.showFontInfo
                  ? f.variants.length > 1
                      ? "  ${f.category}, ${f.variants.length} styles"
                      : "  ${f.category}"
                  : "";
              return ListTile(
                selected: isBeingSelected,
                selectedTileColor: Theme.of(context).focusColor,
                onTap: () {
                  setState(() {
                    _selectedFontFamily = f.fontFamily;
                    _selectedFontWeight = FontWeight.w400;
                    _selectedFontStyle = FontStyle.normal;
                  });
                },
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: RichText(
                      text: TextSpan(
                          text: f.fontFamily,
                          style: TextStyle(
                              fontFamily:
                                  GoogleFonts.getFont(f.fontFamily).fontFamily,
                              color: Colors.black),
                          children: [
                        TextSpan(
                            text: stylesString,
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 11.0,
                                color: Colors.grey,
                                fontFamily: DefaultTextStyle.of(context)
                                    .style
                                    .fontFamily))
                      ])),
                ),
                subtitle: isBeingSelected
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Wrap(
                            children: f.variants.map((variant) {
                          bool isSelectedVariant;
                          if (variant == "italic" &&
                              _selectedFontStyle == FontStyle.italic) {
                            isSelectedVariant = true;
                          } else {
                            isSelectedVariant = _selectedFontWeight
                                .toString()
                                .contains(variant);
                          }
                          return SizedBox(
                            height: 30.0,
                            width: 60.0,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: isSelectedVariant
                                        ? Theme.of(context).primaryColor
                                        : null,
                                    textStyle: TextStyle(
                                      fontSize: 10.0,
                                    ),
                                    shape: StadiumBorder()),
                                child: Text(
                                  variant,
                                  style: TextStyle(
                                      fontStyle: variant == "italic"
                                          ? FontStyle.italic
                                          : FontStyle.normal,
                                      color: isSelectedVariant
                                          ? Colors.white
                                          : null),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (variant == "italic") {
                                      _selectedFontStyle == FontStyle.italic
                                          ? _selectedFontStyle =
                                              FontStyle.normal
                                          : _selectedFontStyle =
                                              FontStyle.italic;
                                    } else {
                                      _selectedFontWeight =
                                          FONT_WEIGHT_VALUES[variant]!;
                                    }
                                  });
                                },
                              ),
                            ),
                          );
                        }).toList()),
                      )
                    : null,
                trailing: isBeingSelected
                    ? TextButton(
                        child: Text(
                          'SELECT',
                        ),
                        onPressed: () {
                          addToRecents(_selectedFontFamily!);
                          changeFont(PickerFont(
                              fontFamily: _selectedFontFamily!,
                              fontWeight: _selectedFontWeight,
                              fontStyle: _selectedFontStyle));
                          Navigator.of(context).pop();
                        },
                      )
                    : _recentFonts.contains(f)
                        ? Icon(
                            Icons.history,
                            size: 18.0,
                          )
                        : null,
              );
            },
          ))
        ],
      ),
    );
  }

  Future<void> addToRecents(String fontFamily) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var recents = prefs.getStringList(PREFS_RECENTS_KEY);
    if (recents != null) {
      if (recents.length == widget.recentsCount) {
        recents = recents.sublist(1)..add(fontFamily);
      } else {
        recents.add(fontFamily);
      }
      prefs.setStringList(PREFS_RECENTS_KEY, recents);
    } else {
      prefs.setStringList(PREFS_RECENTS_KEY, [fontFamily]);
    }
    print(recents);
  }

  void onSearchTextChanged(String text) {
    if (text.isEmpty) {
      setState(() {
        _shownFonts = _allFonts;
      });
      return;
    } else {
      setState(() {
        _shownFonts = _allFonts
            .where(
                (f) => f.fontFamily.toLowerCase().contains(text.toLowerCase()))
            .toList();
      });
    }
  }
}

class PickerFont {
  final String fontFamily;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  List<String> variants;
  List<String> subsets;
  String category;
  bool isRecent;

  PickerFont(
      {required this.fontFamily,
      this.fontWeight = FontWeight.w400,
      this.fontStyle = FontStyle.normal,
      this.isRecent = false})
      : variants = parseVariants(fontFamily),
        subsets = GOOGLE_FONTS[fontFamily]!["subsets"]!.split(","),
        category = GOOGLE_FONTS[fontFamily]!["category"]!;

  factory PickerFont.fromString(String fontSpec) {
    final fontSpecSplit = fontSpec.split(":");
    if (fontSpecSplit.length == 1) {
      return PickerFont(fontFamily: fontSpecSplit[0]);
    } else {
      return PickerFont(
          fontFamily: fontSpecSplit[0],
          fontWeight:
              FONT_WEIGHT_VALUES[fontSpecSplit[1].replaceAll("i", "")] ??
                  FontWeight.w400,
          fontStyle: fontSpecSplit[1].contains("i")
              ? FontStyle.italic
              : FontStyle.normal);
    }
  }

  static List<String> parseVariants(String fontFamily) {
    var variants = GOOGLE_FONTS[fontFamily]!["variants"]!.split(",");
    if (variants.any((v) => v.contains("i"))) {
      variants.add("italic");
    }
    variants.removeWhere((v) => v.endsWith("i"));
    return variants;
  }

  String toFontSpec() {
    String fontWeightString = this.fontWeight.toString();
    String fontSpec =
        "${this.fontFamily}:${fontWeightString.substring(fontWeightString.length - 3)}";
    return this.fontStyle == FontStyle.italic ? "${fontSpec}i" : fontSpec;
  }

  TextStyle toTextStyle() {
    return GoogleFonts.getFont(this.fontFamily,
        fontWeight: this.fontWeight, fontStyle: this.fontStyle);
  }
}
