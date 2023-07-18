// ignore_for_file: prefer_const_literals_to_create_immutables, unused_local_variable, non_constant_identifier_names
import 'dart:convert';
import 'package:app_porteiro/consts/consts.dart';
import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/screens/avisos/avisos_screen.dart';
import 'package:app_porteiro/seach_pages/search_unidades.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/page_vazia.dart';
import 'package:app_porteiro/widgets/seachBar.dart';
import 'package:app_porteiro/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../consts/consts_widget.dart';
import '../../widgets/page_erro.dart';
import '../correspondencias/multi_corresp.dart';
import 'list_tile_ap.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

Future apiListarUnidades() async {
  var url = Uri.parse(
      '${Consts.apiPortaria}unidades/?fn=listarUnidades&idcond=${FuncionarioInfos.idcondominio}');
  var resposta = await http.get(url);
  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  }
  return false;
}

class _HomePageState extends State<HomePage> {
  // Future oneSignalNotification() async {
  //   OneSignal.shared.setAppId("5993cb79-853a-412e-94a1-f995c9797692");
  //   OneSignal.shared.promptUserForPushNotificationPermission();
  //   OneSignal.shared.sendTags({
  //     'idfuncionario': FuncionarioInfos.idFuncionario.toString(),
  //     'idcond': FuncionarioInfos.idcondominio.toString(),
  //     'idfuncao': FuncionarioInfos.idfuncao.toString(),
  //   });
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   apiListarUnidades();
  // }

  // @override
  // void initState() {
  //   apiListarUnidades();
  //   oneSignalNotification();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ConstsWidget.buildRefreshIndicadtor(
      context,
      onRefresh: () async {
        setState(() {
          apiListarUnidades();
        });
      },
      child: ConstsWidget.buildPadding001(
        context,
        horizontal: 0.01,
        child: ListView(
          children: [
            ConstsWidget.buildCustomButton(
              context,
              'Adicionar Items',
              onPressed: () {
                ConstsFuture.navigatorPush(context, MultiCorrespScreen());
              },
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            ConstsWidget.buildPadding001(
              context,
              child: ConstsWidget.buildCustomButton(
                context,
                'Histórico Avisos',
                onPressed: () {
                  ConstsFuture.navigatorPush(context, AvisosScreen());
                },
              ),
            ),
            ConstsWidget.buildPadding001(
              context,
              vertical: 0,
              horizontal: 0.01,
              child: SeachBar(
                label: 'Pesquise um apartamento',
                hintText: 'ap01',
                delegate: SearchUnidades(),
              ),
            ),
            FutureBuilder<dynamic>(
              future: apiListarUnidades(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return MyBoxShadow(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerWidget(
                          height: size.height * 0.02, width: size.width * 0.5),
                      ConstsWidget.buildPadding001(
                        context,
                        child: ShimmerWidget(
                          height: size.height * 0.02,
                          width: size.width * 0.5,
                        ),
                      ),
                      ShimmerWidget(
                          height: size.height * 0.02, width: size.width * 0.3),
                      ConstsWidget.buildPadding001(
                        context,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ShimmerWidget(
                              height: size.height * 0.08,
                              width: size.height * 0.08,
                            ),
                            ShimmerWidget(
                              height: size.height * 0.08,
                              width: size.height * 0.08,
                            ),
                            ShimmerWidget(
                              height: size.height * 0.08,
                              width: size.height * 0.08,
                            ),
                            ShimmerWidget(
                              height: size.height * 0.08,
                              width: size.height * 0.08,
                            )
                          ],
                        ),
                      )
                    ],
                  ));
                } else if (snapshot.hasData) {
                  if (!snapshot.data['erro']) {
                    return ListView.builder(
                      // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      //     maxCrossAxisExtent: size.width * 1,
                      //     mainAxisExtent: size.height * 0.23),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data['unidades'].length,
                      itemBuilder: (context, index) {
                        var apiUnidade = snapshot.data['unidades'][index];
                        var idunidade = apiUnidade['idunidade'];
                        var ativo = apiUnidade['ativo'];
                        var idcondominio = apiUnidade['idcondominio'];
                        var nome_condominio = apiUnidade['nome_condominio'];
                        var iddivisao = apiUnidade['iddivisao'];
                        var nome_divisao = apiUnidade['nome_divisao'];
                        var dividido_por = apiUnidade['dividido_por'];
                        var numero = apiUnidade['numero'];
                        String nome_responsavel =
                            apiUnidade['nome_responsavel'];
                        var login = apiUnidade['login'];
                        List nomeEmLista = nome_responsavel.split(' ');
                        List<String> listNomeAbreviado = [];
                        for (var i = 1; i <= (nomeEmLista.length - 1); i++) {
                          if (nomeEmLista[i] != '' &&
                              (nomeEmLista[i] != 'de' &&
                                  nomeEmLista[i] != 'do' &&
                                  nomeEmLista[i] != 'dos' &&
                                  nomeEmLista[i] != 'das' &&
                                  nomeEmLista[i] != 'da')) {
                            listNomeAbreviado
                                .add(nomeEmLista[i].substring(0, 1));
                          }
                        }
                        var segundoNome = listNomeAbreviado.join('. ');
                        // var segundoNome = nomeEmLista.forEach((element) {
                        //   return element.substring(0, 1);
                        // });
                        return ConstsWidget.buildPadding001(
                          context,
                          vertical: 0.005,
                          child: ListTileAp(
                            nomeResponsavel:
                                '${nomeEmLista.first} $segundoNome.',
                            bloco: '$dividido_por $nome_divisao - $numero',
                            // nome_moradores: nome_moradores,
                            idunidade: idunidade,
                          ),
                        );
                      },
                    );
                  } else {
                    PageVazia(title: snapshot.data['mensagem']);
                  }
                }
                return PageErro();
              },
            ),
          ],
        ),
      ),
    );
  }
}
