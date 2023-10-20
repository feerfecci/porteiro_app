// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:app_porteiro/screens/correspondencias/add/caixas/encomendas_screen.dart';
import 'package:app_porteiro/screens/correspondencias/add/multicartas_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../consts/consts.dart';
import '../../consts/consts_future.dart';
import '../../consts/consts_widget.dart';
import '../../widgets/alertdialog_all.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/page_erro.dart';
import '../../widgets/page_vazia.dart';
import '../../widgets/shimmer_widget.dart';
import '../splash/splash_screen.dart';

alertInformeSindico(BuildContext context) {
  var size = MediaQuery.of(context).size;
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          insetPadding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05, vertical: size.height * 0.05),
          title: Stack(
            alignment: Alignment.center,
            children: [
              ConstsWidget.buildTitleText(context,
                  textAlign: TextAlign.center,
                  title: 'Escolha um Contato',
                  fontSize: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close))
                ],
              ),
            ],
          ),
          content: SizedBox(
            width: size.width * 0.98,
            // height:
            //     SplashScreen.isSmall ? double.maxFinite : double.minPositive,
            child: FutureBuilder<dynamic>(
                future: ConstsFuture.launchGetApi(
                    'contato_sindicos/?fn=telefonesSindicos&idcond=${FuncionarioInfos.idcondominio}'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      itemCount: 1,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return MyBoxShadow(
                            child: Column(
                          children: const [ShimmerWidget(height: 40)],
                        ));
                      },
                    );
                  } else if (snapshot.hasData) {
                    if (!snapshot.data['erro']) {
                      return ListView.builder(
                        itemCount: 5,
                        // snapshot.data['telefonesSindicos'].length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var apiContatos =
                              snapshot.data['telefonesSindicos'][index];
                          var idfuncionario = apiContatos['idfuncionario'];
                          var idcond = apiContatos['idcond'];
                          var nome_funcionario =
                              apiContatos['nome_funcionario'];
                          var telefone = apiContatos['telefone'];
                          var whatsapp = apiContatos['whatsapp'];
                          return ConstsWidget.buildPadding001(
                            context,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    width: 1,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              child: ConstsWidget.buildPadding001(
                                context,
                                horizontal: 0.02,
                                vertical: 0.01,
                                child: Row(
                                  children: [
                                    ConstsWidget.buildTitleText(context,
                                        sizedWidth:
                                            SplashScreen.isSmall ? 0.35 : 0.45,
                                        fontSize: 16,
                                        title: nome_funcionario),
                                    Spacer(
                                      flex: 3,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        launchUrl(Uri.parse('tel:$telefone'));
                                      },
                                      icon: Icon(Icons.phone),
                                    ),
                                    if (whatsapp != '')
                                      // Spacer(),
                                      SizedBox(
                                        width: size.width * 0.01,
                                      ),
                                    if (whatsapp != '')
                                      IconButton(
                                          onPressed: () {
                                            launchUrl(
                                                Uri.parse(
                                                    'https://wa.me/+55$whatsapp'),
                                                mode: LaunchMode
                                                    .externalApplication);
                                          },
                                          icon: Icon(Icons.chat)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return PageVazia(title: snapshot.data['mensagem']);
                    }
                  } else {
                    return PageErro();
                  }
                }),
          ),
        );
      });
}

alertMultiCorresp(BuildContext context) {
  var size = MediaQuery.of(context).size;
  showAllDialog(context,
      children: [
        Column(
          children: [
            ConstsWidget.buildCustomButton(
              context,
              'Várias Caixas',
              color: Color.fromARGB(255, 242, 131, 71),
              onPressed: () {
                ConstsFuture.navigatorPush(context, EncomendasScreen());
              },
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            ConstsWidget.buildCustomButton(
              context,
              'Várias Cartas',
              color: Consts.kColorApp,
              onPressed: () {
                ConstsFuture.navigatorPush(
                  context,
                  MultiCartas(),
                );
              },
            ),
          ],
        )
      ],
      title: ConstsWidget.buildTitleText(context,
          title: 'Escolha uma Opção', fontSize: 18));
}
