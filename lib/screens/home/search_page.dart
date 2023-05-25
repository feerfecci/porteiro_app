// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../consts/consts.dart';
import 'list_tile_ap.dart';

class SearchPage extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'ex: Bloco 2, AP23, João Silva';
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, 'result');
        },
        icon: Icon(Icons.arrow_back_ios_new_sharp));
  }

  @override
  Widget buildResults(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder<dynamic>(
      future: resultadoUnidade(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Container(
            color: Colors.red,
          );
        } else {
          return ListView.builder(
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
              var nome_responsavel = apiUnidade['nome_responsavel'];
              var login = apiUnidade['login'];
              var nome_moradores = apiUnidade['nome_moradores'];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
                child: ListTileAp(
                  nomeResponsavel: nome_responsavel,
                  bloco: '$dividido_por $nome_divisao - $numero',
                  idunidade: idunidade,
                  nome_moradores: nome_moradores,
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var size = MediaQuery.of(context).size;

    if (query.isEmpty) {
      return Text('Procure um apartamento ou nome');
    } else {
      return FutureBuilder<dynamic>(
        future: sugestoesUnidades(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError || snapshot.data == null) {
            return Container(
              color: Colors.red,
            );
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: size.width * 1,
                  mainAxisExtent: size.height * 0.24),
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data['unidades'] != null
                  ? snapshot.data['unidades'].length
                  : 0,
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
                var nome_responsavel = apiUnidade['nome_responsavel'];
                var nome_moradores = apiUnidade['nome_moradores'];
                var login = apiUnidade['login'];
                // return Padding(
                //   padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
                //   child: ListTileAp(
                //     nomeResponsavel: nome_responsavel,
                //     bloco: '$dividido_por $nome_divisao - $numero',
                //     idunidade: idunidade,
                //   ),
                // );
                // Widget buildActionIcon(
                //     {required String titleModal,
                //     required String labelModal,
                //     required IconData icon}) {
                //   return Padding(
                //     padding:
                //         EdgeInsets.symmetric(horizontal: size.width * 0.005),
                //     child: MyBoxShadow(
                //       paddingAll: 0.002,
                //       child: IconButton(
                //         onPressed: () {
                //           showCustomModalBottom(context,
                //               title: titleModal, idunidade: idunidade,tipoAviso:);
                //         },
                //         icon: Icon(
                //           icon,
                //         ),
                //       ),
                //     ),
                //   );
                // }

                return ListTileAp(
                  nomeResponsavel: nome_responsavel,
                  bloco: '$dividido_por $nome_divisao - $numero',
                  idunidade: idunidade,
                  nome_moradores: nome_moradores,
                )

                    /*   MyBoxShadow(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ConstsWidget.buildTitleText(context,'$idunidade'),
                      ConstsWidget.buildSubTitleText(
                          '$numero- $dividido_por $nome_divisao'),
                      ConstsWidget.buildTitleText(context,nome_responsavel),
                      ConstsWidget.buildSubTitleText(nome_moradores),
                      // Text(login),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.005),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            FuncionarioInfos.avisa_corresp
                                ? buildActionIcon(
                                    titleModal: 'Correspondências',
                                    labelModal: 'Remetente',
                                    icon: Icons.email,
                                  )
                                : SizedBox(),
                            FuncionarioInfos.avisa_delivery
                                ? buildActionIcon(
                                    icon: Icons.delivery_dining,
                                    titleModal: 'Delivery',
                                    labelModal: 'Restaurante',
                                  )
                                : SizedBox(),
                            FuncionarioInfos.avisa_encomendas
                                ? buildActionIcon(
                                    icon: Icons.shopping_bag_rounded,
                                    titleModal: 'Encomenda',
                                    labelModal: 'Remetente',
                                  )
                                : SizedBox(),
                            FuncionarioInfos.avisa_visita
                                ? buildActionIcon(
                                    icon: Icons.person_pin_sharp,
                                    titleModal: 'Visitas',
                                    labelModal: 'Nome',
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                )*/
                    ;
              },
            );
          }
        },
      );
    }
  }

  Future<dynamic> sugestoesUnidades() async {
    var url = Uri.parse(
        '${Consts.apiPortaria}unidades/index.php?fn=pesquisarUnidades&idcond=13&palavra=$query');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    } else {
      return ['Não foi!'];
    }
  }

  Future<dynamic> resultadoUnidade(idunidade) async {
    var url = Uri.parse(
        '${Consts.apiPortaria}unidades/index.php?fn=dadosUnidade&idunidade=$idunidade');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    } else {
      return ['Não foi!'];
    }
  }
}
