// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:app_porteiro/consts/consts.dart';
import 'package:app_porteiro/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../widgets/custom_drawer/custom_drawer.dart';
import 'list_tile_ap.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future apiListarUnidades() async {
    var url = Uri.parse(
        'https://a.portariaapp.com/sindico/api/unidades/?fn=listarUnidades&idcond=${FuncionarioInfos.idcondominio}');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    }
    return resposta;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    apiListarUnidades();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          apiListarUnidades();
        });
      },
      child: ListView(
        children: [
          SearchBar(),
          FutureBuilder<dynamic>(
            future: apiListarUnidades(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Container(
                  color: Colors.red,
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: snapshot.data['unidades'].length,
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
                  var login = apiUnidade['login'];
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: size.height * 0.005),
                    child: ListTileAp(
                      ap: nome_responsavel,
                      bloco: '$dividido_por $nome_divisao - $numero',
                      idunidade: idunidade,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
