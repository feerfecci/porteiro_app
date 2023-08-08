import 'package:flutter/material.dart';

import '../../consts/consts_widget.dart';

Widget buildNoQuerySearch(BuildContext context, {required String mesagem}) {
  return Center(
    child: ConstsWidget.buildTitleText(context, title: mesagem),
  );
}
