import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_management/refactored/widgets/space/m_space.dart';
import 'package:money_management/refactored/widgets/text/m_text.dart';

import 'input_style.dart';

class MInputTextField extends StatelessWidget {
  const MInputTextField({
    Key? key,
    this.hintText,
    this.label,
    this.disabledHint,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSaved,
    this.onTap,
    this.readOnly = false,
    this.obscureText = false,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.height,
    this.width,
    this.controller,
    this.filled = false,
    this.fillColor,
    this.enabled = true,
    this.fontSize = 18,
    this.inputFormatters,
    this.keyboardType,
    this.isRequired = false,
    this.validator,
    this.contentPadding,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplete,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? label;
  final String? hintText;
  final String? disabledHint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Function(String?)? onSaved;
  final bool readOnly;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final EdgeInsetsGeometry? padding;

  final Color? borderColor;
  final double? borderRadius;

  final double? height;
  final double? width;
  final bool filled;
  final Color? fillColor;
  final bool enabled;
  final double fontSize;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool isRequired;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function()? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MText(
                    text: label ?? '',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  if (isRequired)
                    const MText(
                      text: '*',
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                ],
              ),
              if (!enabled && disabledHint != '') ...[
                MSpace.vertical(5),
                MText(
                  text: disabledHint ?? 'Information cannot be changed',
                  fontSize: 12,
                  color: Colors.red.shade300,
                  fontWeight: FontWeight.bold,
                ),
              ]
            ],
          ),
          MSpace.vertical(5),
        ],
        TextFormField(
          focusNode: focusNode,
          validator: (value) {
            if (isRequired && (value?.isEmpty ?? true)) {
              return 'This field is required';
            }
            if (validator != null) {
              return validator!(value);
            }

            return null;
          },
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          enabled: enabled,
          controller: controller,
          onChanged: onChanged,
          onSaved: onSaved,
          onTap: onTap,
          onEditingComplete: onEditingComplete,
          readOnly: readOnly,
          obscureText: obscureText,
          maxLength: maxLength,
          maxLines: maxLines ?? 1,
          minLines: minLines,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: fontSize,
          ),
          decoration: InputStyle.getInputDecoration(
            filled: filled,
            fillColor: fillColor,
            hintText: hintText,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            contentPadding: contentPadding,
            fontSize: fontSize,
            borderRadius: borderRadius,
            borderColor: borderColor,
          ),
        ),
      ],
    );
  }
}

class Debouncer {
  final int milliseconds;

  Timer? _timer;

  Debouncer({this.milliseconds = 500});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
