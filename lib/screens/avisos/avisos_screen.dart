import 'package:app_porteiro/consts/consts.dart';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:flutter/material.dart';

class AvisosScreen extends StatefulWidget {
  const AvisosScreen({super.key});

  @override
  State<AvisosScreen> createState() => _AvisosScreenState();
}

class _AvisosScreenState extends State<AvisosScreen> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: ScaffoldAll(
          title: 'Histórico de Avisos',
          isDrawer: true,
          fontSize: 26,
          body: Column(
            children: [
              ConstsWidget.buildPadding001(
                context,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ConstsWidget.buildOutlinedButton(
                      context,
                      title: 'Enviados',
                      fontSize: 18,
                      icon: Icons.mobile_friendly_sharp,
                      onPressed: () {},
                    ),
                    ConstsWidget.buildCustomButton(
                      context,
                      'Recebidos',
                      fontSize: 18,
                      icon: Icons.install_mobile_rounded,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return MyBoxShadow(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ConstsWidget.buildTitleText(context,
                          title: 'AP01 - Torre 2'),
                      ConstsWidget.buildPadding001(
                        context,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstsWidget.buildSubTitleText(
                                  context,
                                  subTitle: 'Mensagem:',
                                ),
                                ConstsWidget.buildTitleText(context,
                                    title: 'Estou indo buscar!')
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstsWidget.buildSubTitleText(
                                  context,
                                  subTitle: 'Recebido em:',
                                ),
                                ConstsWidget.buildTitleText(context,
                                    title: '10/07 - 13:50'),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ));
                },
              ),
            ],
          )),
    );
  }
}
