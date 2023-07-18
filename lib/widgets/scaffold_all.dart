import 'package:flutter/material.dart';

import '../consts/consts_widget.dart';
import 'custom_drawer/custom_drawer.dart';

// ignore: must_be_immutable
class ScaffoldAll extends StatefulWidget {
  final String? title;
  final Widget? body;
  final Widget? floatingActionButton;
  final double fontSize;
  bool resizeToAvoidBottomInset;
  bool isDrawer;
  ScaffoldAll(
      {required this.title,
      required this.body,
      this.floatingActionButton,
      this.isDrawer = false,
      this.resizeToAvoidBottomInset = false,
      this.fontSize = 30,
      super.key});

  @override
  State<ScaffoldAll> createState() => _ScaffoldAllState();
}

class _ScaffoldAllState extends State<ScaffoldAll> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      // floatingActionButton: widget.floatingActionButton,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      appBar: AppBar(
        centerTitle: true,
        title: ConstsWidget.buildTitleText(context,
            title: widget.title, fontSize: widget.fontSize),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        elevation: 0,
      ),
      endDrawer: widget.isDrawer ? CustomDrawer() : null,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
        child: widget.body,
      ),
    );
  }
}
