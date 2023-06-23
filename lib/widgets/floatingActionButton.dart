// ignore_for_file: file_names

import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:flutter/material.dart';
import '../consts/consts.dart';

Widget buildFloatingSearch(BuildContext context,
    {required SearchDelegate<String> searchPage}) {
  var size = MediaQuery.of(context).size;
  return SizedBox(
      height: size.height * 0.11,
      width: size.width * 0.35,
      child: MyBoxShadow(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstsWidget.buildTitleText(context, title: 'Procurar Protocolo'),
          Icon(Icons.search),
        ],
      ))

      // FloatingActionButton(
      //   isExtended: true,
      //   onPressed: () {
      //     showSearch(context: context, delegate: searchPage);
      //   },
      //   backgroundColor: Consts.kColorApp,
      //   foregroundColor: Colors.white,
      //   child: Icon(Icons.search),
      // ),
      );
}
