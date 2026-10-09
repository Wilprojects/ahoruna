import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> lightSmall = [
    BoxShadow(color: Color(0x141C203A), blurRadius: 24, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> darkSmall = [
    BoxShadow(color: Color(0x47000000), blurRadius: 24, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> primary = [
    BoxShadow(color: Color(0x4D5B5CF0), blurRadius: 42, offset: Offset(0, 20)),
  ];

  static List<BoxShadow> small(Brightness brightness) {
    return brightness == Brightness.dark ? darkSmall : lightSmall;
  }
}
