import 'dart:io';
import 'package:app_porteiro/screens/quadro_avisos/quadro_avisos.dart';

import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../consts/consts.dart';
import '../../consts/consts_future.dart';
import '../../consts/consts_widget.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/snack_bar.dart';

class AddAvisos extends StatefulWidget {
  const AddAvisos({super.key});

  @override
  State<AddAvisos> createState() => _AddAvisosState();
}

class _AddAvisosState extends State<AddAvisos> {
  TextEditingController textoCntl = TextEditingController();
  TextEditingController tituloCntl = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  File? fileImage;
  List<String> listImage = [];
  String? nameImage = '';
  String? pathImage = '';
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StatefulBuilder(builder: (context, setState) {
      return ScaffoldAll(
        title: 'Enviar Aviso',
        body: Form(
          key: _keyForm,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.height * 0.02),
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                ConstsWidget.buildCamposObrigatorios(
                  context,
                ),
                ConstsWidget.buildMyTextFormObrigatorio(context, 'Título',
                    hintText: 'Exemplo: Manutenção do elevador do bloco C',
                    textCapitalization: TextCapitalization.words,
                    maxLength: 70,
                    controller: tituloCntl),
                ConstsWidget.buildMyTextFormObrigatorio(context, 'Descrição',
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 8,
                    maxLines: 8,
                    hintText:
                        'Exemplo: Será realizada a manutenção do elevador do bloco C a partir de amanhã (21/06) as 14h. Por favor, utilize as escadarias',
                    maxLength: 1000,
                    controller: textoCntl),
                SizedBox(
                  height: size.height * 0.01,
                ),
                ConstsWidget.buildOutlinedButton(
                  context,
                  title: 'Adicionar Arquivo',
                  onPressed: () async {
                    final picker = ImagePicker();
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    // if (pickedFile == null) return;

                    if (pickedFile != null) {
                      final file = File(pickedFile.path);
                      nameImage = pickedFile.name;
                      pathImage = pickedFile.path;
                      if (listImage.isEmpty) {
                        setState(() {
                          listImage.add(file.uri.toString());
                        });
                      } else {
                        // ignore: use_build_context_synchronously
                        buildMinhaSnackBar(context,
                            title: 'Cuidado!',
                            hasError: true,
                            subTitle: 'Permitido apenas um arquivo');
                      }
                    }
                  },
                ),
                if (listImage != [])
                  Padding(
                      padding: EdgeInsets.only(
                        bottom: size.height * 0.02,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: listImage.length,
                        itemBuilder: (context, index) {
                          return MyBoxShadow(
                            // width: size.width * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.upload_file_outlined),
                                Text(
                                  // listImage[index],
                                  '...${listImage[index].substring(listImage[index].length - 28, listImage[index].length)}',
                                ),
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      listImage.remove(listImage[index]);
                                      nameImage = '';
                                      pathImage = '';
                                    });
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      )),
                ConstsWidget.buildCustomButton(context, 'Enviar Aviso',
                    color: Consts.kColorRed, onPressed: () {
                  var formValid = _keyForm.currentState?.validate();
                  if (formValid!) {
                    upload(nameImage: nameImage, pathImage: pathImage)
                        .then((value) {
                      if (!value['erro']) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        ConstsFuture.navigatorPush(
                            context, QuadroHistoricoNotificScreen());
                        buildMinhaSnackBar(context,
                            title: 'Muito Obrigado!',
                            subTitle: value['mensagem']);
                      } else {
                        buildMinhaSnackBar(
                          context,
                          hasError: true,
                        );
                      }
                    });
                  }
                }),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future upload(
      {required String? nameImage, required String? pathImage}) async {
    var postUri = Uri.parse(
        "https://a.portariaapp.com/portaria/api/quadro_avisos/?fn=enviarAviso");

    http.MultipartRequest request = http.MultipartRequest("POST", postUri);

    if (pathImage != '') {
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
          'imagem', pathImage!,
          filename: nameImage);

      request.files.add(multipartFile);
    }
    request.fields['tipo'] = '1';
    request.fields['idcond'] = '${FuncionarioInfos.idcondominio}';
    request.fields['idfuncionario'] = '${FuncionarioInfos.idFuncionario}';
    request.fields['titulo'] = tituloCntl.text;
    request.fields['texto'] = textoCntl.text;

    var response = await request.send();

    if (response.statusCode == 200) {
      return {'erro': false, "mensagem": 'Cadastrado com Sucesso!'};
    } else {
      return {'erro': true, 'mensagem': 'Tente Novamente'};
    }
  }
}
