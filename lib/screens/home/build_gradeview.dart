import 'package:flutter/material.dart';

import '../../consts/consts_widget.dart';
import '../splash/splash_screen.dart';

Widget buildGridViewer(BuildContext context, {required List<Widget> children}) {
  return ConstsWidget.buildPadding001(
    context,
    vertical: 0,
    horizontal: SplashScreen.isSmall ? 0.015 : 0.005,
    child: GridView.count(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        crossAxisSpacing: 5,
        mainAxisSpacing: SplashScreen.isSmall ? 0.2 : 0.1,
        crossAxisCount: 2,
        childAspectRatio: SplashScreen.isSmall ? 1.7 : 1.54,
        children: children),
  );
}
