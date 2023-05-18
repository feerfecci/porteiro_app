import 'package:flutter/material.dart';

import '../consts/consts.dart';
import '../consts/consts_widget.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05, vertical: size.height * 0.025),
        child:
            ConstsWidget.buildTextFormField(label: 'Pesquise um apartamento'));
  }
}
