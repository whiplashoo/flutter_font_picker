import 'package:flutter/material.dart';
import 'package:flutter_font_picker/constants/constants.dart';

class FontCategories extends StatefulWidget {
  final ValueChanged<List<String>> onFontCategoriesUpdated;
  const FontCategories({Key? key, required this.onFontCategoriesUpdated})
      : super(key: key);

  @override
  _FontCategoriesState createState() => _FontCategoriesState();
}

class _FontCategoriesState extends State<FontCategories> {
  List<String> _selectedFontCategories = List.from(GOOGLE_FONT_CATS);

  @override
  Widget build(BuildContext context) {
    return Wrap(
        children: GOOGLE_FONT_CATS.map((fontCategory) {
      bool isSelectedCategory = _selectedFontCategories.contains(fontCategory);
      return SizedBox(
        height: 30.0,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                backgroundColor:
                    isSelectedCategory ? Theme.of(context).primaryColor : null,
                textStyle: TextStyle(
                  fontSize: 10.0,
                ),
                shape: StadiumBorder()),
            child: Text(fontCategory,
                style: TextStyle(
                  color: isSelectedCategory ? Colors.white : null,
                )),
            onPressed: () {
              _selectedFontCategories.contains(fontCategory)
                  ? _selectedFontCategories.remove(fontCategory)
                  : _selectedFontCategories.add(fontCategory);
              widget.onFontCategoriesUpdated(_selectedFontCategories);
            },
          ),
        ),
      );
    }).toList());
  }
}
