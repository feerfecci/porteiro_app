import 'package:flutter/material.dart';

import '../../consts/consts_widget.dart';

Widget buildNoQuerySearch(BuildContext context, {required String mesagem}) {
  // var size = MediaQuery.of(context).size;
  return ConstsWidget.buildPadding001(
    context,
    vertical: 0.02,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          mesagem,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge!.color,
              height: 1.5,
              fontSize: 18),
        ),
      ],
    ),
  );
}

Widget buildNoQuerySearchVermelho(BuildContext context,
    {required String mensagem1, String? mensagemVermelho, String? mensagem2}) {
  // var size = MediaQuery.of(context).size;
  return ConstsWidget.buildPadding001(context,
      vertical: 0.02,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                  text: mensagem1,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: 18),
                ),
                TextSpan(
                  text: mensagemVermelho,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 20),
                ),
                TextSpan(
                  text: mensagem2,
                  style: TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: 18),
                ),
              ])),
        ],
      ));
}
