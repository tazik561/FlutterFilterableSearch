import 'package:flutter/material.dart';

class FlutterFilterableSearchTheme {
  final TextStyle hintTextStyle;
  final EdgeInsetsGeometry contentPadding;
  final OutlineInputBorder enabledBorderStyle;
  final OutlineInputBorder focusedBorderStyle;
  final OutlineInputBorder errorBorderStyle;
  final EdgeInsetsGeometry? titlePadding;
  final TextStyle? titleStyle;
  final TextStyle? floatingLabelStyle;
  final TextStyle? labelStyle;
  final bool? backgroundFilled;
  final Color? backgroundColor;
  final double? borderRadius;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  FlutterFilterableSearchTheme({
    required this.hintTextStyle,
    required this.contentPadding,
    required this.enabledBorderStyle,
    required this.focusedBorderStyle,
    required this.errorBorderStyle,
    this.borderRadius,
    this.titlePadding,
    this.titleStyle,
    this.floatingLabelStyle,
    this.labelStyle,
    this.backgroundFilled,
    this.backgroundColor,
    this.suffixIcon,
    this.prefixIcon,
  });

  /// Default theme from Flutter's theme.
  FlutterFilterableSearchTheme.byDefault(
    BuildContext context, {
    TextStyle? hintTextStyle,
    EdgeInsetsGeometry? contentPadding,
    OutlineInputBorder? enabledBorderStyle,
    OutlineInputBorder? focusedBorderStyle,
    OutlineInputBorder? errorBorderStyle,
    EdgeInsetsGeometry? titlePadding,
    TextStyle? titleStyle,
    TextStyle? floatingLabelStyle,
    bool? backgroundFilled,
    Color? backgroundColor,
    this.borderRadius,
    this.suffixIcon,
    this.prefixIcon,
    TextStyle? labelStyle,
  })  : hintTextStyle = hintTextStyle ??
            Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.grey),
        labelStyle = labelStyle ??
            Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.black),
        floatingLabelStyle = floatingLabelStyle ??
            Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.black54),
        contentPadding = contentPadding ??
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        enabledBorderStyle = enabledBorderStyle ??
            OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius ?? 8.0),
              ),
            ),
        focusedBorderStyle = focusedBorderStyle ??
            OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius ?? 8.0),
              ),
            ),
        errorBorderStyle = errorBorderStyle ??
            OutlineInputBorder(
              borderSide: const BorderSide(
                width: 2,
                color: Colors.red,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius ?? 8.0),
              ),
            ),
        titlePadding = titlePadding ?? const EdgeInsets.only(bottom: 8.0),
        titleStyle = titleStyle ??
            Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.black54),
        backgroundFilled = backgroundFilled ?? true,
        backgroundColor = backgroundColor ?? Colors.white;
}
