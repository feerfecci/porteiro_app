// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:convert';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../consts/consts.dart';
import '../moldals/custom_modal.dart';

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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ScaffoldAll(
      title: widget.tipoAviso == 1 ? 'Correspondência ' : ' Encomendas',
      body: ListView(
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
          ConstsWidget.buildCustomButton(
            context,
            widget.tipoAviso == 1
                ? 'Adicionar Correspondência'
                : 'Adicionar Encomenda',
            icon: Icons.add,
            onPressed: () {
              showCustomModalBottom(context,
                  title: 'Correspondência',
                  idunidade: widget.idunidade!,
                  tipoAviso: widget.tipoAviso!);
            },
          ),
          FutureBuilder<dynamic>(
            future: apiListarCorrespondencias(
                idunidade: widget.idunidade, tipoAviso: widget.tipoAviso!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
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
                      var apiCorresp = snapshot.data['correspondencias'][index];
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
                        children: [
                          ConstsWidget.buildSubTitleText(context,
                              subTitle: '$idcorrespondencia'),
                          ConstsWidget.buildTitleText(context,
                              title: descricao),
                          ConstsWidget.buildTitleText(context,
                              title: remetente),
                          ConstsWidget.buildSubTitleText(context,
                              subTitle: data_recebimento),
                        ],
                      ));
                    });
              }
            },
          ),
        ],
      ),
    );
  }
}

apiListarCorrespondencias(
    {required int? idunidade, required int tipoAviso}) async {
  var url = Uri.parse(
      'https://a.portariaapp.com/portaria/api/correspondencias/?fn=listarCorrespondencias&idcond=${FuncionarioInfos.idcondominio}&idunidade=$idunidade&tipo=$tipoAviso');
  var resposta = await http.get(url);
  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return false;
  }
}
