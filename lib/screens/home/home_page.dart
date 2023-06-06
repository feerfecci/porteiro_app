// ignore_for_file: prefer_const_literals_to_create_immutables, unused_local_variable, non_constant_identifier_names

import 'dart:convert';

import 'package:app_porteiro/consts/consts.dart';
import 'package:app_porteiro/seach_pages/search_unidades.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'list_tile_ap.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

Future apiListarUnidades() async {
  var url = Uri.parse(
      '${Consts.apiPortaria}unidades/?fn=listarUnidades&idcond=${FuncionarioInfos.idcondominio}');
  var resposta = await http.get(url);
  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  }
  return false;
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
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
          // SearchBar(),
          FutureBuilder<dynamic>(
            future: apiListarUnidades(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return MyBoxShadow(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget(height: 16, width: size.width * 0.5),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.01),
                      child: ShimmerWidget(
                        height: 16,
                        width: size.width * 0.5,
                      ),
                    ),
                    ShimmerWidget(height: 16, width: size.width * 0.3),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ShimmerWidget(
                            height: size.height * 0.08,
                            width: size.height * 0.08,
                          ),
                          ShimmerWidget(
                            height: size.height * 0.08,
                            width: size.height * 0.08,
                          ),
                          ShimmerWidget(
                            height: size.height * 0.08,
                            width: size.height * 0.08,
                          ),
                          ShimmerWidget(
                            height: size.height * 0.08,
                            width: size.height * 0.08,
                          )
                        ],
                      ),
                    )
                  ],
                ));
              } else if (snapshot.hasError) {
                return Container(
                  color: Colors.red,
                );
              }
              return ListView.builder(
                // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                //     maxCrossAxisExtent: size.width * 1,
                //     mainAxisExtent: size.height * 0.23),
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
                      nomeResponsavel: nome_responsavel,
                      bloco: '$dividido_por $nome_divisao - $numero',
                      // nome_moradores: nome_moradores,
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
