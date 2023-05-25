import 'package:flutter/material.dart';

import '../consts/consts_widget.dart';
import 'custom_drawer/custom_drawer.dart';

class ScaffoldAll extends StatefulWidget {
  final String? title;
  final Widget? body;
  const ScaffoldAll({required this.title, required this.body, super.key});

  @override
  State<ScaffoldAll> createState() => _ScaffoldAllState();
}

class _ScaffoldAllState extends State<ScaffoldAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ConstsWidget.buildTitleText(context, title: widget.title),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        elevation: 0,
      ),
      endDrawer: CustomDrawer(),
      body: widget.body,
    );
  }
}
