// ignore_for_file: must_be_immutable
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';

class SeachBar extends StatelessWidget {
  SearchDelegate<String> delegate;
  String title;
  Color color;
  SeachBar(
      {required this.delegate,
      required this.title,
      required this.color,
      super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ConstsWidget.buildPadding001(
      context,
      vertical: 0,
      horizontal: 0.01,
      child: GestureDetector(
        onTap: () => showSearch(context: context, delegate: delegate),
        child: ConstsWidget.buildPadding001(
          context,
          horizontal: 0.01,
          child: Container(
            height:
                SplashScreen.isSmall ? size.height * 0.11 : size.height * 0.085,
            width: double.maxFinite,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border.all(color: color, width: size.width * 0.007),
                borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(flex: 3),
                ConstsWidget.buildTitleText(context,
                    title: title, textAlign: TextAlign.center),
                Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  child: Container(
                    height: size.height * 0.3,
                    width: size.width * 0.1,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                    ),
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: SplashScreen.isSmall ? 20 : 25,
                      fill: 1,
                    ),
                  ),
                ),
                // Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
