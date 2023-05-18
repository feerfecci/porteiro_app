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

List<String> aps = ['16', '18', '20', '22', '24', '26', '28', '30', '32'];
List<String> blocos = ['1', '2', '3'];

Future apiListarUnidades() async {
  var url = Uri.parse(
      'https://a.portariaapp.com/sindico/api/unidades/?fn=listarUnidades&idcond=${FuncionarioInfos.idcondominio}');
  var resposta = await http.get(url).then((value) {
    if (value.statusCode == 200) {
      return json.decode(value.body);
    }
  });
  return resposta;
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiListarUnidades();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('widget.title'),
      ),
      endDrawer: CustomDrawer(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
          child: ListView(
            children: [
              SearchBar(),
              FutureBuilder<dynamic>(
                future: apiListarUnidades(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError || snapshot.data['erro']) {
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
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
