// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/screens/correspondencias/multi_corresp/encomendas_screen.dart';
import 'package:app_porteiro/screens/home/home_page.dart';
import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import '../../../consts/consts.dart';
import 'package:http/http.dart' as http;

class AssinaturaScreen extends StatefulWidget {
  final String nomeEntregador;
  final String docEntregador;
  final List<int> listIdCorresp;
  const AssinaturaScreen(
      {required this.nomeEntregador,
      required this.docEntregador,
      required this.listIdCorresp,
      super.key});

  @override
  State<AssinaturaScreen> createState() => _AssinaturaScreenState();
}

bool _isLoading = false;

class _AssinaturaScreenState extends State<AssinaturaScreen> {
  SignatureController controllerAssinatura = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white);

  var signature;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ScaffoldAll(
        title: 'Assinatura',
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Signature(
              controller: controllerAssinatura,
              height: size.height * 0.6,
              width: size.width * 0.9,
              backgroundColor: Colors.white,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ConstsWidget.buildOutlinedButton(
                  context,
                  title: 'Voltar',
                  onPressed: () {
                    controllerAssinatura.clear();
                    Navigator.pop(context);
                  },
                ),
                ConstsWidget.buildCustomButton(
                  context,
                  'Limpar',
                  onPressed: () {
                    setState(() {
                      controllerAssinatura.clear();
                    });
                  },
                ),
                ConstsWidget.buildLoadingButton(
                  context,
                  title: 'Salvar',
                  isLoading: _isLoading,
                  color: Consts.kColorRed,
                  onPressed: () async {
                    if (controllerAssinatura.isNotEmpty) {
                      signature = await exportController();
                      setState(() {
                        signature;
                        _isLoading == true;
                      });
                      final tempDir = await getTemporaryDirectory();

                      File fileToBeUploaded =
                          await File('${tempDir.path}/imageAssinatura.png')
                              .create();
                      fileToBeUploaded.writeAsBytesSync(signature);
                      upload(
                              nameImage: 'imageAssinatura.png',
                              pathImage: fileToBeUploaded.path)
                          .then((value) {
                        setState(() {
                          _isLoading == false;
                        });
                        if (!value['erro']) {
                          setOrientation(Orientation.portrait);
                          ConstsFuture.navigatorPushRemoveUntil(
                              context, HomePage());
                          buildMinhaSnackBar(context,
                              title: 'Tudo Certo!',
                              subTitle: value['mensagem']);
                        } else {
                          buildMinhaSnackBar(context,
                              title: 'Algo Saiu mal!',
                              hasError: true,
                              subTitle: value['mensagem']);
                        }
                      });
                    } else {
                      buildMinhaSnackBar(context,
                          title: 'Cuidado!',
                          hasError: true,
                          subTitle: 'Faça uma assinatura');
                    }
                  },
                )
              ],
            ),
          ],
        ));
  }

  Future<Uint8List?> exportController() async {
    final exportController = SignatureController(
      points: controllerAssinatura.points,
    );
    final signature = await exportController.toPngBytes();
    exportController.dispose();
    return signature;
  }

  Future upload(
      {required String? nameImage, required String? pathImage}) async {
    var postUri = Uri.parse(
        "https://a.portariaapp.com/portaria/api/assinatura_entregador/?fn=gravarDados");

    http.MultipartRequest request = http.MultipartRequest("POST", postUri);

    if (pathImage != '') {
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
          'imagem', pathImage!,
          filename: nameImage);

      request.files.add(multipartFile);
    }
    request.fields['idcond'] = '${FuncionarioInfos.idcondominio}';
    request.fields['nome_entregador'] = widget.nomeEntregador;
    request.fields['documento_entregador'] = widget.docEntregador;
    request.fields['lista_correspondencias'] = widget.listIdCorresp.toString();

    var response = await request.send();
    if (response.statusCode == 200) {
      return {'erro': false, "mensagem": 'Cadastrado com Sucesso!'};
    } else {
      return {'erro': true, 'mensagem': 'Tente Novamente'};
    }
  }
}
