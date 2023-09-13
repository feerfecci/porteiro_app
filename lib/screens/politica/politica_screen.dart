import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../consts/consts.dart';
import '../../widgets/page_erro.dart';
import '../../widgets/page_vazia.dart';
import '../../widgets/scaffold_all.dart';
import 'package:flutter_html/flutter_html.dart';

class PoliticaScreen extends StatefulWidget {
  const PoliticaScreen({super.key});

  @override
  State<PoliticaScreen> createState() => _PoliticaScreenState();
}

class _PoliticaScreenState extends State<PoliticaScreen> {
  politicaApi() async {
    final url = Uri.parse(
        '${Consts.apiPortaria}politica_privacidade/?fn=mostrarPolitica&${FuncionarioInfos.idcondominio}');
    var resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      return jsonDecode(resposta.body);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: ScaffoldAll(
        title: 'Política de Privacidade',
        body: FutureBuilder<dynamic>(
            future: politicaApi(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                if (!snapshot.data['erro']) {
                  var texto = snapshot.data['politica_privacidade'][0]['texto'];
                  return SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Padding(
                          //   padding: EdgeInsets.symmetric(
                          //       vertical: size.height * 0.04),
                          //   child: Image(
                          //     image: NetworkImage(
                          //         '${logado.arquivoAssets}logo-login-f.png'),
                          //   ),
                          // ),
                          Html(
                            data: texto,
                            style: {
                              'p': Style(fontSize: FontSize(18)),
                              'i': Style(
                                  fontSize: FontSize(18),
                                  fontStyle: FontStyle.italic),
                              'ul': Style(fontSize: FontSize(18)),
                              'strong': Style(
                                  fontSize: FontSize(18),
                                  fontWeight: FontWeight.bold)
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return PageVazia(title: snapshot.data['mensagem']);
                }
              } else {
                return PageErro();
              }
            }),
      ),
    );
  }
}
