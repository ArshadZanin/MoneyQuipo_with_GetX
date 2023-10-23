import 'package:flutter/material.dart';

class MContainer extends StatelessWidget {
  const MContainer({
    Key? key,
    this.color,
    this.width,
    this.height,
    this.child,
    this.borderRadius,
    this.alignment,
    this.padding,
    this.margin,
    this.shadowOffset,
    this.elevation,
    this.shadowColor,
    this.constraints,
    this.shape = BoxShape.rectangle,
    this.gradient,
    this.border,
    this.image,
  }) : super(key: key);

  final Color? color;
  final double? width;
  final double? height;
  final Widget? child;
  final BorderRadius? borderRadius;
  final Alignment? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Offset? shadowOffset;
  final Color? shadowColor;
  final double? elevation;
  final BoxShape shape;
  final BoxBorder? border;
  final Gradient? gradient;
  final BoxConstraints? constraints;
  final DecorationImage? image;

  @override
  Widget build(BuildContext context) {
      return Container(
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        alignment: alignment,
        constraints: constraints,
        decoration: BoxDecoration(
          image: image,
          color: color,
          borderRadius: borderRadius,
          border: border,
          gradient: gradient,
          shape: shape,
          boxShadow: [
            if (elevation != null)
              BoxShadow(
                color: shadowColor ?? Colors.grey.shade400,
                offset: shadowOffset ?? Offset.zero,
                blurRadius: 2,
              )
          ],
        ),
        child: child,
      );
  }
}
