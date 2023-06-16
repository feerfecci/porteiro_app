// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../consts/consts.dart';

Widget buildFloatingSearch(BuildContext context,
    {required SearchDelegate<String> searchPage}) {
  var size = MediaQuery.of(context).size;
  return SizedBox(
    height: size.height * 0.1,
    width: size.width * 0.15,
    child: FloatingActionButton(
      isExtended: true,
      onPressed: () {
        showSearch(context: context, delegate: searchPage);
      },
      backgroundColor: Consts.kColorApp,
      foregroundColor: Colors.white,
      child: Icon(Icons.search),
    ),
  );
}
