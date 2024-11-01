import 'package:flutter/material.dart';

class GetPosition {
  final GlobalKey? key;
  final BuildContext? widgetContext;
  final EdgeInsets padding;
  final double? screenWidth;
  final double? screenHeight;

  GetPosition(
      {this.key,
      this.widgetContext,
      this.padding = EdgeInsets.zero,
      this.screenWidth,
      this.screenHeight});

  RenderBox get box {
    if (widgetContext != null) {
      return widgetContext!.findRenderObject() as RenderBox;
    }
    return key!.currentContext!.findRenderObject() as RenderBox;
  }

  Rect getRect() {
    var boxOffset = box.localToGlobal(const Offset(0.0, 0.0));
    if (boxOffset.dx.isNaN || boxOffset.dy.isNaN) {
      return const Rect.fromLTRB(0, 0, 0, 0);
    }
    final topLeft = box.size.topLeft(boxOffset);
    final bottomRight = box.size.bottomRight(boxOffset);

    final rect = Rect.fromLTRB(
      topLeft.dx - padding.left < 0 ? 0 : topLeft.dx - padding.left,
      topLeft.dy - padding.top < 0 ? 0 : topLeft.dy - padding.top,
      bottomRight.dx + padding.right > screenWidth!
          ? screenWidth!
          : bottomRight.dx + padding.right,
      bottomRight.dy + padding.bottom > screenHeight!
          ? screenHeight!
          : bottomRight.dy + padding.bottom,
    );
    return rect;
  }

  ///Get the bottom position of the widget
  double getBottom() {
    final boxOffset = box.localToGlobal(const Offset(0.0, 0.0));
    if (boxOffset.dy.isNaN) return padding.bottom;
    final bottomRight = box.size.bottomRight(boxOffset);
    return bottomRight.dy + padding.bottom;
  }

  ///Get the top position of the widget
  double getTop() {
    final boxOffset = box.localToGlobal(const Offset(0.0, 0.0));
    if (boxOffset.dy.isNaN) return 0 - padding.top;
    final topLeft = box.size.topLeft(boxOffset);
    return topLeft.dy - padding.top;
  }

  ///Get the left position of the widget
  double getLeft() {
    final boxOffset = box.localToGlobal(const Offset(0.0, 0.0));
    if (boxOffset.dx.isNaN) return 0 - padding.left;
    final topLeft = box.size.topLeft(boxOffset);
    return topLeft.dx - padding.left;
  }

  ///Get the right position of the widget
  double getRight() {
    final boxOffset = box.localToGlobal(Offset.zero);
    if (boxOffset.dx.isNaN) return padding.right;
    final bottomRight =
        box.size.bottomRight(box.localToGlobal(const Offset(0.0, 0.0)));
    return bottomRight.dx + padding.right;
  }

  double getHeight() {
    return getBottom() - getTop();
  }

  double getWidth() {
    return getRight() - getLeft();
  }

  double getCenter() {
    return (getLeft() + getRight()) / 2;
  }
}
