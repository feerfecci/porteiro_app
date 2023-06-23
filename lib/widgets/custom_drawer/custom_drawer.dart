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
                height: size.height * 0.08,
                width: size.width * 0.85,
                child: DrawerHeader(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.02,
                    horizontal: size.width * 0.03,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                      ),
                      color: Consts.kColorApp),
                  child: Text(
                    'Menu',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Column(
              //   children: [
              //     ConstsWidget.buildTitleText(context,
              //         title: FuncionarioInfos.nome_funcionario!),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         ConstsWidget.buildSubTitleText(context,
              //             subTitle: FuncionarioInfos.login!),
              //         ConstsWidget.buildAtivoInativo(
              //             context, FuncionarioInfos.ativo!)
              //       ],
              //     ),
              //   ],
              // ),
              ListTile(
                leading: Icon(
                  Icons.business_center_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: ConstsWidget.buildTitleText(
                  context,
                  title: 'Seja um Representante',
                ),
                onTap: () {},
                trailing: Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.privacy_tip_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: ConstsWidget.buildTitleText(
                  context,
                  title: 'Política de privacidade',
                ),
                onTap: () {},
                trailing: Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.phone_forwarded_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: ConstsWidget.buildTitleText(
                  context,
                  title: 'Suporte',
                ),
                onTap: () {},
                trailing: Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
              ),
              ChangeThemeButton(),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(size.height * 0.01),
                child: ConstsWidget.buildCustomButton(
                  context,
                  'Sair',
                  color: Color.fromARGB(255, 251, 80, 93),
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
