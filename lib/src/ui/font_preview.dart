import 'package:flutter/material.dart';
import 'package:flutter_font_picker/src/constants/translations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/font_picker_theme.dart';

class FontPreview extends StatelessWidget {
  final String fontFamily;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final bool compact;

  const FontPreview({
    super.key,
    required this.fontFamily,
    required this.fontWeight,
    required this.fontStyle,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final pickerTheme = FontPickerTheme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final previewStyle = GoogleFonts.getFont(
      fontFamily,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: pickerTheme.previewFontSize ?? (compact ? 14.0 : 16.0),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: compact ? 8.0 : 14.0,
        ),
        child: TextField(
          textAlign: TextAlign.center,
          maxLines: compact ? 1 : 2,
          style: previewStyle,
          decoration: InputDecoration(
            isCollapsed: true,
            border: InputBorder.none,
            hintText: translations.d['sampleText'],
            hintStyle: previewStyle.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
