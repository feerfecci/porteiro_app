import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/repositories/shared_preferences.dart';
import 'package:app_porteiro/screens/login/login_screen.dart';
import 'package:app_porteiro/screens/politica/politica_screen.dart';
import 'package:app_porteiro/screens/termodeuso/termo_de_uso.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../consts/consts.dart';
import '../../screens/splash/splash_screen.dart';
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

    Widget buidListTile(
        {required String title,
        IconData trailing = Icons.keyboard_arrow_right_outlined,
        required IconData leading,
        void Function()? onPressed}) {
      return ConstsWidget.buildPadding001(
        context,
        child: GestureDetector(
          onTap: onPressed,
          child: ListTile(
            iconColor: Theme.of(context).iconTheme.color,
            leading: Icon(
              leading,
              size: SplashScreen.isSmall ? 22 : 30,
            ),
            title: ConstsWidget.buildTitleText(context,
                title: title, fontSize: 16),
            trailing: Icon(
              size: SplashScreen.isSmall ? 22 : 30,
              trailing,
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: SizedBox(
        height: size.height * 0.95,
        width: size.width * 0.87,
        child: Drawer(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30))),
          child: ListView(
            // mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: SplashScreen.isSmall
                    ? size.height * 0.10
                    : size.height * 0.08,
                width: double.maxFinite,
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
              buidListTile(
                title: 'Seja um Representante',
                leading: Icons.business_center_outlined,
                onPressed: () => launchUrl(
                    Uri.parse(
                        'https://www.portariaapp.com/seja-um-representante'),
                    mode: LaunchMode.inAppWebView),
              ),
              buidListTile(
                title: 'Política de privacidade',
                onPressed: () =>
                    ConstsFuture.navigatorPush(context, PoliticaScreen()),
                leading: Icons.privacy_tip_outlined,
              ),
              buidListTile(
                title: 'Termos de uso',
                leading: Icons.assignment_outlined,
                onPressed: () =>
                    ConstsFuture.navigatorPush(context, TermoDeUsoScreen()),
              ),
              buidListTile(
                title: 'Indicar para amigos',
                leading: Icons.add_reaction_outlined,
                onPressed: () => launchUrl(
                    Uri.parse(
                        'https://www.portariaapp.com/indicar-para-amigos'),
                    mode: LaunchMode.inAppWebView),
              ),
              buidListTile(
                title: 'Central de Ajuda',
                leading: Icons.support,
                onPressed: () => launchUrl(
                    Uri.parse('https://www.portariaapp.com/central-de-ajuda'),
                    mode: LaunchMode.inAppWebView),
              ),
              buidListTile(
                title: 'Efetuar logoff',
                leading: Icons.logout_outlined,
                onPressed: () {
                  LocalInfos.removeCache();
                  ConstsFuture.navigatorPushRemoveUntil(context, LoginScreen());
                },
              ),
              ConstsWidget.buildPadding001(context, child: ChangeThemeButton()),
              // Spacer(),
              Padding(
                padding: EdgeInsets.only(
                    top: SplashScreen.isSmall
                        ? size.height * 0.01
                        : size.height * 0.16,
                    right: size.width * 0.02,
                    left: size.width * 0.02),
                child: ConstsWidget.buildOutlinedButton(
                  context, title: 'Fechar Menu',
                  // icon: Icons.logout_outlined,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
