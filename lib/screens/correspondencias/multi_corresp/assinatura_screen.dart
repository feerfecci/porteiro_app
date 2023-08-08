import 'dart:convert';

import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import '../../../consts/consts.dart';

class AssinaturaScreen extends StatefulWidget {
  final String nomeEntregador;
  final String docEntregador;
  const AssinaturaScreen(
      {required this.nomeEntregador, required this.docEntregador, super.key});

  @override
  State<AssinaturaScreen> createState() => _AssinaturaScreenState();
}

class _AssinaturaScreenState extends State<AssinaturaScreen> {
  SignatureController controllerAssinatura = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white);

  var exportedImage;
  String? image64;
  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  // }

  // Image imageFromBase64String(String base64String) {
  //   return Image.memory(base64Decode(base64String));
  // }

  // Uint8List dataFromBase64String(String base64String) {
  //   return base64Decode(base64String);
  // }

  // String base64String(Uint8List data) {
  //   return base64Encode(data);
  // }

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
              // height: 200,
              // width: 400,
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
                    controllerAssinatura.clear();
                    SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.portraitUp]);
                  },
                ),
                ConstsWidget.buildCustomButton(
                  context,
                  'Salvar',
                  color: Consts.kColorRed,
                  onPressed: () async {
                    exportedImage = await controllerAssinatura.toPngBytes();
                    if (exportedImage != null) {
                      image64 = base64.encode(
                        exportedImage!,
                      );

                      XFile xFile = XFile.fromData(exportedImage);

                      print(xFile.path);

                      // var imageDecode = base64.decode(image64!);
                      // Image asdsa = imageFromBase64String(image64!);

                      // print([image64]);
                      // print(imageDecode);
                      // ConstsFuture.launchGetApi(context,
                      //         'assinatura_entregador/?fn=gravarDados&idcond=${FuncionarioInfos.idcondominio}&nome_entregador=${widget.nomeEntregador}&documento_entregador=${widget.docEntregador}&img_assinatura=${image64}')
                      //     .then((value) {
                      //
                      //   if (!value['erro']) {
                      //     buildMinhaSnackBar(context,
                      //         title: 'Passou API', subTitle: value['mensagem']);
                      //   } else {
                      //     buildMinhaSnackBar(context,
                      //         subTitle: value['mensagem']);
                      //   }
                      // });
                    } else {
                      buildMinhaSnackBar(
                        context,
                        title: 'Cuidado!',
                        subTitle: 'Preencha a assinatura',
                      );
                    }
                  },
                )
              ],
            ),
            // if (exportedImage != null) imageFromBase64String(image64!),
          ],
        ));
  }
}
