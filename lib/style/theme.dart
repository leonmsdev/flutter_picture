import 'package:flutter/material.dart';
import 'package:learn_dart/style/colors.dart';

ThemeData appThemeData() {
  return ThemeData(
      primarySwatch: LigthColorPalette().ligthThemeColor,
      buttonTheme: ButtonThemeData(
        buttonColor: LigthColorPalette().ligthThemeColor,
      ));
}
