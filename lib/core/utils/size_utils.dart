
// ignore_for_file: deprecated_member_use, constant_identifier_names

import 'package:flutter/material.dart';

Size size = WidgetsBinding.instance.window.physicalSize /
    WidgetsBinding.instance.window.devicePixelRatio;

const num WIDTH = 360;
const num HEIGHT = 800;
const num STATUS_BAR = 0;

double get width {
  return size.width;
}

double get height {
  var mediaQueryData = MediaQueryData.fromView(WidgetsBinding.instance.window);
  var statusBar = mediaQueryData.padding.top;
  var bottomBar = mediaQueryData.padding.bottom;
  var screenHeight = size.height - statusBar - bottomBar;
  return screenHeight;
}

double getHorizontalSize(double px) {
  return ((px * width) / WIDTH);
}

double getVerticalSize(double px) {
  return ((px * height) / (HEIGHT - STATUS_BAR));
}

double getSize(double px) {
  var height = getVerticalSize(px);
  var width = getHorizontalSize(px);
  if (height < width) {
    return height.toInt().toDouble();
  } else {
    return width.toInt().toDouble();
  }
}

double getFontSize(double px) {
  return getSize(px);
}

EdgeInsetsGeometry getPadding({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  return getMarginOrPadding(
    all: all,
    left: left,
    top: top,
    right: right,
    bottom: bottom,
  );
}

EdgeInsetsGeometry getMargin({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  return getMarginOrPadding(
    all: all,
    left: left,
    top: top,
    right: right,
    bottom: bottom,
  );
}

EdgeInsetsGeometry getMarginOrPadding({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  if (all != null) {
    left = all;
    top = all;
    right = all;
    bottom = all;
  }
  return EdgeInsets.only(
    left: getHorizontalSize(left ?? 0),
    top: getVerticalSize(top ?? 0),
    right: getHorizontalSize(right ?? 0),
    bottom: getVerticalSize(bottom ?? 0),
  );
}
