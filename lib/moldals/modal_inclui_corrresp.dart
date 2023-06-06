// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:http/http.dart';
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
  List listaRementes = [];
  Object? dropRemetente;
  bool loadingRetirada = false;
  @override
  void initState() {
    apiListarRemetente();
    super.initState();
  }

  bool preencheMao = false;

  void carregandoRetirada() {
    setState(() {
      loadingRetirada = !loadingRetirada;
    });
    var idmsg = remetenteText == null ? dropRemetente : null;

    Timer(Duration(seconds: 2), () {
      ConstsFuture.launchGetApi(
              'correspondencias/?fn=incluirCorrespondencias&idcond=${FuncionarioInfos.idcondominio}&idunidade=${widget.idunidade}&idfuncionario=${FuncionarioInfos.idFuncionario}&datarecebimento=$dataInclusaoText&tipo=${widget.tipoAviso}&remetente=$remetenteText&descricao=$descricaoText&idmsg=$idmsg')
          .then((value) {
        if (!value['erro']) {
          setState(() {
            loadingRetirada = !loadingRetirada;
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CorrespondenciasScreen(
                          tipoAviso: widget.tipoAviso,
                          idunidade: widget.idunidade,
                          localizado: widget.localizado,
                          nome_responsavel: widget.nome_responsavel,
                        )));
            buildMinhaSnackBar(context,
                title: 'Tudo certo!', subTitle: value['mensagem']);
          });
        } else {
          buildMinhaSnackBar(context,
              title: 'Algo Saiu Mau!', subTitle: value['mensagem']);
        }
      });
    });
  }

  Future apiListarRemetente() async {
    var url = Uri.parse(
        '${Consts.apiPortaria}msgsprontas/index.php?fn=listarMensagens&tipo=${widget.tipoAviso}&idcond=${FuncionarioInfos.idcondominio}');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      final jsonResponse = json.decode(resposta.body);
      setState(() {
        listaRementes = jsonResponse['msgsprontas'];
      });
    } else {
      return {'erro': true, 'mensagem': 'Erro no Servidor'};
    }
  }

  String? dataInclusaoText;
  String? remetenteText;
  String? descricaoText;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget builDropButtonRemetentes() {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
        child: Container(
          width: double.infinity,
          height: size.height * 0.07,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton(
                  value: dropRemetente,
                  items: listaRementes.map((e) {
                    return DropdownMenuItem(
                        value: e['idmsg'],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstsWidget.buildTitleText(context,
                                title: e['titulo']),
                            ConstsWidget.buildSubTitleText(context,
                                subTitle: e['texto']),
                          ],
                        ));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      dropRemetente = value;
                    });
                  },
                  elevation: 24,
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_downward,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  hint: Text('Selecione Um Aviso'),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Spacer(),
              ConstsWidget.buildTitleText(context, title: widget.title),
              Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close)),
            ],
          ),
          if (!preencheMao) builDropButtonRemetentes(),
          // if (!preencheMao)
          ConstsWidget.buildCustomButton(
              context, preencheMao ? 'Usar Padrão' : 'Personalizar',
              onPressed: () {
            setState(() {
              preencheMao = !preencheMao;
            });
          }),
          if (preencheMao)
            Column(
              children: [
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
              ],
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
                // print(
                //     'correspondencias/?fn=incluirCorrespondencias&idcond=${FuncionarioInfos.idcondominio}&idunidade=${widget.idunidade}&idfuncionario=${FuncionarioInfos.idFuncionario}&datarecebimento=$dataInclusaoText&tipo=${widget.tipoAviso}&remetente=$remetenteText&descricao=$descricaoText&idmsg=$dropRemetente');
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
