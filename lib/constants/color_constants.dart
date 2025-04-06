import 'dart:ui';

import 'package:flutter/material.dart';

class ColorConstants {
  static Color primary = fromHex("#304FFF");
  static Color headlineTextColor = fromHex("#909090");
  static Color titleTextColor = fromHex("#000000");
  static Color avatarBackgroundColor = fromHex("#EEF1FF");

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
