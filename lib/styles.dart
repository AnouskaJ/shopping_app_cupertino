import 'package:flutter/cupertino.dart';

abstract class Styles {
  static const TextStyle productRowItemName = TextStyle(
    color: Color.fromRGBO(61, 59, 59, 0.8),
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle productRowTotal = TextStyle(
    color: Color.fromRGBO(47, 46, 46, 0.8),
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle productRowItemPrice = TextStyle(
    color: Color(0xFF8E8E93),
    fontSize: 13,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle searchText = TextStyle(
    color: Color.fromRGBO(40, 39, 39, 1.0),
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle deliveryTimeLabel = TextStyle(
    color: Color(0xFFC2C2C2),
    fontWeight: FontWeight.w300,
  );

  static const TextStyle deliveryTime = TextStyle(
    color: CupertinoColors.inactiveGray,
  );

  static const Color productRowDivider = Color(0xFFD9D9D9);

  static const Color scaffoldBackground = Color(0xffefd5d5);

  static const Color searchBackground = Color(0xffdcbbbb);

  static const Color searchCursorColor = Color.fromRGBO(59, 84, 211, 1.0);

  static const Color searchIconColor = Color.fromRGBO(128, 128, 128, 1);
}