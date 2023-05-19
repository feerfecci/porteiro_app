import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/repositories/shared_preferences.dart';
import 'package:app_porteiro/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

import '../../consts/consts.dart';
import 'change_theme_button.dart';

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
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30))),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: size.height * 0.1,
                width: size.width * 0.85,
                child: DrawerHeader(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.02,
                    horizontal: size.width * 0.03,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                      color: Consts.kColorApp),
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              ChangeThemeButton(),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(size.height * 0.01),
                child: ConstsWidget.buildCustomButton(
                  context,
                  'Sair',
                  onPressed: () {
                    LocalInfos.removeCache();
                    ConstsFuture.navigatorPushRemoveUntil(
                        context, LoginScreen());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
