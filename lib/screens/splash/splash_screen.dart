// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:io';
import 'package:app_porteiro/repositories/biometrics.dart';
import 'package:app_porteiro/repositories/shared_preferences.dart';
import 'package:app_porteiro/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import '../../consts/consts_future.dart';
import '../../consts/consts_widget.dart';

class SplashScreen extends StatefulWidget {
  static bool isSmall = false;
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool load = false;
  Future startLogin() async {
    await LocalInfos.readCache().then((value) async {
      List cacheInfos = value;
      if (cacheInfos.first != null && cacheInfos.last != null) {
        final auth = await LocalBiometrics.authenticate();
        final hasBiometrics = await LocalBiometrics.hasBiometric();
        setState(() {
          load = true;
        });
        if (hasBiometrics) {
          if (auth) {
            return ConstsFuture.fazerLogin(
                context, cacheInfos.first, cacheInfos.last);
          }
        } else {
          return ConstsFuture.fazerLogin(
              context, cacheInfos.first, cacheInfos.last);
        }
      } else {
        return ConstsFuture.navigatorPushRemoveUntil(context, LoginScreen());
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
    SplashScreen.isSmall = size.width <= 350
        ? true
        : Platform.isIOS
            ? true
            : false;
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          SizedBox(
            height: size.height * 0.2,
            width: size.width * 0.6,
            child: Image.network(
              'https://a.portariaapp.com/img/logo_vermelho.png',
            ),
          ),
          Spacer(),
          Row(),
          if (load)
            ConstsWidget.buildPadding001(
              context,
              vertical: 0.03,
              horizontal: 0.03,
              child: ConstsWidget.buildCustomButton(
                context,
                'Autenticar Biometria',
                icon: Icons.lock_open_outlined,
                onPressed: () {
                  startLogin();
                },
              ),
            )
        ],
      ),
    );
  }
}
