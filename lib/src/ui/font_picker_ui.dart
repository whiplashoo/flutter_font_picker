library flutter_font_picker;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../models/picker_font.dart';
import 'font_categories.dart';
import 'font_language.dart';
import 'font_preview.dart';
import 'font_search.dart';

//TODO: Basic fonts option (to be included in assets)
//TODO: Filter languages according to selected fonts on init
//TODO: Implement favorites feature

class FontPickerUI extends StatefulWidget {
  final List<String> googleFonts;
  final ValueChanged<PickerFont> onFontChanged;
  final String initialFontFamily;
  final bool showFontInfo;
  final bool showInDialog;
  final int recentsCount;

  const FontPickerUI(
      {Key? key,
      this.googleFonts = GOOGLE_FONTS_LIST,
      this.showFontInfo = true,
      this.showInDialog = false,
      this.recentsCount = 3,
      required this.onFontChanged,
      required this.initialFontFamily})
      : super(key: key);

  @override
  _FontPickerUIState createState() => _FontPickerUIState();
}

class _FontPickerUIState extends State<FontPickerUI> {
  var _shownFonts = <PickerFont>[];
  var _allFonts = <PickerFont>[];
  var _recentFonts = <PickerFont>[];
  String? _selectedFontFamily;
  FontWeight _selectedFontWeight = FontWeight.w400;
  FontStyle _selectedFontStyle = FontStyle.normal;
  String _selectedFontLanguage = 'all';

  @override
  void initState() {
    _prepareShownFonts();
    super.initState();
  }

  Future _prepareShownFonts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var recents = prefs.getStringList(PREFS_RECENTS_KEY) ?? [];
    setState(() {
      _recentFonts = recents.reversed
          .map((fontFamily) =>
              PickerFont(fontFamily: fontFamily, isRecent: true))
          .toList();
      _allFonts = _recentFonts +
          widget.googleFonts
              .where((fontFamily) => !recents.contains(fontFamily))
              .map((fontFamily) => PickerFont(fontFamily: fontFamily))
              .toList();
      _shownFonts = List.from(_allFonts);
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
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            child: widget.showInDialog
                ? ListView(
                    shrinkWrap: true,
                    children: [
                      FontSearch(
                        onSearchTextChanged: onSearchTextChanged,
                      ),
                      FontLanguage(
                        onFontLanguageSelected: onFontLanguageSelected,
                        selectedFontLanguage: _selectedFontLanguage,
                      ),
                      SizedBox(height: 12.0)
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: FontSearch(
                          onSearchTextChanged: onSearchTextChanged,
                        ),
                      ),
                      Expanded(
                        child: FontLanguage(
                          onFontLanguageSelected: onFontLanguageSelected,
                          selectedFontLanguage: _selectedFontLanguage,
                        ),
                      )
                    ],
                  ),
          ),
          FontCategories(onFontCategoriesUpdated: onFontCategoriesUpdated),
          FontPreview(
              fontFamily: _selectedFontFamily ?? widget.initialFontFamily,
              fontWeight: _selectedFontWeight,
              fontStyle: _selectedFontStyle),
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
                    if (!isBeingSelected) {
                      _selectedFontFamily = f.fontFamily;
                      _selectedFontWeight = FontWeight.w400;
                      _selectedFontStyle = FontStyle.normal;
                    } else {
                      _selectedFontFamily = null;
                    }
                  });
                },
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: RichText(
                      text: TextSpan(
                          text: f.fontFamily,
                          style: TextStyle(
                                  fontFamily: GoogleFonts.getFont(f.fontFamily)
                                      .fontFamily)
                              .copyWith(
                                  color:
                                      DefaultTextStyle.of(context).style.color),
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
    if (recents != null && !recents.contains(fontFamily)) {
      if (recents.length == widget.recentsCount) {
        recents = recents.sublist(1)..add(fontFamily);
      } else {
        recents.add(fontFamily);
      }
      prefs.setStringList(PREFS_RECENTS_KEY, recents);
    } else {
      prefs.setStringList(PREFS_RECENTS_KEY, [fontFamily]);
    }
  }

  void onFontLanguageSelected(String? newValue) {
    setState(() {
      _selectedFontLanguage = newValue!;
      if (newValue == 'all') {
        _shownFonts = _allFonts;
      } else {
        _shownFonts =
            _allFonts.where((f) => f.subsets.contains(newValue)).toList();
      }
    });
  }

  void onFontCategoriesUpdated(List<String> selectedFontCategories) {
    setState(() {
      _shownFonts = _allFonts
          .where((f) => selectedFontCategories.contains(f.category))
          .toList();
    });
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
