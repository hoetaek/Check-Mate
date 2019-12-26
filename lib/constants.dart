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
}
