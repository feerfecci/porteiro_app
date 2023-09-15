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
        dismissDirection: DismissDirection.startToEnd,
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
              children: [
                ConstsWidget.buildTitleText(context,
                    title: title, color: Colors.white),
                ConstsWidget.buildSubTitleText(context,
                    subTitle: subTitle, color: Colors.white)
              ],
            ),
          ],
        )),
  );
}
