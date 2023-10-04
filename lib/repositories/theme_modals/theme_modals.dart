import 'package:flutter/material.dart';

import '../../consts/consts.dart';

ThemeData themeLight(BuildContext context) {
  return ThemeData(
    snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.black, actionTextColor: Colors.white),
    shadowColor: Color.fromARGB(55, 103, 151, 255),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      unselectedItemColor: Colors.black38,
      selectedItemColor: Colors.black,
    ),
    cardColor: Colors.white,
    canvasColor: Colors.white,
    primaryIconTheme: IconThemeData(color: Colors.black),
    iconTheme: IconThemeData(color: Colors.black),
    appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
    colorScheme: ColorScheme.light(primary: Colors.black12
        // primary: Color.fromARGB(255, 69, 71, 70),
        ),
    scaffoldBackgroundColor: Consts.kBackPageColor,
    dialogBackgroundColor: Color.fromARGB(255, 245, 245, 255),
    primaryColor: Colors.white,
    textTheme: Theme.of(context)
        .textTheme
        .apply(fontSizeDelta: 1, bodyColor: Colors.black),
  );
}

ThemeData themeDark(BuildContext context) {
  return ThemeData(
    snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.white, actionTextColor: Colors.black),
    shadowColor: Color.fromARGB(19, 240, 240, 240),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      unselectedItemColor: Colors.white38,
      selectedItemColor: Colors.white,
    ),
    appBarTheme: AppBarTheme(backgroundColor: Colors.blueGrey[800]),
    canvasColor: Colors.blueGrey[900],
    cardColor: Colors.blueGrey[800],
    iconTheme: IconThemeData(color: Colors.white),
    primaryIconTheme: IconThemeData(color: Colors.white),
    colorScheme: ColorScheme.dark(
      primary: Colors.white70,
    ),
    scaffoldBackgroundColor: Colors.grey.shade900,
    dialogBackgroundColor: Colors.blueGrey[1000],
    primaryColor: Colors.blueGrey[900],
    textTheme: Theme.of(context).textTheme.apply(
          fontSizeDelta: 1,
          bodyColor: Colors.white,
        ),
  );
}
