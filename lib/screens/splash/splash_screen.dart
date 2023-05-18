// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:app_porteiro/repositories/shared_preferences.dart';
import 'package:app_porteiro/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import '../../consts/consts.dart';
import '../../consts/consts_future.dart';
import '../../consts/consts_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future startLogin() async {
    LocalInfos.readCache().then((value) {
      List cacheInfos = value;
      if (cacheInfos.first != null && cacheInfos.last != null) {
        ConstsFuture.fazerLogin(context, cacheInfos.first, cacheInfos.last);
      } else {
        ConstsFuture.navigatorPushRemoveUntil(context, LoginScreen());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // NotificationWidget.init();
    Timer(Duration(seconds: 3), () {
      startLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Consts.kColorApp,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          SizedBox(
            height: size.height * 0.2,
            width: size.width * 0.6,
            child: Image.asset('assets/portaria.png'),
          ),
          // Spacer(),
          // Padding(
          //   padding: EdgeInsets.symmetric(
          //       vertical: size.height * 0.03, horizontal: size.width * 0.03),
          //   child: ConstsWidget.buildCustomButton(
          //       context, 'Autenticar Biometria', icon: Icons.lock_open_outlined,
          //       onPressed: () {
          //     startLogin();
          //   },
          //       color: Colors.white,
          //       textColor: Consts.kColorApp,
          //       iconColor: Consts.kColorApp),
          // ),
        ],
      ),
    );
  }
}
