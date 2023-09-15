import 'dart:convert';

import 'package:app_porteiro/screens/splash/splash_screen.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:http/http.dart' as http;
import '../../consts/consts.dart';
import '../../consts/consts_future.dart';
import '../../consts/consts_widget.dart';
import '../../widgets/page_erro.dart';
import '../../widgets/page_vazia.dart';
import '../home/home_page.dart';

showDialogAceitar(
  BuildContext context,
  // {
  //   required String title,
  // required List<Widget> children,
  // bool barrierDismissible = false
  // }
) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AceitarTermosScreen();
      });
}

class AceitarTermosScreen extends StatefulWidget {
  const AceitarTermosScreen({super.key});

  @override
  State<AceitarTermosScreen> createState() => _AceitarTermosScreenState();
}

politicaApi() async {
  final url = Uri.parse(
      '${Consts.apiPortaria}termo_uso/?fn=mostrarTermo&idcond=${FuncionarioInfos.idcondominio}');
  var resposta = await http.get(url);

  if (resposta.statusCode == 200) {
    return jsonDecode(resposta.body);
  } else {
    return null;
  }
}

bool isChecked = false;

class _AceitarTermosScreenState extends State<AceitarTermosScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: size.height * 0.05),
      content: SizedBox(
        width: size.width * 0.98,
        child: Column(
          children: [
            FutureBuilder<dynamic>(
                future: politicaApi(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    if (!snapshot.data['erro']) {
                      var texto = snapshot.data['termo_uso'][0]['texto'];
                      return SizedBox(
                        height: SplashScreen.isSmall
                            ? size.height * 0.06
                            : size.height * 0.63,
                        child: ListView(
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
                                'p': Style(
                                    fontSize: FontSize(16),
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                'i': Style(
                                    fontSize: FontSize(16),
                                    fontStyle: FontStyle.italic),
                                'ul': Style(fontSize: FontSize(14)),
                                'strong': Style(
                                    fontSize: FontSize(16),
                                    fontWeight: FontWeight.bold)
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return PageVazia(title: snapshot.data['mensagem']);
                    }
                  } else {
                    return PageErro();
                  }
                }),
            StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    ConstsWidget.buildCheckBox(context, isChecked: isChecked,
                        onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                      });
                    }, title: 'Li e aceito os termos'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ConstsWidget.buildOutlinedButton(
                          context,
                          title: '  Cancelar  ',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        ConstsWidget.buildCustomButton(
                          context,
                          '    Aceitar    ',
                          color: isChecked ? Consts.kColorRed : Colors.grey,
                          onPressed: isChecked
                              ? () {
                                  ConstsFuture.launchGetApi(context,
                                          'termo_uso/?fn=aceitaTermo&idfuncionario=${FuncionarioInfos.idFuncionario}')
                                      .then((value) {
                                    if (!value['erro']) {
                                      ConstsFuture.navigatorPopAndPush(
                                          context, HomePage());
                                    } else {
                                      buildMinhaSnackBar(context,
                                          title: 'Algo Saiu Mau!',
                                          hasError: true,
                                          subTitle: value['mensagem']);
                                    }
                                  });
                                }
                              : () {},
                        )
                      ],
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
