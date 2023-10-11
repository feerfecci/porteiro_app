import 'package:app_porteiro/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import '../consts/consts.dart';
import '../consts/consts_widget.dart';

buildMinhaSnackBar(BuildContext context,
    {IconData icon = Icons.error_outline,
    String title = 'Algo deu errado',
    String subTitle = 'Tente novamente',
    bool hasError = false}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  var size = MediaQuery.of(context).size;

  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        showCloseIcon: true,
        closeIconColor: Colors.white,
        dismissDirection: DismissDirection.endToStart,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        // action: SnackBarAction(
        //     label: 'Entendi',
        //     textColor: Colors.white,
        //     onPressed: (() {
        //       try {
        //         ScaffoldMessenger.of(context).clearSnackBars();
        //       } on FlutterError catch (e) {
        //         print(e);
        //       }
        //     })),
        elevation: 8,
        duration: Duration(seconds: 4),
        backgroundColor: hasError ? Consts.kColorRed : Consts.kColorVerde,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              width: size.width * 0.02,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: SplashScreen.isSmall
                      ? size.width * 0.5
                      : size.width * 0.65,
                  child: ConstsWidget.buildTitleText(context,
                      maxLines: 5, title: title, color: Colors.white),
                ),
                SizedBox(
                  width: SplashScreen.isSmall
                      ? size.width * 0.5
                      : size.width * 0.65,
                  child: ConstsWidget.buildSubTitleText(context,
                      maxLines: 5, subTitle: subTitle, color: Colors.white),
                )
              ],
            ),
          ],
        )),
  );
}
