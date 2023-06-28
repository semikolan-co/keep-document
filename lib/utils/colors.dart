import 'package:flutter/material.dart';

class MyColors {
  static const Color primary = Color.fromRGBO(22, 68, 62, 1);
  static const Color borderColor = Color.fromRGBO(137, 137, 137, 0.5);
  static const Color textColor = Color.fromRGBO(62, 74, 89, 0.8);
  static final Map<int, Color> shades = {
    50: Color.fromRGBO(22, 68, 62, .1),
    100: Color.fromRGBO(22, 68, 62, .2),
    200: Color.fromRGBO(22, 68, 62, .3),
    300: Color.fromRGBO(22, 68, 62, .4),
    400: Color.fromRGBO(22, 68, 62, .5),
    500: Color.fromRGBO(22, 68, 62, .6),
    600: Color.fromRGBO(22, 68, 62, .7),
    700: Color.fromRGBO(22, 68, 62, .8),
    800: Color.fromRGBO(22, 68, 62, .9),
    900: Color.fromRGBO(22, 68, 62, 1),
  };

  static MaterialColor primaryShade = MaterialColor(primary.value, shades);
}
