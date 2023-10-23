import 'package:flutter/material.dart';
import 'package:money_management/refactored/constants/app_colors.dart';
import 'package:money_management/refactored/widgets/container/m_container.dart';
import 'package:money_management/refactored/widgets/text/m_text.dart';

class MButton extends StatelessWidget {
  const MButton({
    Key? key,
    required this.onPress,
    required this.text,
    this.padding,
    this.backgroundColor,
    this.overlayColor,
    this.borderRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height,
    this.elevation,
    this.spacing,
    this.fontSize = 18,
    this.border,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment = MainAxisAlignment.start,
  }) : super(key: key);

  final Function()? onPress;
  final String text;
  final Color? backgroundColor;
  final Color? overlayColor;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? width;
  final double? height;
  final double? elevation;
  final double fontSize;
  final double? spacing;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return MContainer(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(borderRadius ?? 10),
      border: border,
      child: ElevatedButton(
        style: ButtonStyle(
          elevation:
              elevation == null ? null : MaterialStateProperty.all(elevation),
          backgroundColor:
              MaterialStateProperty.all(backgroundColor ?? AppColor.blueButton),
          padding: MaterialStateProperty.all(padding ?? EdgeInsets.zero),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 10),
            ),
          ),
        ),
        onPressed: onPress,
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing ?? 5.0),
              child: prefixIcon ?? const Offstage(),
            ),
            MText(
              textAlign: TextAlign.center,
              text: text,
              fontSize: fontSize,
              color: overlayColor,
              fontWeight: FontWeight.w600,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing ?? 5.0),
              child: suffixIcon ?? const Offstage(),
            ),
          ],
        ),
      ),
    );
  }
}
