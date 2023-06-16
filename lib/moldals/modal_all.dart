import 'package:flutter/material.dart';

import '../consts/consts.dart';

Future buildModalAll(BuildContext context, {required Widget child}) {
  var size = MediaQuery.of(context).size;
  return showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      builder: (context) => SizedBox(
            height: size.height * 0.85,
            child: Scaffold(
              key: Consts.modelScaffoldKey,
              body: Padding(
                padding: EdgeInsets.all(size.height * 0.01),
                child: child,
              ),
            ),
          ));
}
