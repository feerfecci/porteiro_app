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
                    ConstsWidget.buildTitleText(context, title: tipo),
                    ConstsWidget.buildTitleText(context, title: marca),
                    ConstsWidget.buildTitleText(context, title: modelo),
                    ConstsWidget.buildTitleText(context, title: cor),
                    ConstsWidget.buildTitleText(context, title: placa),
                    ConstsWidget.buildTitleText(context, title: vaga),
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
