// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/moldals/modal_emite_entrega.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../consts/consts.dart';
import '../moldals/modal_inclui_corrresp.dart';

class SearchProtocolos extends SearchDelegate<String> {
  final int? idunidade;
  final int? tipoAviso;
  SearchProtocolos({required this.idunidade, required this.tipoAviso});

  @override
  String get searchFieldLabel => "Digite o Protocolo";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(
            Icons.close,
            color: Theme.of(context).iconTheme.color,
          ))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          return close(context, 'result');
        },
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).iconTheme.color,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  final List listEntregar = [];

  @override
  Widget buildSuggestions(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isChecked = false;
    return StatefulBuilder(builder: (context, setState) {
      bool isLoadingCodigo = false;
      return Scaffold(
        body: FutureBuilder<dynamic>(
            future: sugestoesUnidades(),
            builder: (context, snapshot) {
              if (query.isEmpty) {
                return Text('Procure por um protocolo');
              } else {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError ||
                    (snapshot.data['erro'] == true)) {
                  return Text('Erro no Servidor');
                } else if (snapshot.hasData &&
                    snapshot.data['mensagem'] ==
                        "Nenhuma correspondência registrada para essa unidade") {
                  return Text(snapshot.data['mensagem']);
                }
                return ListView(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data['correspondencias'].length,
                      itemBuilder: (context, index) {
                        var infoRetirada =
                            snapshot.data['correspondencias'][index];
                        var idcorrespondencia =
                            infoRetirada['idcorrespondencia'];
                        var idunidade = infoRetirada['idunidade'];
                        var unidade = infoRetirada['unidade'];
                        var divisao = infoRetirada[';'];
                        var idcondominio = infoRetirada['idcondominio'];
                        var nome_condominio = infoRetirada[';'];
                        var idfuncionario = infoRetirada['idfuncionario'];
                        var nome_funcionario = infoRetirada['nome_funcionario'];
                        var tipo = infoRetirada['tipo'];
                        var remetente = infoRetirada['remetente'];
                        var descricao = infoRetirada['descricao'];
                        var protocolo = infoRetirada['protocolo'];
                        var data_recebimento = DateFormat('dd/MM/yyyy').format(
                            DateTime.parse(infoRetirada['data_recebimento']));
                        return MyBoxShadow(
                          child: ListTile(
                            title: ConstsWidget.buildTitleText(context,
                                title: remetente),
                            subtitle: ConstsWidget.buildSubTitleText(context,
                                subTitle: '$descricao - $data_recebimento'),
                            trailing: SizedBox(
                                width: size.width * 0.38,
                                child: StatefulBuilder(
                                    builder: (context, setState) {
                                  return CheckboxListTile(
                                    title: ConstsWidget.buildSubTitleText(
                                        context,
                                        subTitle: 'Entregar'),
                                    activeColor: Consts.kColorApp,
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          isChecked = value!;
                                          value == true
                                              ? listEntregar.add(
                                                  idcorrespondencia.toString())
                                              : listEntregar.remove(
                                                  idcorrespondencia.toString());
                                        },
                                      );
                                    },
                                    value: isChecked,
                                  );
                                })),
                          ),
                        );
                      },
                    ),
                    // ConstsWidget.buildLoadingButton(context, onPressed: () {
                    //   setState(
                    //     () {
                    //       isLoadingCodigo = !isLoadingCodigo;
                    //     },
                    //   );
                    //   // emiteEntrega(listEntregar.join(','));
                    //   Timer(Duration(seconds: 2), () {
                    //     setState(
                    //       () {
                    //         isLoadingCodigo = !isLoadingCodigo;
                    //         showModalEmiteEntrega(context,
                    //             idunidade: idunidade, protocoloRetirada: query);
                    //         listEntregar.clear();
                    //       },
                    //     );
                    //   });
                    // }, isLoading: isLoadingCodigo, title: 'Código de Entrega'),

                    ConstsWidget.buildCustomButton(context, 'Código de Entrega',
                        onPressed: () {
                      // emiteEntrega(listEntregar.join(','));

                      showModalEmiteEntrega(context,
                          idunidade: idunidade, protocoloRetirada: query);
                      listEntregar.clear();
                    })
                  ],
                );
              }
            }),
      );
    });
  }

  Future<dynamic> sugestoesUnidades() async {
    var url = Uri.parse(
        '${Consts.apiPortaria}correspondencias/?fn=listarCorrespondencias&idcond=${FuncionarioInfos.idcondominio}&idunidade=$idunidade&statusentrega=0&tipo=$tipoAviso&protocolo=$query');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    } else {
      return ['Não foi!'];
    }
  }

  // Future<dynamic> emiteEntrega(listaEntregar) async {
  //   var url = Uri.parse(
  //       // print(
  //       '${Consts.apiPortaria}correspondencias/?fn=entregarCorrespondencias&idcond=${FuncionarioInfos.idcondominio}&idunidade=$idunidade&listacorrespondencias=$listaEntregar');
  //   var resposta = await http.get(url);
  //   if (resposta.statusCode == 200) {
  //     return json.decode(resposta.body);
  //   } else {
  //     return ['Não foi!'];
  //   }
  // }
}
