import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:flutter/material.dart';

class PageVazia extends StatefulWidget {
  final String title;
  const PageVazia({required this.title, super.key});

  @override
  State<PageVazia> createState() => _PageVaziaState();
}

class _PageVaziaState extends State<PageVazia> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network('https://a.portariaapp.com/img/img.png'),
        ConstsWidget.buildTitleText(context, title: widget.title)
      ],
    );
  }
}
