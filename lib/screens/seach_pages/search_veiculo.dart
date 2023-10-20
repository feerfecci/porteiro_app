// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:app_porteiro/screens/seach_pages/search_empty.dart';
import 'package:app_porteiro/widgets/page_vazia.dart';
import 'package:http/http.dart' as http;
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:flutter/material.dart';
import '../../consts/consts.dart';
import '../../widgets/page_erro.dart';

class SearchVeiculo extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'ex: ABC0123, ABC0A123';
  Future sugestoesVeiculos() async {
    var url = Uri.parse(
        '${Consts.apiPortaria}veiculos/index.php?fn=listarVeiculos&idcond&idcond=${FuncionarioInfos.idcondominio}&idfuncionario=${FuncionarioInfos.idFuncionario}&palavra=$query');
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
    Widget buildDescricaoCarro(
        {required String title1,
        required String subTitle1,
        required String title2,
        required String subTitle2}) {
      return ConstsWidget.buildPadding001(
        context,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstsWidget.buildSubTitleText(
                  context,
                  subTitle: title1,
                ),
                ConstsWidget.buildTitleText(context,
                    title: subTitle1, sizedWidth: 0.4),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstsWidget.buildSubTitleText(context, subTitle: title2),
                ConstsWidget.buildTitleText(context,
                    title: subTitle2, sizedWidth: 0.3),
              ],
            )
          ],
        ),
      );
    }

    if (query.isEmpty) {
      return buildNoQuerySearchVermelho(context,
          mensagem1: 'Digite a ',
          mensagemVermelho: 'Placa Completa',
          mensagem2: ' para\n Procurar o Veículo');
    } else {
      return FutureBuilder(
        future: sugestoesVeiculos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            if (!snapshot.data['erro']) {
              return ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data['ListaVeiculos'] != null
                    ? snapshot.data['ListaVeiculos'].length
                    : 0,
                itemBuilder: (context, index) {
                  var apiVeiculos = snapshot.data['ListaVeiculos'][index];
                  int idveiculo = apiVeiculos['idveiculo'];
                  int idcond = apiVeiculos['idcond'];
                  int idunidade = apiVeiculos['idunidade'];
                  String numero = apiVeiculos['numero'];
                  String tipo = apiVeiculos['tipo'];
                  String marca = apiVeiculos['marca'];
                  String modelo = apiVeiculos['modelo'];
                  String cor = apiVeiculos['cor'];
                  String placa = apiVeiculos['placa'];
                  String vaga = apiVeiculos['vaga'];
                  return MyBoxShadow(
                      child: Column(
                    children: [
                      ConstsWidget.buildPadding001(context,
                          child: ConstsWidget.buildTitleText(context,
                              fontSize: 20, title: numero)),
                      ConstsWidget.buildPadding001(
                        context,
                        vertical: 0.005,
                        child: Container(
                          height: 1,
                          // width: size.width * 0.8,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      buildDescricaoCarro(
                          title1: 'Tipo',
                          subTitle1: tipo,
                          title2: 'Vaga',
                          subTitle2: vaga),
                      buildDescricaoCarro(
                          title1: 'Marca',
                          subTitle1: marca,
                          title2: 'Modelo',
                          subTitle2: modelo),
                      buildDescricaoCarro(
                          title1: 'Cor',
                          subTitle1: cor,
                          title2: 'Placa',
                          subTitle2: placa),
                    ],
                  ));
                },
              );
            } else {
              return PageVazia(title: snapshot.data['mensagem']);
            }
          } else {
            return PageErro();
          }
        },
      );
    }
  }
}
