import 'package:flutter/material.dart';

import '../constants/translations.dart';

class FontSample extends StatefulWidget {
  final String initialSampleText;
  final ValueChanged<String> onSampleTextChanged;
  const FontSample(
      {super.key,
      this.initialSampleText = '',
      required this.onSampleTextChanged});

  @override
  _FontSampleState createState() => _FontSampleState();
}

class _FontSampleState extends State<FontSample> {
  bool _isSampleFocused = false;
  late final TextEditingController sampleController;

  @override
  void initState() {
    super.initState();
    sampleController = TextEditingController(text: widget.initialSampleText);
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
            hintText: translations.d['List preview sample text'],
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
