// ignore_for_file: non_constant_identifier_names, unused_local_variable, prefer_typing_uninitialized_variables
import 'dart:convert';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/screens/correspondencias/alert_dialog_moradores.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/shimmer_widget.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../consts/consts.dart';
import '../../moldals/modal_inclui_corrresp.dart';
import '../../widgets/listview_all.dart';
import '../../widgets/page_erro.dart';
import '../../widgets/page_vazia.dart';

class CorrespondenciasScreen extends StatefulWidget {
  final int? idunidade;
  final String? localizado;

  final String? nome_responsavel;
  final int? tipoAviso;
  const CorrespondenciasScreen(
      {required this.localizado,
      required this.nome_responsavel,
      required this.idunidade,
      required this.tipoAviso,
      super.key});

  @override
  State<CorrespondenciasScreen> createState() => _CorrespondenciasScreenState();
}

class _CorrespondenciasScreenState extends State<CorrespondenciasScreen> {
  @override
  void dispose() {
    super.dispose();
    apiListarCorrespondencias;
  }

  bool loadingRetirada = false;
  bool isChecked = false;
  List correspEntregar = <String>[];
  var idUnidade;
  var protocolo_entrega;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return
        // ScaffoldAll(
        //   floatingActionButton: buildFloatingSearch(context,
        //       searchPage: SearchProtocolos(
        //           idunidade: widget.idunidade, tipoAviso: widget.tipoAviso)),
        //   title: widget.tipoAviso == 3 ? 'Correspondências' : ' Encomendas',
        //   body:
        RefreshIndicator(
      onRefresh: () async {
        setState(() {
          apiListarCorrespondencias(
              idunidade: widget.idunidade, tipoAviso: widget.tipoAviso!);
          isChecked = false;
          correspEntregar = [];
        });
      },
      child: buildListViewAll([
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConstsWidget.buildTitleText(context,
                title: widget.localizado, fontSize: 20),
          ],
        ),
        ConstsWidget.buildPadding001(
          context,
          vertical: 0.015,
          child: ConstsWidget.buildCustomButton(
            context,
            widget.tipoAviso == 3 ? 'Cartas' : 'Caixas',
            icon: Icons.add,
            onPressed: () {
              showModalIncluiCorresp(context,
                  title: widget.tipoAviso == 3 ? 'Cartas' : 'Caixas',
                  idunidade: widget.idunidade!,
                  tipoAviso: widget.tipoAviso!,
                  nome_responsavel: widget.nome_responsavel,
                  localizado: widget.nome_responsavel);
            },
          ),
        ),
        FutureBuilder<dynamic>(
          future: apiListarCorrespondencias(
              idunidade: widget.idunidade, tipoAviso: widget.tipoAviso!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return MyBoxShadow(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerWidget(
                    height: size.height * 0.03,
                    width: size.width * 0.3,
                  ),
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  ShimmerWidget(
                    height: size.height * 0.03,
                    width: size.width * 0.6,
                  )
                ],
              ));
            } else if (!snapshot.hasError &&
                snapshot.data['mensagem'] !=
                    "Nenhuma correspondência registrada para essa unidade") {
              if (!snapshot.data['erro']) {
                return Column(
                  children: [
                    if (snapshot.data['correspondencias'].length >= 1)
                      ConstsWidget.buildCustomButton(
                        context,
                        'Emitir Entrega',
                        color: Consts.kColorRed,
                        onPressed: () {
                          correspEntregar.isEmpty
                              ? buildMinhaSnackBar(context,
                                  title: 'Cuidado!',
                                  subTitle: 'Selecione pelo menos um item')
                              : showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertListMoradores(
                                        idunidade: idUnidade,
                                        listEntregar:
                                            correspEntregar.join(','));
                                  },
                                );

                          // alertDialogMoradores(context,
                          //     idunidade: idUnidade,
                          //     listEntregar: correspEntregar.join(','));

                          // showModalEmiteEntrega(context,
                          //     idunidade: idUnidade,
                          //     protocoloRetirada: protocolo_entrega,
                          //     tipoCompara: 2,
                          //     listEntregar: correspEntregar.join(','));
                        },
                      ),
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data['correspondencias'].length,
                        itemBuilder: (context, index) {
                          var apiCorresp =
                              snapshot.data['correspondencias'][index];
                          var idcorrespondencia =
                              apiCorresp['idcorrespondencia'];
                          var unidade = apiCorresp['unidade'];
                          var divisao = apiCorresp['divisao'];
                          var idcondominio = apiCorresp['idcondominio'];
                          idUnidade = apiCorresp['idunidade'];
                          var nome_condominio = apiCorresp['nome_condominio'];
                          var idfuncionario = apiCorresp['idfuncionario'];
                          var nome_funcionario = apiCorresp['nome_funcionario'];
                          var data_recebimento = DateFormat('dd/MM/yyyy')
                              .format(DateTime.parse(
                                  apiCorresp['data_recebimento']))
                              .toString();
                          var tipo = apiCorresp['tipo'];
                          var remetente = apiCorresp['remetente'];
                          var descricao = apiCorresp['descricao'];
                          var protocolo = apiCorresp['protocolo'];
                          protocolo_entrega = protocolo_entrega =
                              apiCorresp['protocolo_entrega'];
                          var datahora_cadastro =
                              apiCorresp['datahora_cadastro'];
                          var datahora_ultima_atualizacao =
                              apiCorresp['datahora_ultima_atualizacao'];

                          return StatefulBuilder(builder: (context, setState) {
                            return MyBoxShadow(
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: size.width * 0.02),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.7,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ConstsWidget.buildTitleText(context,
                                              title: remetente, fontSize: 18),
                                          SizedBox(
                                            height: size.height * 0.005,
                                          ),
                                          ConstsWidget.buildSubTitleText(
                                              context,
                                              fontSize: 16,
                                              subTitle:
                                                  '$descricao - $data_recebimento'),
                                        ],
                                      ),
                                    ),
                                    Transform.scale(
                                      scale: 1.3,
                                      child: Checkbox(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        value: isChecked,
                                        onChanged: (value) {
                                          setState(
                                            () {
                                              isChecked = value!;
                                              value
                                                  ? correspEntregar.add(
                                                      idcorrespondencia
                                                          .toString())
                                                  : correspEntregar.remove(
                                                      idcorrespondencia
                                                          .toString());
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // CheckboxListTile(
                              //   checkboxShape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(15)),
                              //   contentPadding:
                              //       EdgeInsets.only(left: size.width * 0.02),
                              //   title: ConstsWidget.buildTitleText(context,
                              //       title: remetente),
                              //   subtitle: ConstsWidget.buildSubTitleText(
                              //       context,
                              //       subTitle:
                              //           '$descricao - $data_recebimento'),
                              // //   value: isChecked,
                              //   activeColor: Consts.kColorApp,
                              //   onChanged: (value) {
                              //     setState(
                              //       () {
                              //         isChecked = value!;
                              //         value
                              //             ? correspEntregar.add(
                              //                 idcorrespondencia.toString())
                              //             : correspEntregar.remove(
                              //                 idcorrespondencia.toString());
                              //       },
                              //     );
                              //   },
                              // ),
                            );
                          });
                        }),
                  ],
                );
              } else {
                return PageVazia(title: snapshot.data['mensagem']);
              }
            } else if (!snapshot.hasError &&
                snapshot.data['mensagem'] ==
                    "Nenhuma correspondência registrada para essa unidade") {
              return PageVazia(title: snapshot.data['mensagem']);
            } else {
              return PageErro();
            }
          },
        ),
      ]),
    );
    // );
  }
}

apiListarCorrespondencias(
    {required int? idunidade, required int tipoAviso}) async {
  var url = Uri.parse(
      '${Consts.apiPortaria}correspondencias/?fn=listarCorrespondencias&idcond=${FuncionarioInfos.idcondominio}&idunidade=$idunidade&tipo=$tipoAviso&statusentrega=0');
  var resposta = await http.get(url);
  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return false;
  }
}
