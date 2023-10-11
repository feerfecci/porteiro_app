import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

import '../../consts/consts.dart';
import '../../consts/consts_widget.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/snack_bar.dart';
import '../quadro_avisos/quadro_avisos.dart';
import '../splash/splash_screen.dart';
import 'home_page.dart';

Widget buildCard(
  BuildContext context, {
  required String title,
  required String iconApi,
  bool avisa = true,
  bool isWhatss = false,
  bool isSearchVeiculo = false,
  bool idEspacos = false,
  void Function()? onTap,
}) {
  var size = MediaQuery.of(context).size;
  double iconQuadrado =
      SplashScreen.isSmall ? size.width * 0.12 : size.width * 0.138;

  return GestureDetector(
    onTap: avisa
        ? onTap
        : () {
            buildMinhaSnackBar(context,
                title: 'Desculpe',
                hasError: true,
                subTitle: 'Você não tem acesso à essa ação');
          },
    child: MyBoxShadow(
        paddingAll: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(
              flex: 2,
            ),
            SizedBox(
              height: size.height * 0.005,
            ),
            ConstsWidget.buildBadge(
              context,
              // QuadroHistoricoNotificScreen.qntAvisos.isNotEmpty,

              showBadge: title == 'Quadro de Avisos' &&
                      QuadroHistoricoNotificScreen.qntAvisos.isNotEmpty
                  ? true
                  : idEspacos
                      ? HomePage.qntEventos != 0
                      : false,
              title: title == 'Quadro de Avisos'
                  ? QuadroHistoricoNotificScreen.qntAvisos.length
                  : HomePage.qntEventos,
              position: badges.BadgePosition.topEnd(
                  top: SplashScreen.isSmall ? -9 : -15,
                  end: SplashScreen.isSmall ? -45 : -55),

              child: ConstsWidget.buildCachedImage(context,
                  iconApi: '${Consts.iconApiPort}$iconApi',
                  height: iconQuadrado,
                  width: iconQuadrado,
                  iconQuadrado: true),
            ),
            Spacer(),
            ConstsWidget.buildTitleText(context, title: title, fontSize: 16),
            SizedBox(
              height: size.height * 0.01,
            ),
            Spacer(),
          ],
        )),
  );
}
