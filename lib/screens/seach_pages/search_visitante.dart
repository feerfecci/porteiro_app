// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'dart:convert';
import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/moldals/modal_envia_avisos.dart';
import 'package:app_porteiro/screens/seach_pages/search_empty.dart';
import 'package:app_porteiro/widgets/page_vazia.dart';
import 'package:http/http.dart' as http;
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../consts/consts.dart';
import '../../widgets/page_erro.dart';
import '../avisos/emite_avisos_screen.dart';

class SearchVisitante extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'ex: RG, CPF';
  Future sugestoesVisitantes() async {
    var url = Uri.parse(
        '${Consts.apiPortaria}lista_visitantes/?fn=listarVisitantes&idcond=${FuncionarioInfos.idcondominio}&idfuncionario=${FuncionarioInfos.idFuncionario}&palavra=$query');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    } else {
      return ['Não foi!'];
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.close),
      ),
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
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var size = MediaQuery.of(context).size;

    if (query.isEmpty) {
      return buildNoQuerySearch(context,
          mesagem: 'Digite um documento\n para localizar o visitante');
    } else {
      return StatefulBuilder(builder: (context, setState) {
        return FutureBuilder(
          future: sugestoesVisitantes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              if (!snapshot.data['erro']) {
                return ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data['ListaVisitantes'] != null
                      ? snapshot.data['ListaVisitantes'].length
                      : 0,
                  itemBuilder: (context, index) {
                    var apiVisitas = snapshot.data['ListaVisitantes'][index];

                    var idvisita = apiVisitas['idvisita'];
                    var idcond = apiVisitas['idcond'];
                    var nome_condominio = apiVisitas['nome_condominio'];
                    var idunidade = apiVisitas['idunidade'];
                    var unidade = apiVisitas['unidade'];
                    var convidado_por = apiVisitas['convidado_por'];
                    var idmorador = apiVisitas['idmorador'];
                    var nome_convidado = apiVisitas['nome_convidado'];
                    var doc_convidado = apiVisitas['doc_convidado'];
                    var acompanhante = apiVisitas['acompanhante'];
                    var datahora_visita = DateFormat('HH:mm - dd/MM/yyyy')
                        .format(DateTime.parse(apiVisitas['datahora_visita']));
                    var confirmado = apiVisitas['confirmado'];
                    var autorizado = apiVisitas['autorizado'];
                    return MyBoxShadow(
                        child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstsWidget.buildSubTitleText(context,
                                    subTitle: 'Nome Convidado'),
                                ConstsWidget.buildTitleText(context,
                                    title: '$nome_convidado'),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstsWidget.buildSubTitleText(context,
                                    subTitle: 'Documento'),
                                ConstsWidget.buildPadding001(
                                  context,
                                  child: ConstsWidget.buildTitleText(context,
                                      title: '$doc_convidado'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (acompanhante != '')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ConstsWidget.buildSubTitleText(context,
                                      subTitle: 'Nome Acompanhante'),
                                  ConstsWidget.buildTitleText(context,
                                      title: '$acompanhante'),
                                ],
                              ),
                            ],
                          ),
                        ConstsWidget.buildPadding001(
                          context,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ConstsWidget.buildSubTitleText(context,
                                      subTitle: 'Nome Anfitrião'),
                                  ConstsWidget.buildTitleText(context,
                                      title: '$convidado_por'),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ConstsWidget.buildSubTitleText(context,
                                      subTitle: 'Local'),
                                  ConstsWidget.buildPadding001(
                                    context,
                                    child: ConstsWidget.buildTitleText(context,
                                        title: '$unidade'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ConstsWidget.buildTitleText(context,
                                title: datahora_visita),
                            ConstsWidget.buildAtivoInativo(context, autorizado,
                                verdadeiro: 'Autorizado', falso: 'Recusado'),
                          ],
                        ),
                        ConstsWidget.buildPadding001(
                          context,
                          child: ConstsWidget.buildOutlinedButton(
                            context,
                            title: 'Anunciar Visita',
                            onPressed: () {
                              double? fontSize = 18;
                              TextStyle styleBold = TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19);
                              TextStyle style = TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: fontSize,
                                  height: size.height * 0.002);
                              ConstsFuture.navigatorPush(
                                  context,
                                  EmiteAvisosScreen(
                                      idunidade: idunidade,
                                      localizado: unidade,
                                      tipoAviso: 2,
                                      nomeCadastrado: nome_convidado,
                                      idVisita: idvisita,
                                      title: 'Visitas'));

                              // showModalAvisaDelivery(context,
                              //     idunidade: idunidade,
                              //     localizado: unidade,
                              //     tipoAviso: 2,
                              //     nomeCadastrado: nome_convidado,
                              //     idVisita: idvisita,
                              //     title: 'Visitas');
                              // showModalBottomSheet(
                              //   context: context,
                              //   builder: (context) {
                              //     return Column(
                              //       children: [
                              //         ConstsWidget.buildPadding001(
                              //           context,
                              //           horizontal: 0.02,
                              //           child: RichText(
                              //             text: TextSpan(
                              //                 style: styleBold,
                              //                 text: 'Cuidado!!  ',
                              //                 children: [
                              //                   TextSpan(
                              //                     text:
                              //                         'Após confirmar a visita, o condômino será avisado e não poderá mais voltar a ação',
                              //                     style: styleBold,
                              //                   ),
                              //                 ]),
                              //           ),
                              //         ),
                              //         ConstsWidget.buildPadding001(
                              //           context,
                              //           child: Row(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.end,
                              //             children: [
                              //               ConstsWidget.buildOutlinedButton(
                              //                 context,
                              //                 title: 'Cancelar',
                              //                 onPressed: () {
                              //                   Navigator.pop(context);
                              //                 },
                              //               ),
                              //               SizedBox(width: size.width * 0.02),
                              //               ConstsWidget.buildCustomButton(
                              //                 context,
                              //                 'Confirmar',
                              //                 onPressed: () {
                              //                   Navigator.pop(context);
                              //                   buildMinhaSnackBar(context,
                              //                       title: 'Obrigado',
                              //                       subTitle:
                              //                           'A visita confirmada e condômino avisado');
                              //                 },
                              //               )
                              //             ],
                              //           ),
                              //         ),
                              //       ],
                              //     );
                              //   },
                              // );
                              // showAllDialog(context,
                              //     title: ConstsWidget.buildTitleText(context,
                              //         title: 'Anunciar Visita'),
                              //     children: []);
                            },
                          ),
                        )
                      ],
                    ));
                  },
                );
              } else {
                return Center(
                    child: PageVazia(title: snapshot.data['mensagem']));
              }
            } else {
              return PageErro();
            }
          },
        );
      });
    }
  }
}
