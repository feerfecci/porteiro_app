import 'package:flutter/material.dart';

import '../consts/consts_widget.dart';
import 'custom_drawer/custom_drawer.dart';

class ScaffoldAll extends StatefulWidget {
  final String? title;
  final Widget? body;
  final Widget? floatingActionButton;
  bool isDrawer;
  ScaffoldAll(
      {required this.title,
      required this.body,
      this.floatingActionButton,
      this.isDrawer = false,
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: ConstsWidget.buildTitleText(context,
            title: widget.title, fontSize: 30),
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
