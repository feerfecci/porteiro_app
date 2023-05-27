// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../consts/consts.dart';
import '../consts/consts_widget.dart';
import 'package:http/http.dart' as http;

import '../screens/correspondencias/correspondencias_screen.dart';

showModalIncluiCorresp(BuildContext context,
    {required String title,
    required int idunidade,
    required int tipoAviso,
    required String? nome_responsavel,
    required String? localizado}) {
  var size = MediaQuery.of(context).size;
  showModalBottomSheet(
    enableDrag: false,
    isScrollControlled: true,
    isDismissible: false,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (context) => SizedBox(
      height: size.height * 0.85,
      child: Padding(
        padding: EdgeInsets.all(size.height * 0.01),
        child: WidgetModalCorresp(
            title: title,
            idunidade: idunidade,
            tipoAviso: tipoAviso,
            localizado: localizado,
            nome_responsavel: nome_responsavel),
      ),
    ),
  );
}

class WidgetModalCorresp extends StatefulWidget {
  final String title;
  final int idunidade;
  final int? tipoAviso;
  final String? nome_responsavel;
  final String? localizado;
  const WidgetModalCorresp(
      {required this.title,
      required this.idunidade,
      required this.tipoAviso,
      required this.nome_responsavel,
      required this.localizado,
      super.key});

  @override
  State<WidgetModalCorresp> createState() => _WidgetCusttCorrespState();
}

class _WidgetCusttCorrespState extends State<WidgetModalCorresp> {
  final _formKey = GlobalKey<FormState>();
  bool loadingRetirada = false;
  void carregandoRetirada() {
    setState(() {
      loadingRetirada = !loadingRetirada;
    });

    launchIncluiCorresp(
        idunidade: widget.idunidade,
        dataInclusao: dataInclusaoText!,
        descricao: descricaoText!,
        remetente: remetenteText!,
        tipoAviso: widget.tipoAviso!);
    Timer(Duration(seconds: 2), () {
      setState(() {
        loadingRetirada = !loadingRetirada;
        Navigator.pop(context);

        buildMinhaSnackBar(context,
            title: 'Tudo certo!', subTitle: 'Correspondencia adicionada');
        CorrespondenciasScreen(
          tipoAviso: widget.tipoAviso,
          idunidade: widget.idunidade,
          localizado: widget.localizado,
          nome_responsavel: widget.nome_responsavel,
        );
      });
    });
  }

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

        // print(
        '${Consts.apiPortaria}correspondencias/?fn=incluirCorrespondencias&idcond=${FuncionarioInfos.idcondominio}&idunidade=${widget.idunidade}&idfuncionario=${FuncionarioInfos.idFuncionario}&datarecebimento=$dataInclusao&tipo=$tipoAviso&remetente=$remetente&descricao=$descricao');
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close)),
            ],
          ),
          ConstsWidget.buildTitleText(context, title: widget.title),
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
          ConstsWidget.buildLoadingButton(
            context,
            isLoading: loadingRetirada,
            title: 'Salvar e avisar',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                carregandoRetirada();
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
