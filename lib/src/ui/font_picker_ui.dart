library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../constants/fontweights_map.dart';
import '../constants/translations.dart';
import '../models/font_picker_theme.dart';
import '../models/picker_font.dart';
import 'font_categories.dart';
import 'font_language.dart';
import 'font_preview.dart';
import 'font_search.dart';

class FontPickerUI extends StatefulWidget {
  final List<String> googleFonts;
  final ValueChanged<PickerFont> onFontChanged;
  final String initialFontFamily;
  final bool showFontInfo;
  final bool showInDialog;
  final int recentsCount;
  final String lang;
  final bool showFontVariants;

  const FontPickerUI({
    super.key,
    this.googleFonts = googleFontsList,
    this.showFontInfo = true,
    this.showInDialog = false,
    this.recentsCount = 3,
    required this.onFontChanged,
    required this.initialFontFamily,
    required this.lang,
    this.showFontVariants = true,
  });

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
  String _searchText = '';
  List<String> _selectedFontCategories = [];

  @override
  void initState() {
    _prepareShownFonts();
    super.initState();
  }

  Future _prepareShownFonts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var recents = prefs.getStringList(prefsRecentsKey) ?? [];
    final supportedFonts = GoogleFonts.asMap()
        .keys
        .where((e) => widget.googleFonts.contains(e))
        .toList();
    setState(() {
      _recentFonts = recents.reversed
          .map((fontFamily) =>
              PickerFont(fontFamily: fontFamily, isRecent: true))
          .toList();
      _allFonts = _recentFonts +
          supportedFonts
              .where((fontFamily) => !recents.contains(fontFamily))
              .map((fontFamily) => PickerFont(fontFamily: fontFamily))
              .toList();
      _shownFonts = List.from(_allFonts);
      _selectedFontFamily = supportedFonts.contains(widget.initialFontFamily)
          ? widget.initialFontFamily
          : 'Roboto';
    });
  }

  void changeFont(PickerFont selectedFont) {
    setState(() {
      widget.onFontChanged(selectedFont);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pickerTheme = FontPickerTheme.of(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 5 / 6,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              16.0,
              widget.showInDialog ? 4.0 : 12.0,
              16.0,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FontSearch(
                        onSearchTextChanged: onSearchTextChanged,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    FontLanguage(
                      onFontLanguageSelected: onFontLanguageSelected,
                      selectedFontLanguage: _selectedFontLanguage,
                      compact: widget.showInDialog,
                    ),
                  ],
                ),
                SizedBox(height: widget.showInDialog ? 8.0 : 12.0),
                FontCategories(
                  onFontCategoriesUpdated: onFontCategoriesUpdated,
                  scrollable: widget.showInDialog,
                ),
                SizedBox(height: widget.showInDialog ? 8.0 : 12.0),
                FontPreview(
                  fontFamily: _selectedFontFamily ?? 'Roboto',
                  fontWeight: _selectedFontWeight,
                  fontStyle: _selectedFontStyle,
                  compact: widget.showInDialog,
                ),
                SizedBox(height: widget.showInDialog ? 4.0 : 8.0),
              ],
            ),
          ),
          const Divider(height: 1.0),
          Expanded(
            child: _shownFonts.isEmpty
                ? Center(
                    child: Text(
                      translations.d['noFontsFound']!,
                      style: pickerTheme.emptyStateStyle,
                    ),
                  )
                : ListView.builder(
                    itemCount: _shownFonts.length,
                    itemBuilder: (context, index) {
                      PickerFont f = _shownFonts[index];
                      bool isBeingSelected =
                          _selectedFontFamily == f.fontFamily;
                      String category = translations.d[f.category]!;
                      String stylesString = "";
                      if (widget.showFontInfo) {
                        stylesString += "  $category";
                        if (widget.showFontVariants) {
                          stylesString +=
                              ", ${f.variants.length} ${translations.d['styles']}";
                        }
                      }

                      return ListTile(
                        selected: isBeingSelected,
                        selectedTileColor: pickerTheme.selectedTileColor,
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
                              style: pickerTheme.fontListItemStyle?.copyWith(
                                fontFamily: GoogleFonts.getFont(f.fontFamily)
                                    .fontFamily,
                              ),
                              children: [
                                TextSpan(
                                  text: stylesString,
                                  style: pickerTheme.fontListItemInfoStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                        subtitle: isBeingSelected && widget.showFontVariants
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Wrap(
                                  children: f.variants.map((variant) {
                                    bool isSelectedVariant;
                                    isSelectedVariant = variant == "italic" &&
                                            _selectedFontStyle ==
                                                FontStyle.italic
                                        ? true
                                        : _selectedFontWeight
                                            .toString()
                                            .contains(variant);

                                    return SizedBox(
                                      height: pickerTheme.chipHeight,
                                      width: 60.0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: isSelectedVariant
                                                ? pickerTheme
                                                    .activeChipBackgroundColor
                                                : null,
                                            shape: const StadiumBorder(),
                                            padding: EdgeInsets.zero,
                                          ),
                                          child: Center(
                                            child: Text(
                                              variant,
                                              maxLines: 1,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                fontSize:
                                                    pickerTheme.chipFontSize,
                                                fontStyle: variant == "italic"
                                                    ? FontStyle.italic
                                                    : FontStyle.normal,
                                                color: isSelectedVariant
                                                    ? pickerTheme
                                                        .activeChipForegroundColor
                                                    : pickerTheme
                                                        .inactiveChipForegroundColor,
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (variant == "italic") {
                                                _selectedFontStyle ==
                                                        FontStyle.italic
                                                    ? _selectedFontStyle =
                                                        FontStyle.normal
                                                    : _selectedFontStyle =
                                                        FontStyle.italic;
                                              } else {
                                                _selectedFontWeight =
                                                    fontWeightValues[variant]!;
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            : null,
                        trailing: isBeingSelected
                            ? TextButton(
                                style: pickerTheme.selectButtonStyle,
                                child: Text(
                                  translations.d["select"]!,
                                ),
                                onPressed: () {
                                  addToRecents(_selectedFontFamily!);
                                  changeFont(
                                    PickerFont(
                                      fontFamily: _selectedFontFamily!,
                                      fontWeight: _selectedFontWeight,
                                      fontStyle: _selectedFontStyle,
                                    ),
                                  );
                                  Navigator.of(context).pop();
                                },
                              )
                            : _recentFonts.contains(f)
                                ? const Icon(
                                    Icons.history,
                                    size: 18.0,
                                  )
                                : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> addToRecents(String fontFamily) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var recents = prefs.getStringList(prefsRecentsKey);
    if (recents != null && !recents.contains(fontFamily)) {
      if (recents.length == widget.recentsCount) {
        recents = recents.sublist(1)..add(fontFamily);
      } else {
        recents.add(fontFamily);
      }
      prefs.setStringList(prefsRecentsKey, recents);
    } else {
      prefs.setStringList(prefsRecentsKey, [fontFamily]);
    }
  }

  void onFontLanguageSelected(String? newValue) {
    setState(() {
      _selectedFontLanguage = newValue!;
      _applyFilters();
    });
  }

  void onFontCategoriesUpdated(List<String> selectedFontCategories) {
    setState(() {
      _selectedFontCategories = selectedFontCategories;
      _applyFilters();
    });
  }

  void onSearchTextChanged(String text) {
    setState(() {
      _searchText = text;
      _applyFilters();
    });
  }

  /// Applies search, category, and language filters together (AND).
  /// Empty category selection means no category filter (show all categories).
  void _applyFilters() {
    final search = _searchText.toLowerCase();
    _shownFonts = _allFonts.where((f) {
      final matchesSearch =
          search.isEmpty || f.fontFamily.toLowerCase().contains(search);
      final matchesCategory = _selectedFontCategories.isEmpty ||
          _selectedFontCategories.contains(f.category);
      final matchesLanguage = _selectedFontLanguage == 'all' ||
          f.subsets.contains(_selectedFontLanguage);

      return matchesSearch && matchesCategory && matchesLanguage;
    }).toList();
  }
}
