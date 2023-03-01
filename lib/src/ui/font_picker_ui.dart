library flutter_font_picker;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../constants/fontweights_map.dart';
import '../constants/translations.dart';
import '../models/picker_font.dart';
import 'font_categories.dart';
import 'font_language.dart';
import 'font_preview.dart';
import 'font_sample.dart';
import 'font_search.dart';
import 'star_button.dart';

const prefsRecentsKey = "font_picker_recents";
const prefsFavoritesKey = "font_picker_favorites";

class FontPickerUI extends StatefulWidget {
  final List<String> googleFonts;
  final ValueChanged<PickerFont> onFontChanged;
  String initialFontFamily;
  final bool showFontInfo;
  final bool showInDialog;
  final int recentsCount;
  final bool showFavoriteButtons;
  final int favoritesCount;
  final String lang;
  final bool showFontVariants;
  final bool showListPreviewSampleTextInput;
  final String? listPreviewSampleText;
  final double fontSizeForListPreview;
  final double previewSampleTextFontSize;

  FontPickerUI({
    super.key,
    this.googleFonts = googleFontsList,
    this.showFontInfo = true,
    this.showInDialog = false,
    this.recentsCount = 3,
    this.showFavoriteButtons = false,
    this.favoritesCount = 15,
    required this.onFontChanged,
    required this.initialFontFamily,
    required this.lang,
    this.showFontVariants = true,
    this.showListPreviewSampleTextInput = false,
    this.listPreviewSampleText,
    this.fontSizeForListPreview = 16.0,
    this.previewSampleTextFontSize = 14.0,
  });

  @override
  _FontPickerUIState createState() => _FontPickerUIState();
}

class _FontPickerUIState extends State<FontPickerUI> {

  _FontPickerUIState();

  var _shownFonts = <PickerFont>[];
  var _allFonts = <PickerFont>[];
  var _recentFonts = <PickerFont>[];
  var _favoriteFonts = <PickerFont>[];
  String? _selectedFontFamily;
  FontWeight _selectedFontWeight = FontWeight.w400;
  FontStyle _selectedFontStyle = FontStyle.normal;
  String _selectedFontLanguage = 'all';
  String? listPreviewSampleText;
  late final List<String> allGoogleFonts;
  late final List<String> languagesToDisplay;

  @override
  void initState() {
    allGoogleFonts = GoogleFonts.asMap().keys.toList();
    _prepareShownFonts();
    super.initState();
    if(widget.listPreviewSampleText!=null) listPreviewSampleText = widget.listPreviewSampleText;
  }

  /// Go through all the [supportedFonts] that we are going to list
  /// and 
  ///   1) determine which languages are actually there
  ///   2) and then filter that list down against our [possibleGoogleFontLanguagesWeWillDisplay]
  ///      list which are the only languages we want to list.
  /// and then store the results of 2) in [languagesToDisplay].
  void _reconcileLanguages(List<String> supportedFonts) {
    final List<String> languagesPresentInSupportedFonts = [];
    for(final fontFamily in supportedFonts) {
      final List<String> subsets = googleFontsDetails[fontFamily]!=null 
                                  ? googleFontsDetails[fontFamily]!["subsets"]!.split(",") 
                                  : [];
      for(final language in subsets) {
        if(!languagesPresentInSupportedFonts.contains(language)) {
          languagesPresentInSupportedFonts.add(language);
        }
      }
    }
    /// Now filter the list of languages we ACTUALLY encountered against the list
    /// [googleFontLanguages] which are the only languages we want to display
    languagesToDisplay = languagesPresentInSupportedFonts.where((language) =>
                                                possibleGoogleFontLanguagesWeWillDisplay.contains(language)).toList();
    /// and make 'all' always be the first thing in the list..
    languagesToDisplay.insert(0,'all');
  }


  Future _prepareShownFonts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var recents = prefs.getStringList(prefsRecentsKey) ?? [];
    var favorites = widget.showFavoriteButtons ? (prefs.getStringList(prefsFavoritesKey) ?? []) 
                                                : [];
    /* old way - the GoogleFonts list is way bigger so it makes more sense to filter out list
      against the GoogleFonts list
    final supportedFonts = GoogleFonts.asMap()
        .keys
        .where((e) => widget.googleFonts.contains(e))
        .toList();
    */
    final supportedFonts = widget.googleFonts.where((f) => allGoogleFonts.contains(f)).toList();
    _reconcileLanguages( supportedFonts );

    setState(() {
      // recent fonts first
      _recentFonts = recents.reversed
          .map((fontFamily) =>
              PickerFont(fontFamily: fontFamily, isRecent: true, isFavorite: favorites.contains(fontFamily)))
          .toList();
      // then favorites (except any that were in recents list
      _favoriteFonts = favorites
          .where((fontFamily) => !recents.contains(fontFamily))
          .map((fontFamily) =>
              PickerFont(fontFamily: fontFamily, isFavorite: true))
          .toList();
      // and then the rest of the fonts will follow
      _allFonts = _recentFonts + _favoriteFonts +
          supportedFonts
              .where((fontFamily) => !recents.contains(fontFamily) && !favorites.contains(fontFamily))
              .map((fontFamily) => PickerFont(fontFamily: fontFamily))
              .toList();
      _shownFonts = List.from(_allFonts);
      if (!supportedFonts.contains(widget.initialFontFamily)) {
        widget.initialFontFamily = 'Roboto';
      }
      _selectedFontFamily = widget.initialFontFamily;
    });
  }

  void changeFont(PickerFont selectedFont) {
    setState(() {
      widget.onFontChanged(selectedFont);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 5 / 6,
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
                        languagesToDisplay: languagesToDisplay,
                        onFontLanguageSelected: onFontLanguageSelected,
                        selectedFontLanguage: _selectedFontLanguage,
                      ),
                      const SizedBox(height: 12.0),
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
                          languagesToDisplay: languagesToDisplay,
                          onFontLanguageSelected: onFontLanguageSelected,
                          selectedFontLanguage: _selectedFontLanguage,
                        ),
                      ),
                    ],
                  ),
          ),
          FontCategories(onFontCategoriesUpdated: onFontCategoriesUpdated),
          if(widget.showListPreviewSampleTextInput)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
              child: FontSample(
                initialSampleText: listPreviewSampleText ?? widget.listPreviewSampleText ?? '',
                onSampleTextChanged: onSampleTextChanged,
              ),
          ),
          FontPreview(
            fontFamily: _selectedFontFamily ?? 'Roboto',
            fontWeight: _selectedFontWeight,
            fontStyle: _selectedFontStyle,
            fontSize: widget.previewSampleTextFontSize,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _shownFonts.length,
              itemBuilder: (context, index) {
                PickerFont f = _shownFonts[index];
                bool isBeingSelected = _selectedFontFamily == f.fontFamily;
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
                          fontFamily:
                              GoogleFonts.getFont(f.fontFamily).fontFamily,
                          fontSize: widget.fontSizeForListPreview,
                        ).copyWith(
                          color: DefaultTextStyle.of(context).style.color,
                        ),
                        children: [
                          TextSpan(
                            text: stylesString,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 11.0,
                              color: Colors.grey,
                              fontFamily:
                                  DefaultTextStyle.of(context).style.fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  subtitle: isBeingSelected && widget.showFontVariants
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Wrap(
                            children: f.variants.map((variant) {
                              bool isSelectedVariant;
                              isSelectedVariant = variant == "italic" &&
                                      _selectedFontStyle == FontStyle.italic
                                  ? true
                                  : _selectedFontWeight
                                      .toString()
                                      .contains(variant);

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
                                      textStyle: const TextStyle(
                                        fontSize: 10.0,
                                      ),
                                      shape: const StadiumBorder(),
                                    ),
                                    child: Text(
                                      variant,
                                      style: TextStyle(
                                        fontStyle: variant == "italic"
                                            ? FontStyle.italic
                                            : FontStyle.normal,
                                        color: isSelectedVariant
                                            ? Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                            : Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary ==
                                                    Colors.white
                                                ? null
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                      ),
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
                  trailing: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      listPreviewSampleText!=null && !isBeingSelected 
                      ? ConstrainedBox( 
                          constraints: BoxConstraints(maxWidth: size.width/3),
                          child:Text(
                            listPreviewSampleText!,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontFamily:
                                    GoogleFonts.getFont(f.fontFamily).fontFamily,
                                fontSize: widget.fontSizeForListPreview,
                            ).copyWith(
                              color: DefaultTextStyle.of(context).style.color,
                            ),
                          ), 
                        )
                        : Container(),
                      isBeingSelected
                      ? TextButton(
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
                          ? SizedBox(width: 40, child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  widget.showFavoriteButtons 
                                    ? StarButton( iconSize: 22,
                                          iconColor: Colors.amber[600],
                                          isStarred: f.isFavorite,
                                          valueChanged: (isStarred) {
                                            f.isFavorite = isStarred;
                                            setFavorite(f.fontFamily,isStarred);
                                          },
                                      )
                                    :  const SizedBox( width: 22 ),
                                  const Icon(
                                      Icons.history,
                                      size: 18.0,
                                    ),
                                ],
                              ),
                            )
                          : SizedBox(width: 40, child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  widget.showFavoriteButtons 
                                      ? StarButton( iconSize: 22,
                                            iconColor: Colors.amber[600],
                                            isStarred: f.isFavorite,
                                            valueChanged: (isStarred) {
                                              f.isFavorite = isStarred;
                                              setFavorite(f.fontFamily,isStarred);
                                            },
                                        )
                                      : const SizedBox( width: 22 ),
                                  const SizedBox( width: 18 ),
                                ],
                              ),),
                      ],
                    ),
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
      if (recents.length >= widget.recentsCount) {
        // if there are more saved recents than current recentsCount max then adjust
        // accordingly.  This could potentially happen if recentsCount changes to lower number.
        final keepStarting = recents.length - widget.recentsCount + 1;
        recents = recents.sublist(keepStarting)..add(fontFamily);
      } else {
        recents.add(fontFamily);
      }
      prefs.setStringList(prefsRecentsKey, recents);
    } else {
      prefs.setStringList(prefsRecentsKey, [fontFamily]);
    }
  }

  Future<void> setFavorite(String fontFamily, bool isFavorite) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var favorites = prefs.getStringList(prefsFavoritesKey);
    if (favorites != null && isFavorite && !favorites.contains(fontFamily)) {
      // We are ADDING this favorite
      if (favorites.length >= widget.favoritesCount) {
        // if there are more saved favorites than current favoritesCount max then adjust
        // accordingly.  This could potentially happen if favoritesCount changes to lower number.
        final keepStarting = favorites.length - widget.favoritesCount + 1;
        favorites = favorites.sublist(keepStarting)..add(fontFamily);
      } else {
        favorites.add(fontFamily);
      }
      prefs.setStringList(prefsFavoritesKey, favorites);
    } else if (favorites != null && !isFavorite && favorites.contains(fontFamily)) {
      // we are REMOVING this favorite
      favorites.remove(fontFamily);
      prefs.setStringList(prefsFavoritesKey, favorites);
    } else if (favorites == null && isFavorite) {
      // first favorite to the prefs
      prefs.setStringList(prefsFavoritesKey, [fontFamily]);
    }
  }

  void onFontLanguageSelected(String? newValue) {
    setState(() {
      _selectedFontLanguage = newValue!;
      _shownFonts = newValue == 'all'
          ? _allFonts
          : _allFonts.where((f) => f.subsets.contains(newValue)).toList();
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
              (f) => f.fontFamily.toLowerCase().contains(
                    text.toLowerCase(),
                  ),
            )
            .toList();
      });
    }
  }

  void onSampleTextChanged(String sampleText) {
      setState(() {
        listPreviewSampleText = sampleText;
      });
  }
}
