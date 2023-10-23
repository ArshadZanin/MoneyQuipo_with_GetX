import 'package:flutter/material.dart';
import 'package:money_management/refactored/core/constants/app_colors.dart';

class InputStyle {
  static InputDecoration getInputDecoration({
    bool filled = false,
    Color? fillColor,
    String? hintText,
    Widget? suffixIcon,
    Widget? prefixIcon,
    EdgeInsetsGeometry? contentPadding,
    double? fontSize,
    double? borderRadius,
    Color? borderColor,
  }) {
    return InputDecoration(
      counterText: '',
      filled: filled,
      fillColor: fillColor,
      hintText: hintText,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      contentPadding:
          contentPadding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      hintMaxLines: 1,
      hintStyle: TextStyle(fontSize: _textFontSize(fontSize)),
      labelStyle: TextStyle(fontSize: _textFontSize(fontSize)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
        borderSide: BorderSide(color: borderColor ?? Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
        borderSide: BorderSide(color: borderColor ?? AppColor.tertiary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
        borderSide: BorderSide(color: borderColor ?? Colors.grey),
      ),
    );
  }

  static double? _textFontSize(double? fontSize) {
    if (fontSize == null) return null;
    return fontSize;
  }
}
