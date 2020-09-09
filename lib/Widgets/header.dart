import 'package:flutter/material.dart';
import 'package:vitapp/constants.dart';

header(
  context, {
  bool isAppTitle = false,
  String titleText,
  removeBack = false,
  isCenterTitle = false,
  isLogout = false,
  bold = false,
}) {
  return AppBar(
      title: Text(
        isAppTitle ? 'VIT' : titleText,
        style: TextStyle(
            fontSize: isAppTitle ? 30 : 22,
            color: Colors.white,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal),
      ),
      backgroundColor: kPrimaryColor,
      centerTitle: isCenterTitle);
}
