import 'package:flutter/material.dart';

import '../constants/constants.dart';

class FontCategories extends StatefulWidget {
  final ValueChanged<List<String>> onFontCategoriesUpdated;
  const FontCategories({super.key, required this.onFontCategoriesUpdated});

  @override
  _FontCategoriesState createState() => _FontCategoriesState();
}

class _FontCategoriesState extends State<FontCategories> {
  final List<String> _selectedFontCategories = List.from(googleFontCategories);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: googleFontCategories.map((fontCategory) {
        bool isSelectedCategory =
            _selectedFontCategories.contains(fontCategory);

        return SizedBox(
          height: 30.0,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor:
                    isSelectedCategory ? Theme.of(context).primaryColor : null,
                textStyle: const TextStyle(
                  fontSize: 10.0,
                ),
                shape: const StadiumBorder(),
              ),
              child: Text(
                fontCategory,
                style: TextStyle(
                  color: isSelectedCategory
                      ? Theme.of(context).colorScheme.onPrimary
                      : null,
                ),
              ),
              onPressed: () {
                _selectedFontCategories.contains(fontCategory)
                    ? _selectedFontCategories.remove(fontCategory)
                    : _selectedFontCategories.add(fontCategory);
                widget.onFontCategoriesUpdated(_selectedFontCategories);
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}
