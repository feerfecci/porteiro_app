import 'package:flutter/material.dart';

class ConstsResponsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;

  final Widget? desktop;

  const ConstsResponsive(
      {super.key, required this.mobile, required this.tablet, this.desktop});

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 850;

  static bool isWeb(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (size.width >= 1100 && desktop != null) {
      return desktop!;
    } else if (size.width >= 850) {
      return tablet;
    } else {
      return mobile;
    }
  }
}
