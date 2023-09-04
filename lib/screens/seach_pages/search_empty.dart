import 'package:flutter/material.dart';

import '../../consts/consts_widget.dart';

Widget buildNoQuerySearch(BuildContext context, {required String mesagem}) {
  var size = MediaQuery.of(context).size;
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
              color: Theme.of(context).colorScheme.primary,
              height: 1.5,
              fontSize: 18),
        ),
      ],
    ),
  );
}
