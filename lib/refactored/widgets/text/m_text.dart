import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;

class MText extends StatelessWidget {
  const MText({
    Key? key,
    required this.text,
    this.fontSize = 18,
    this.color,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.fontFamily,
    this.overflow,
    this.decoration,
    this.decorationColor,
    this.decorationThickness,
    this.decorationStyle,
    this.textAlign,
    this.maxLines,
  }) : super(key: key);

  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? wordSpacing;
  final String? fontFamily;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final double? decorationThickness;
  final TextDecorationStyle? decorationStyle;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: GoogleFonts.sairaCondensed(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationThickness: decorationThickness,
        decorationStyle: decorationStyle,
      ),
    );
  }
}
