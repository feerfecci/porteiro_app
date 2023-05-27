// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/seach_pages/search_unidades.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:app_porteiro/widgets/shimmer_widget.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../consts/consts.dart';
import '../../widgets/floatingActionButton.dart';
import '../../moldals/modal_inclui_corrresp.dart';
import '../../seach_pages/search_protocolo.dart';

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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ScaffoldAll(
      floatingActionButton: buildFloatingSearch(context,
          searchPage: SearchProtocolos(idunidade: widget.idunidade)),
      title: widget.tipoAviso == 1 ? 'Correspondências' : ' Encomendas',
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            apiListarCorrespondencias(
                idunidade: widget.idunidade, tipoAviso: widget.tipoAviso!);
          });
        },
        child: ListView(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConstsWidget.buildTitleText(context,
                    title: widget.nome_responsavel),
                ConstsWidget.buildSubTitleText(context,
                    subTitle: widget.localizado!),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
              child: ConstsWidget.buildCustomButton(
                context,
                widget.tipoAviso == 1
                    ? 'Adicionar Correspondências'
                    : 'Adicionar Encomendas',
                icon: Icons.add,
                onPressed: () {
                  showModalIncluiCorresp(context,
                      title: 'Correspondência',
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
                } else if (snapshot.data['erro'] == false &&
                    snapshot.data['mensagem'] ==
                        "Nenhuma correspondência registrada para essa unidade") {
                  return Center(
                    child: Text(snapshot.data['mensagem']),
                  );
                } else if (snapshot.hasError) {
                  return Text('Algo não deu certo. Volte mais tarde!');
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data['correspondencias'].length,
                      itemBuilder: (context, index) {
                        var apiCorresp =
                            snapshot.data['correspondencias'][index];
                        var idcorrespondencia = apiCorresp['idcorrespondencia'];
                        var unidade = apiCorresp['unidade'];
                        var divisao = apiCorresp['divisao'];
                        var idcondominio = apiCorresp['idcondominio'];
                        var nome_condominio = apiCorresp['nome_condominio'];
                        var idfuncionario = apiCorresp['idfuncionario'];
                        var nome_funcionario = apiCorresp['nome_funcionario'];
                        var data_recebimento = DateFormat('dd/MM/yyyy')
                            .format(
                                DateTime.parse(apiCorresp['data_recebimento']))
                            .toString();
                        var tipo = apiCorresp['tipo'];
                        var remetente = apiCorresp['remetente'];
                        var descricao = apiCorresp['descricao'];
                        var protocolo = apiCorresp['protocolo'];
                        var datahora_cadastro = apiCorresp['datahora_cadastro'];
                        var datahora_ultima_atualizacao =
                            apiCorresp['datahora_ultima_atualizacao'];

                        return MyBoxShadow(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstsWidget.buildTitleText(context,
                                title: remetente),
                            SizedBox(
                              height: size.height * 0.015,
                            ),
                            Row(
                              children: [
                                ConstsWidget.buildSubTitleText(context,
                                    subTitle: '$descricao - '),
                                ConstsWidget.buildTitleText(context,
                                    title: data_recebimento),
                              ],
                            ),
                          ],
                        ));
                      });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

apiListarCorrespondencias(
    {required int? idunidade, required int tipoAviso}) async {
  var url = Uri.parse(
      'https://a.portariaapp.com/portaria/api/correspondencias/?fn=listarCorrespondencias&idcond=${FuncionarioInfos.idcondominio}&idunidade=$idunidade&tipo=$tipoAviso&statusentrega=0');
  var resposta = await http.get(url);
  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return false;
  }
}
