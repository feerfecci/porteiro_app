// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'dart:convert';
import 'package:app_porteiro/widgets/page_vazia.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../consts/consts.dart';
import '../screens/home/list_tile_ap.dart';
import '../widgets/page_erro.dart';

class SearchUnidades extends SearchDelegate<String> {
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
    return Container();
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
          } else if (snapshot.hasData) {
            if (!snapshot.data['erro']) {
              return ListView.builder(
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

                  return ListTileAp(
                    nomeResponsavel: nome_responsavel,
                    bloco: '$dividido_por $nome_divisao - $numero',
                    idunidade: idunidade,
                  );
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

  Future<dynamic> sugestoesUnidades() async {
    var url = Uri.parse(
        '${Consts.apiPortaria}unidades/index.php?fn=pesquisarUnidades&idcond=${FuncionarioInfos.idcondominio}&palavra=$query');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    } else {
      return ['Não foi!'];
    }
  }
}
