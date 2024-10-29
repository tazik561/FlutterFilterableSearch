import 'package:flutter/material.dart';

/// Theme for FilterChip customization.
class FlutterFilterChipTheme {
  final Color? selectedColor;
  final Color? disabledColor;
  final Color? backgroundColor;
  final Color? checkmarkColor;
  final Color? deleteIconColor;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? labelPadding;
  final OutlinedBorder? shape;
  final double? elevation;
  final double? pressElevation;
  final bool? showCheckmark;

  FlutterFilterChipTheme({
    this.selectedColor,
    this.disabledColor,
    this.backgroundColor,
    this.checkmarkColor,
    this.deleteIconColor,
    this.labelStyle,
    this.padding,
    this.labelPadding,
    this.shape,
    this.elevation,
    this.pressElevation,
    this.showCheckmark,
  });

  /// Constructor with optional customizations and defaults from context.
  FlutterFilterChipTheme.byDefault(
    BuildContext context, {
    Color? selectedColor,
    Color? disabledColor,
    Color? backgroundColor,
    Color? checkmarkColor,
    Color? deleteIconColor,
    TextStyle? labelStyle,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? labelPadding,
    OutlinedBorder? shape,
    double? elevation,
    double? pressElevation,
    bool? showCheckmark,
  })  : labelStyle = labelStyle ?? Theme.of(context).chipTheme.labelStyle,
        padding = padding ?? Theme.of(context).chipTheme.padding,
        labelPadding = labelPadding ?? Theme.of(context).chipTheme.labelPadding,
        shape = shape ?? Theme.of(context).chipTheme.shape,
        elevation = elevation ?? Theme.of(context).chipTheme.elevation,
        pressElevation =
            pressElevation ?? Theme.of(context).chipTheme.pressElevation,
        showCheckmark =
            showCheckmark ?? Theme.of(context).chipTheme.showCheckmark,
        selectedColor =
            selectedColor ?? Theme.of(context).chipTheme.selectedColor,
        disabledColor =
            disabledColor ?? Theme.of(context).chipTheme.disabledColor,
        backgroundColor =
            backgroundColor ?? Theme.of(context).chipTheme.backgroundColor,
        checkmarkColor =
            checkmarkColor ?? Theme.of(context).chipTheme.checkmarkColor,
        deleteIconColor =
            deleteIconColor ?? Theme.of(context).chipTheme.deleteIconColor;
}
