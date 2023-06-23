import 'package:flutter/material.dart';

class MyBoxShadow extends StatefulWidget {
  final dynamic child;
  final double paddingAll;
  final Color? color;
  const MyBoxShadow({
    required this.child,
    this.color,
    // required this.paddingAll,
    super.key,
    this.paddingAll = 0.02,
  });

  @override
  State<MyBoxShadow> createState() => MyBoxShadowState();
}

class MyBoxShadowState extends State<MyBoxShadow> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(size.height * 0.005),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            boxShadow: [
              widget.color == null
                  ? BoxShadow(
                      color: Theme.of(context).shadowColor,
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: Offset(5, 5), // changes position of shadow
                    )
                  : BoxShadow(),
            ],
            border: Border.all(color: Theme.of(context).shadowColor),
            borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(size.width * widget.paddingAll),
          child: widget.child,
        ),
      ),
    );
  }
}
