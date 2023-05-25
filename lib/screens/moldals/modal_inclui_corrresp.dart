import 'dart:convert';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../consts/consts.dart';
import '../../consts/consts_widget.dart';
import 'package:http/http.dart' as http;

import '../correspondencias/correspondencias_screen.dart';

showModalIncluiCorresp(BuildContext context,
    {required String title, required int idunidade, required int tipoAviso}) {
  var size = MediaQuery.of(context).size;
  showModalBottomSheet(
    enableDrag: false,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (context) => SizedBox(
      height: size.height * 0.7,
      child: Padding(
        padding: EdgeInsets.all(size.height * 0.01),
        child: WidgetIncluiCorresp(
            title: title, idunidade: idunidade, tipoAviso: tipoAviso),
      ),
    ),
  );
}

class WidgetIncluiCorresp extends StatefulWidget {
  final String title;
  final int idunidade;
  final int? tipoAviso;
  const WidgetIncluiCorresp(
      {required this.title,
      required this.idunidade,
      required this.tipoAviso,
      super.key});

  @override
  State<WidgetIncluiCorresp> createState() => _WidgetIncluiCorrespState();
}

class _WidgetIncluiCorrespState extends State<WidgetIncluiCorresp> {
  final _formKey = GlobalKey<FormState>();
  lauchNotification(int idunidade) async {
    var url = Uri.parse(
        '${Consts.apiPortaria}notificacao/?fn=enviarNotificacoes&idcond=${FuncionarioInfos.idcondominio}&idunidade=$idunidade');
    var resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      return json.encode(resposta.body);
    } else {
      return false;
    }
  }

  launchIncluiCorresp(
      {required int idunidade,
      required String dataInclusao,
      required String remetente,
      required String descricao,
      required int tipoAviso}) async {
    var url = Uri.parse(
        '${Consts.apiPortaria}correspondencias/?fn=incluirCorrespondencias&idcond=${FuncionarioInfos.idcondominio}&idunidade=${widget.idunidade}&idfuncionario=${FuncionarioInfos.id}&datarecebimento=$dataInclusao&tipo=$tipoAviso&remetente=$remetente&descricao=$descricao');
    var resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      return json.encode(resposta.body);
    } else {
      return false;
    }
  }

  String? dataInclusaoText;
  String? remetenteText;
  String? descricaoText;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstsWidget.buildClosePop(context),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
            child: ConstsWidget.buildTitleText(context, title: widget.title),
          ),
          ConstsWidget.buildMyTextFormObrigatorio(
            context,
            'Remetente',
            onSaved: (text) {
              remetenteText = text;
            },
          ),
          ConstsWidget.buildMyTextFormObrigatorio(
            context,
            'Descrição',
            onSaved: (text) {
              descricaoText = text;
            },
          ),
          ConstsWidget.buildMyTextFormObrigatorio(
            context,
            'Data',
            inputFormatters: [MaskTextInputFormatter(mask: '##/##/####')],
            onSaved: (text) {
              var ano = text!.substring(6);
              var mes = text.substring(3, 5);

              var dia = text.substring(0, 2);
              dataInclusaoText = '$ano-$mes-$dia';
            },
            // validator: Validatorless.date('Data invalida'),
            initialValue: DateFormat('dd/MM/yyy').format(
              DateTime.now(),
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          ConstsWidget.buildCustomButton(
            context,
            'Salvar e avisar',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context);
                _formKey.currentState!.save();
                // print(dataInclusao);
                // print(remetente);
                // print(descricao);
                widget.tipoAviso == 1 || widget.tipoAviso == 2
                    ? launchIncluiCorresp(
                        idunidade: widget.idunidade,
                        dataInclusao: dataInclusaoText!,
                        descricao: descricaoText!,
                        remetente: remetenteText!,
                        tipoAviso: widget.tipoAviso!)
                    : lauchNotification(widget.idunidade);
                setState(() {
                  // Navigator.pop(context);

                  apiListarCorrespondencias(
                      idunidade: widget.idunidade,
                      tipoAviso: widget.tipoAviso!);
                });
              } else {
                buildMinhaSnackBar(
                  context,
                );
              }
            },
          )
        ],
      ),
    );
  }
}
