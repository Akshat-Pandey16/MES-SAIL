// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color blue900 = fromHex('#1c43ab');

  static Color blueGray400 = fromHex('#888888');

  static Color blue500 = fromHex('#128dff');

  static Color gray800 = fromHex('#454545');

  static Color gray80001 = fromHex('#3c3c3c');

  static Color black9003f = fromHex('#3f000000');

  static Color blue50 = fromHex('#d7e2ff');

  static Color gray100 = fromHex('#eff2ff');

  static Color lightblue50 = fromHex('#9ED0FF');

  static Color blue50001 = fromHex('#1790ff');

  static Color blue50002 = fromHex('#168fff');

  static Color black90072 = fromHex('#72000000');

  static Color black900 = fromHex('#000000');

  static Color gray10001 = fromHex('#eff3ff');

  static Color blue5001 = fromHex('#d8ecff');

  static Color indigo900 = fromHex('#162959');

  static Color blue100 = fromHex('#c7ddff');

  static Color blue200 = fromHex('#9dd0ff');

  static Color whiteA700 = fromHex('#ffffff');

  static Color indigo500 = fromHex('#3560cc');

  static var txtFillBlue900;

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
