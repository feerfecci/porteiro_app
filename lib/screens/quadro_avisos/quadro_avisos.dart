import 'dart:convert';

import 'package:app_porteiro/consts/consts.dart';
import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/screens/home/home_page.dart';
import 'package:app_porteiro/screens/quadro_avisos/add_aviso.dart';
import 'package:app_porteiro/screens/quadro_avisos/quadro_avisos.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/page_erro.dart';
import 'package:app_porteiro/widgets/page_vazia.dart';
import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:app_porteiro/widgets/shimmer_widget.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../repositories/shared_preferences.dart';

class QuadroHistoricoNotificScreen extends StatefulWidget {
  static List qntAvisos = [];
  const QuadroHistoricoNotificScreen({super.key});

  @override
  State<QuadroHistoricoNotificScreen> createState() =>
      _QuadroHistoricoNotificScreenState();
}

Future apiQuadroAvisos() async {
  //print('listarAvisos');
  var url = Uri.parse(
      '${Consts.apiPortaria}quadro_avisos/?fn=listarAvisos&idcond=${FuncionarioInfos.idcondominio}&idfuncionario=${FuncionarioInfos.idFuncionario}');
  var resposta = await get(url);

  if (resposta.statusCode == 200) {
    var jsonResposta = json.decode(resposta.body);
    if (!jsonResposta['erro']) {
      comparaAvisos(jsonResposta).whenComplete(() => LocalInfos.setLoginDate());
    }

    return json.decode(resposta.body);
  } else {
    return false;
  }
}

Future comparaAvisos(jsonResposta) async {
  List apiAvisos = jsonResposta['avisos'];
  LocalInfos.getLoginDate().then((dateValue) {
    for (var i = 0; i <= apiAvisos.length - 1; i++) {
      if (dateValue != null) {
        if (DateTime.parse(apiAvisos[i]['datahora'])
                    .compareTo(DateTime.parse(dateValue)) >
                0 &&
            DateTime.parse(apiAvisos[i]['datahora']).compareTo(DateTime.now()) <
                0) {
          if (!QuadroHistoricoNotificScreen.qntAvisos
              .contains(apiAvisos[i]['idaviso'])) {
            QuadroHistoricoNotificScreen.qntAvisos.add(apiAvisos[i]['idaviso']);
          }
        }
      } else {
        QuadroHistoricoNotificScreen.qntAvisos.add(apiAvisos[i]['idaviso']);
      }
    }
  });
}

class _QuadroHistoricoNotificScreenState
    extends State<QuadroHistoricoNotificScreen> {
  @override
  void initState() {
    apiQuadroAvisos();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StatefulBuilder(builder: (context, setState) {
      return RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ScaffoldAll(
          title: 'Quadro De Avisos',
          body: Column(
            children: [
              if (FuncionarioInfos.envia_avisos)
                ConstsWidget.buildPadding001(
                  context,
                  horizontal: 0.02,
                  child: ConstsWidget.buildCustomButton(
                    context,
                    'Adicionar Aviso',
                    icon: Icons.add,
                    onPressed: () {
                      ConstsFuture.navigatorPush(context, AddAvisos());
                    },
                  ),
                ),
              FutureBuilder<dynamic>(
                  future: ConstsFuture.launchGetApi(context,
                      'quadro_avisos/?fn=listarAvisos&idcond=${FuncionarioInfos.idcondominio}&idfuncionario=${FuncionarioInfos.idFuncionario}'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return MyBoxShadow(
                              child: Column(
                            children: [
                              ShimmerWidget(
                                height: size.height * 0.03,
                                width: size.width * 0.4,
                              ),
                              ConstsWidget.buildPadding001(
                                context,
                                child: ShimmerWidget(
                                  height: size.height * 0.03,
                                  width: size.width * 0.4,
                                ),
                              ),
                              ShimmerWidget(
                                height: size.height * 0.06,
                                width: double.maxFinite,
                              ),
                            ],
                          ));
                        },
                      );
                    } else if (snapshot.hasData) {
                      if (!snapshot.data['erro']) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: snapshot.data['avisos'].length,
                          itemBuilder: (context, index) {
                            var apiAvisos = snapshot.data['avisos'][index];

                            var idaviso = apiAvisos['idaviso'];
                            var tipo = apiAvisos['tipo'];
                            var txt_tipo = apiAvisos['txt_tipo'];
                            var titulo = apiAvisos['titulo'];
                            var texto = apiAvisos['texto'];
                            var arquivo = apiAvisos['arquivo'];
                            var datahora = apiAvisos['datahora'];
                            bool showBolinha = false;

                            if (QuadroHistoricoNotificScreen.qntAvisos
                                .contains(idaviso)) {
                              showBolinha = true;
                            }
                            return MyBoxShadow(
                                child: ConstsWidget.buildPadding001(
                              context,
                              child: ConstsWidget.buildBadge(
                                context,
                                showBadge: showBolinha,
                                position: BadgePosition.topEnd(
                                    end: size.width * 0.005,
                                    top: size.height * 0.015),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                      onExpansionChanged: (value) {
                                        showBolinha = false;
                                        QuadroHistoricoNotificScreen.qntAvisos
                                            .remove(idaviso);
                                      },
                                      title: SizedBox(
                                        width: size.width * 0.65,
                                        child: ConstsWidget.buildTitleText(
                                            context,
                                            fontSize: 18,
                                            title: titulo,
                                            textAlign: TextAlign.center),
                                      ),
                                      children: [
                                        SizedBox(
                                          height: size.height * 0.01,
                                        ),
                                        ConstsWidget.buildTitleText(context,
                                            maxLines: 10,
                                            title: texto,
                                            textAlign: TextAlign.center),
                                        SizedBox(
                                          height: size.height * 0.01,
                                        ),
                                        if (arquivo != '')
                                          OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                  width: size.width * 0.005,
                                                  color: Colors.blue),
                                              shape: StadiumBorder(),
                                            ),
                                            onPressed: () {
                                              launchUrl(Uri.parse(arquivo),
                                                  mode: LaunchMode
                                                      .externalNonBrowserApplication);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      size.height * 0.023),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ConstsWidget
                                                      .buildSubTitleText(
                                                    context,
                                                    subTitle: 'Ver Anexo',
                                                    fontSize: 18,
                                                    color: Colors.blue,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ]),
                                ),
                              ),
                            ));
                          },
                        );
                      } else {
                        return PageVazia(title: snapshot.data['mensagem']);
                      }
                    } else {
                      return PageErro();
                    }
                  }),
            ],
          ),
        ),
      );
    });
  }
}
