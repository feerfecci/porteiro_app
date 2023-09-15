// ignore_for_file: unused_local_variable, non_constant_identifier_names
import 'dart:async';
import 'dart:convert';
import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/screens/correspondencias/emite_entrega_screen.dart';
import 'package:app_porteiro/screens/seach_pages/search_empty.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../consts/consts.dart';
import '../../widgets/page_erro.dart';
import '../../widgets/page_vazia.dart';

class SearchProtocolos extends SearchDelegate<String> {
  // final int? idunidade;
  // final int? tipoAviso;
  SearchProtocolos(/*{required this.idunidade, required this.tipoAviso}*/);
  String? protocoloRetirada = '';
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
  int idunidade = 0;

  @override
  Widget buildSuggestions(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isChecked = false;
    if (query.isEmpty) {
      return buildNoQuerySearch(context,
          mesagem: 'Procure por um código de retirada');
    } else {
      return StatefulBuilder(builder: (context, setState) {
        bool isLoadingCodigo = false;
        return Scaffold(
          body: FutureBuilder<dynamic>(
              future: sugestoesUnidades(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  if (!snapshot.data['erro']) {
                    return ListView(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: snapshot.data['correspondencias'] != null
                              ? snapshot.data['correspondencias'].length
                              : 0,
                          itemBuilder: (context, index) {
                            var infoRetirada =
                                snapshot.data['correspondencias'][index];
                            var idcorrespondencia =
                                infoRetirada['idcorrespondencia'];
                            var idunidadeapi = infoRetirada['idunidade'];
                            var unidade = infoRetirada['unidade'];
                            var divisao = infoRetirada['divisao'];
                            var idcondominio = infoRetirada['idcondominio'];
                            var nome_condominio =
                                infoRetirada['nome_condominio'];
                            var idfuncionario = infoRetirada['idfuncionario'];
                            var nome_funcionario =
                                infoRetirada['nome_funcionario'];
                            var tipo = infoRetirada['tipo'];
                            var remetente = infoRetirada['remetente'];
                            var descricao = infoRetirada['descricao'];
                            protocoloRetirada = infoRetirada['protocolo'];
                            var data_recebimento = DateFormat('dd/MM/yyyy')
                                .format(DateTime.parse(
                                    infoRetirada['data_recebimento']));

                            idunidade = idunidadeapi;

                            return Column(
                              children: [
                                ConstsWidget.buildPadding001(
                                  context,
                                  child: MyBoxShadow(
                                    child: Column(
                                      children: [
                                        ConstsWidget.buildTitleText(context,
                                            title: '$divisao - $unidade',
                                            fontSize: 20),
                                        ListTile(
                                          title: ConstsWidget.buildTitleText(
                                              context,
                                              title: remetente),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ConstsWidget.buildSubTitleText(
                                                  context,
                                                  subTitle: descricao),
                                              SizedBox(
                                                height: size.height * 0.01,
                                              ),
                                              ConstsWidget.buildTitleText(
                                                  context,
                                                  title: 'Recebido em'),
                                              ConstsWidget.buildSubTitleText(
                                                  context,
                                                  subTitle: data_recebimento),
                                            ],
                                          ),
                                          trailing: SizedBox(
                                              width: size.width * 0.38,
                                              child: StatefulBuilder(
                                                  builder: (context, setState) {
                                                return ConstsWidget
                                                    .buildCheckBox(context,
                                                        isChecked: isChecked,
                                                        onChanged: (value) {
                                                  setState(
                                                    () {
                                                      isChecked = value!;
                                                      value == true
                                                          ? listEntregar.add(
                                                              idcorrespondencia
                                                                  .toString())
                                                          : listEntregar.remove(
                                                              idcorrespondencia
                                                                  .toString());
                                                    },
                                                  );
                                                }, title: 'Entregar');
                                              })),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
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
                        ConstsWidget.buildPadding001(
                          context,
                          horizontal: 0.01,
                          child: ConstsWidget.buildCustomButton(
                              context, 'Código de Entrega', onPressed: () {
                            // emiteEntrega(listEntregar.join(','));
                            if (isChecked) {
                              ConstsFuture.navigatorPush(
                                  context,
                                  EmiteEntregaScreen(
                                    idunidade: idunidade,
                                    listEntregar: listEntregar.toString(),
                                    protocoloRetirada: protocoloRetirada,
                                    tipoCompara: 'codigo',
                                  ));
                              // showModalEmiteEntrega(
                              //   context,
                              //   idunidade: idunidade,
                              //   listEntregar: listEntregar.toString(),
                              //   protocoloRetirada: protocoloRetirada,
                              //   tipoCompara: 'codigo',
                              // );
                              listEntregar.clear();
                            } else {
                              buildMinhaSnackBar(context,
                                  title: 'Cuidado',
                                  hasError: true,
                                  subTitle: 'Selecione pelo menos um item');
                            }
                          }),
                        )
                      ],
                    );
                  } else {
                    return PageVazia(title: snapshot.data['mensagem']);
                  }
                } else {
                  return PageErro();
                }
              }),
        );
      });
    }
  }

  Future<dynamic> sugestoesUnidades() async {
    var url = Uri.parse(
        '${Consts.apiPortaria}correspondencias/?fn=listarCorrespondencias&idcond=${FuncionarioInfos.idcondominio}&idfuncionario=${FuncionarioInfos.idFuncionario}&statusentrega=0&protocolo=$query');
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
