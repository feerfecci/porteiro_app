import 'package:flutter/material.dart';

showAllDialog(BuildContext context,
    {Widget? title, required List<Widget> children}) {
  var size = MediaQuery.of(context).size;
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        insetPadding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05, vertical: size.height * 0.05),
        title: title,
        content: SizedBox(
          width: size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      );
    },
  );
}
