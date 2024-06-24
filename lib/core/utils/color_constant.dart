import 'package:flutter/material.dart';

class ColorConstant{
  
  static Color red700 = fromHex('#d9282e');
  static Color white=Colors.white;
  static Color lightWhiteGrey=Color.fromARGB(255, 219, 206, 206);
  static Color black=Colors.black;
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}