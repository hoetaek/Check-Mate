import 'package:flutter/material.dart';

const kTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: kLightMainColor,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
    borderSide: BorderSide(color: kLightMainColor),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
    borderSide: BorderSide(color: kMainColor),
  ),
);

const kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 18.0,
  fontWeight: FontWeight.w700,
);

const kButtonShapeStyle = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)));

const kMainColor = Color(0xFFCE93D8);
const kEmphasisMainColor = Color(0xFF7B1FA2);
const kLightMainColor = Color.fromRGBO(246, 241, 248, 1);
const kTilePadding = 7.0;
const kTitleTilePadding = 5.0;

class Boxes {
  static String todoItemBox = 'todo_item';
  static String recordsBox = 'record';
}

final List<Color> kColors = <Color>[
  Color(0xFFF44336),
  Color(0xFFE91E63),
  Color(0xFF9C27B0),
  Color(0xFF673AB7),
  Color(0xFF3F51B5),
  Color(0xFF2196F3),
  Color(0xFF03A9F4),
  Color(0xFF00BCD4),
  Color(0xFF009688),
  Color(0xFF4CAF50),
  Color(0xFF8BC34A),
  Color(0xFFCDDC39),
  Color(0xFFFFEB3B),
  Color(0xFFFFC107),
  Color(0xFFFF9800),
  Color(0xFFFF5722),
  Color(0xFF795548),
  Color(0xFF607D8B),
];
