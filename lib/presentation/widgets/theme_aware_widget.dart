import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ThemeAwareText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color Function(bool isDark)? colorFunction;

  const ThemeAwareText(
    this.text, {
    super.key,
    this.style,
    this.colorFunction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = colorFunction?.call(isDark) ?? AppColors.getTextPrimary(isDark);
    
    return Text(
      text,
      style: style?.copyWith(color: defaultColor) ?? TextStyle(color: defaultColor),
    );
  }
}

class ThemeAwareContainer extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BoxDecoration? decoration;
  final Color Function(bool isDark)? colorFunction;

  const ThemeAwareContainer({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.decoration,
    this.colorFunction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = colorFunction?.call(isDark) ?? AppColors.getSurface(isDark);
    
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: decoration?.copyWith(color: defaultColor) ?? BoxDecoration(color: defaultColor),
      child: child,
    );
  }
}