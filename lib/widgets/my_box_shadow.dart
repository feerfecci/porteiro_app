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
      padding: EdgeInsets.all(size.height * 0.01),
      child: Container(
        decoration: BoxDecoration(
            color: widget.color ?? Theme.of(context).primaryColor,
            boxShadow: [
              widget.color == null
                  ? BoxShadow(
                      color: Theme.of(context).shadowColor,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(2, 2), // changes position of shadow
                    )
                  : BoxShadow(),
            ],
            // border: Border.all(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(size.width * widget.paddingAll),
          child: widget.child,
        ),
      ),
    );
  }
}
