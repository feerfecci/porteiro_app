import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/repositories/shared_preferences.dart';
import 'package:app_porteiro/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: SizedBox(
        height: size.height * 0.9,
        child: Drawer(
          child: Column(
            children: [
              ConstsWidget.buildCustomButton(
                context,
                'Sair',
                onPressed: () {
                  LocalInfos.removeCache();
                  ConstsFuture.navigatorPushRemoveUntil(context, LoginScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
