// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:flutter/material.dart';
import '../consts/consts.dart';

class SearchVeiculo extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'ex: ABC0123, ABC0A123';
  Future sugestoesVeiculos() async {
    var url = Uri.parse(
        '${Consts.apiPortaria}veiculos/index.php?fn=listarVeiculos&idcond&idcond=${FuncionarioInfos.idcondominio}&palavra=$query');
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
      return Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstsWidget.buildSubTitleText(context, subTitle: '$title1:'),
                ConstsWidget.buildTitleText(context, title: subTitle1),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstsWidget.buildSubTitleText(context, subTitle: '$title2:'),
                ConstsWidget.buildTitleText(context, title: subTitle2),
              ],
            )
          ],
        ),
      );
    }

    if (query.isEmpty) {
      return Text('Procure um veículo');
    } else {
      return FutureBuilder(
        future: sugestoesVeiculos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError || snapshot.data == null) {
            return Container(
              color: Colors.red,
            );
          } else {
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
                String tipo = apiVeiculos['tipo'];
                String marca = apiVeiculos['marca'];
                String modelo = apiVeiculos['modelo'];
                String cor = apiVeiculos['cor'];
                String placa = apiVeiculos['placa'];
                String vaga = apiVeiculos['vaga'];
                return MyBoxShadow(
                    child: Column(
                  children: [
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
          }
        },
      );
    }
  }
}
