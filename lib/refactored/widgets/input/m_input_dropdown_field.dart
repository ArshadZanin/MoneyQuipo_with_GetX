import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_management/refactored/widgets/space/m_space.dart';
import 'package:money_management/refactored/widgets/text/m_text.dart';

import 'input_style.dart';

class MInputDropdownField<T> extends StatelessWidget {
  const MInputDropdownField({
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
    required this.items,
    this.value,
    this.contentPadding,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? label;
  final String? hintText;
  final String? disabledHint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(T?)? onChanged;
  final Function()? onTap;
  final Function(T?)? onSaved;
  final EdgeInsetsGeometry? padding;

  final Color? borderColor;
  final double? borderRadius;
  final bool readOnly;
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
  final T? value;
  final List<DropdownMenuItem<T>>? items;

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
          MSpace.vertical(10),
        ],
        DropdownButtonFormField<T>(
          items: items,
          value: value,
          onChanged: enabled ? onChanged : null,
          onTap: onTap,
          onSaved: onSaved,
          style: TextStyle(
            fontSize: fontSize,
          ),
          isExpanded: true,
          itemHeight: null,
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

DropdownMenuItem<String> buildEmptyDropdownMenu(String value) {
  return DropdownMenuItem<String>(
    enabled: false,
    value: 'No $value available.',
    child: MText(
      text: 'No $value available.',
      color: Colors.black,
    ),
  );
}
