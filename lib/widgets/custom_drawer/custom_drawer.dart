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
        required IconData leading,
        void Function()? onPressed}) {
      return GestureDetector(
        onTap: onPressed,
        child: ConstsWidget.buildPadding001(
          context,
          child: ListTile(
            iconColor: Theme.of(context).iconTheme.color,
            leading: Icon(
              leading,
              size: 25,
            ),
            title: ConstsWidget.buildTitleText(context,
                title: title, fontSize: 16),
            trailing: Icon(
              size: 25,
              color: Theme.of(context).iconTheme.color,
              Icons.keyboard_arrow_right_outlined,
            ),
          ),
        ),
      );
    }

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
                height: SplashScreen.isSmall
                    ? size.height * 0.1
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
                    mode: LaunchMode.externalNonBrowserApplication),
              ),
              buidListTile(
                title: 'Política de privacidade',
                onPressed: () =>
                    ConstsFuture.navigatorPush(context, PoliticaScreen()),
                leading: Icons.privacy_tip_outlined,
              ),
              buidListTile(
                title: 'Termos de uso',
                leading: Icons.supervised_user_circle,
                onPressed: () =>
                    ConstsFuture.navigatorPush(context, TermoDeUsoScreen()),
              ),
              buidListTile(
                title: 'Central de Ajuda',
                leading: Icons.support,
                onPressed: () => launchUrl(
                    Uri.parse('https://www.portariaapp.com/central-de-ajuda'),
                    mode: LaunchMode.externalNonBrowserApplication),
              ),
              buidListTile(
                title: 'Indicar para amigos',
                leading: Icons.add_reaction_outlined,
                onPressed: () => launchUrl(
                    Uri.parse(
                        'https://www.portariaapp.com/indicar-para-amigos'),
                    mode: LaunchMode.externalNonBrowserApplication),
              ),
              buidListTile(
                title: 'Efetuar logoff',
                leading: Icons.logout_outlined,
                onPressed: () {
                  LocalInfos.removeCache();
                  ConstsFuture.navigatorPushRemoveUntil(context, LoginScreen());
                },
              ),
              ChangeThemeButton(),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(size.height * 0.01),
                child: ConstsWidget.buildCustomButton(
                  context,
                  'Fechar Menu',
                  color: Color.fromARGB(255, 251, 80, 93),
                  onPressed: () {
                    Navigator.pop(context);
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
