import 'package:app_porteiro/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import '../consts/consts_widget.dart';
import 'custom_drawer/custom_drawer.dart';
import 'listview_all.dart';

// ignore: must_be_immutable
class ScaffoldAll extends StatefulWidget {
  final String? title;
  final Widget? body;
  final Widget? floatingActionButton;
  final double fontSize;
  bool resizeToAvoidBottomInset;
  bool hasDrawer;
  ScaffoldAll(
      {required this.title,
      required this.body,
      this.floatingActionButton,
      this.hasDrawer = true,
      this.resizeToAvoidBottomInset = false,
      this.fontSize = 30,
      super.key});

  @override
  State<ScaffoldAll> createState() => _ScaffoldAllState();
}

class _ScaffoldAllState extends State<ScaffoldAll> {
  @override
  Widget build(BuildContext context) {
    //var size = MediaQuery.of(context).size;
    return Scaffold(
      // floatingActionButton: widget.floatingActionButton,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      appBar: AppBar(
        centerTitle: true,
        title: ConstsWidget.buildTitleText(context,
            title: widget.title ?? '',
            maxLines: 3,
            fontSize: SplashScreen.isSmall ? 18 : 22),
        backgroundColor: Colors.transparent,
        iconTheme:
            IconThemeData(color: Theme.of(context).textTheme.bodyLarge!.color),
        elevation: 0,
      ),
      endDrawer: widget.hasDrawer ? CustomDrawer() : null,
      body: buildListViewAll(
        children: [
          widget.body!,
        ],
      ),
    );
  }
}
