import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:flutter/material.dart';

import '../consts/consts.dart';

Future buildModalAll(BuildContext context,
    {required Widget child, required String title, bool? isDrawer}) {
  var size = MediaQuery.of(context).size;
  return showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      builder: (context) => SizedBox(
            height: size.height * 0.85,
            child: ScaffoldAll(
              title: title,
              isDrawer: isDrawer ?? true,
              key: Consts.modelScaffoldKey,
              body: Padding(
                padding: EdgeInsets.all(size.height * 0.01),
                child: child,
              ),
            ),
          ));
}
