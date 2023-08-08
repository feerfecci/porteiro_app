// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'dart:convert';
import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/widgets/drop_search_remet.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../consts/consts.dart';
import '../consts/consts_widget.dart';
import 'package:http/http.dart' as http;
import '../screens/correspondencias/scafffoldItem.dart';
import 'modal_all.dart';

showModalIncluiCorresp(BuildContext context,
    {required String title,
    required int idunidade,
    required int tipoAviso,
    required String? localizado}) {
  var size = MediaQuery.of(context).size;

  buildModalAll(
    context,
    title: title,
    hasDrawer: false,
    child: WidgetModalCorresp(
      title: title,
      idunidade: idunidade,
      tipoAviso: tipoAviso,
      localizado: localizado,
    ),
  );
}

class WidgetModalCorresp extends StatefulWidget {
  final String title;
  final int idunidade;
  final int? tipoAviso;
  final String? localizado;
  const WidgetModalCorresp(
      {required this.title,
      required this.idunidade,
      required this.tipoAviso,
      required this.localizado,
      super.key});

  @override
  State<WidgetModalCorresp> createState() => _WidgetCusttCorrespState();
}

class _WidgetCusttCorrespState extends State<WidgetModalCorresp> {
  final _formKey = GlobalKey<FormState>();
  // List listaRementes = [];
  // Object? dropRemetente;
  bool loadingRetirada = false;
  // int? idmsgs;
  @override
  void initState() {
    // apiListarRemetente();
    super.initState();
  }

  bool preencheMao = false;

  void carregandoRetirada() {
    setState(() {
      loadingRetirada = true;
    });

    var seIdmsgs = remetenteText == null ? DropSearchRemet.idRemet : null;
    ConstsFuture.launchGetApi(context,
            'correspondencias/?fn=incluirCorrespondencias&idcond=${FuncionarioInfos.idcondominio}&idunidade=${widget.idunidade}&idfuncionario=${FuncionarioInfos.idFuncionario}&datarecebimento=$dataInclusaoText&tipo=${widget.tipoAviso}&remetente=$remetenteText&descricao=$descricaoText&idmsg=$seIdmsgs')
        .then((value) {
      if (!value['erro']) {
        setState(() {
          loadingRetirada = false;
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScaffoldBottom(
                        tipoAviso: widget.tipoAviso,
                        idunidade: widget.idunidade,
                        localizado: widget.localizado,
                      )));
          buildMinhaSnackBar(context,
              title: 'Tudo certo!', subTitle: value['mensagem']);
        });
      } else {
        setState(() {
          loadingRetirada = !loadingRetirada;
          buildMinhaSnackBar(context,
              title: 'Algo Saiu Mau!', subTitle: value['mensagem']);
        });
      }
    });
  }

  // Future apiListarRemetente() async {
  //   var url = Uri.parse(
  //       '${Consts.apiPortaria}msgsprontas/index.php?fn=listarMensagens&tipo=${widget.tipoAviso}&idcond=${FuncionarioInfos.idcondominio}');
  //   var resposta = await http.get(url);
  //   if (resposta.statusCode == 200) {
  //     final jsonResponse = json.decode(resposta.body);
  //     setState(() {
  //       listaRementes = jsonResponse['msgsprontas'];
  //     });
  //   } else {
  //     return {'erro': true, 'mensagem': 'Erro no Servidor'};
  //   }
  // }

  String? dataInclusaoText;
  String? remetenteText;
  String? descricaoText;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*   Widget builDropButtonRemetentes() {
      return ConstsWidget.buildPadding001(
        context,
        vertical: 0.005,
        child: Container(
          width: double.infinity,
          height: size.height * 0.07,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: ConstsWidget.buildPadding001(
            context,
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
*/
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ConstsWidget.buildClosePop(context, title: widget.title),
          if (!preencheMao)
            DropSearchRemet(
              tipoAviso: widget.tipoAviso,
            ),
          // if (!preencheMao)
          ConstsWidget.buildPadding001(
            context,
            vertical: 0.015,
            child: ConstsWidget.buildCustomButton(
                context, preencheMao ? 'Usar Padrão' : 'Personalizar',
                onPressed: () {
              setState(() {
                preencheMao = !preencheMao;
              });
            }),
          ),
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
            height: size.height * 0.015,
          ),
          ConstsWidget.buildLoadingButton(
            context,
            fontSize: 16,
            isLoading: loadingRetirada,
            color: Consts.kColorRed,
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
