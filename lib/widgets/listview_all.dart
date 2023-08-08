import 'package:flutter/material.dart';

Widget buildListViewAll({required List<Widget> children}) {
  return NotificationListener<OverscrollIndicatorNotification>(
    onNotification: (overscroll) {
      overscroll.disallowIndicator();
      return false;
    },
    child: ListView(
      children: children,
    ),
  );
}
