// ignore_for_file: non_constant_identifier_names
import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/screens/correspondencias/cartas_caixas_screen/scafffold_item.dart';
import 'package:app_porteiro/widgets/date_picker.dart';
import 'package:app_porteiro/widgets/drop_search_remet.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../consts/consts.dart';
import '../../../consts/consts_widget.dart';

// showModalIncluiCorresp(BuildContext context,
//     {required String title,
//     required int idunidade,
//     required int tipoAviso,
//     required String? localizado}) {
//   // var size = MediaQuery.of(context).size;

//   buildModalAll(
//     context,
//     title: title,
//     hasDrawer: false,
//     child: AddCorrespScreen(
//       title: title,
//       idunidade: idunidade,
//       tipoAviso: tipoAviso,
//       localizado: localizado,
//     ),
//   );
// }

class AddCorrespScreen extends StatefulWidget {
  final String title;
  final int idunidade;
  final int? tipoAviso;
  final String? localizado;
  const AddCorrespScreen(
      {required this.title,
      required this.idunidade,
      required this.tipoAviso,
      required this.localizado,
      super.key});

  @override
  State<AddCorrespScreen> createState() => _WidgetCusttCorrespState();
}

class _WidgetCusttCorrespState extends State<AddCorrespScreen> {
  TextEditingController qtdCartas = TextEditingController(text: '1');
  final _formKey = GlobalKey<FormState>();
  bool loadingRetirada = false;
  @override
  void initState() {
    super.initState();
  }

  bool preencheMao = false;

  void carregandoRetirada() {
    setState(() {
      loadingRetirada = true;
    });

    var seIdmsgs = remetenteText == null ? DropSearchRemet.idRemet : null;
    ConstsFuture.launchGetApi(context,
            'correspondencias/?fn=incluirCorrespondencias&idcond=${FuncionarioInfos.idcondominio}&idunidade=${widget.idunidade}&idfuncionario=${FuncionarioInfos.idFuncionario}&datarecebimento=${MyDatePicker.dataSelected}&tipo=${widget.tipoAviso}&remetente=$remetenteText&descricao=$descricaoText${seIdmsgs != null ? '&idmsg=$seIdmsgs' : ''}&qtd=${qtdCartas.text}')
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
              hasError: true,
              title: 'algo saiu mal!',
              subTitle: value['mensagem']);
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
    return ScaffoldAll(
      title: widget.title,
      body: Form(
        key: _formKey,
        child: MyBoxShadow(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (preencheMao)
                ConstsWidget.buildCamposObrigatorios(
                  context,
                ),
              // ConstsWidget.buildClosePop(context, title: widget.title),
              if (!preencheMao)
                DropSearchRemet(
                  tipoAviso: widget.tipoAviso,
                ),
              // if (!preencheMao)
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

              ConstsWidget.buildPadding001(context, child: MyDatePicker()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: Consts.kColorApp),
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (qtdCartas.text != '') {
                        if (int.parse(qtdCartas.text) > 1) {
                          setState(() {
                            qtdCartas.text = '${int.parse(qtdCartas.text) - 1}';
                          });
                        }
                      } else {
                        setState(() {
                          qtdCartas.text == '1';
                        });
                      }
                    },
                    child: Text(
                      '-',
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.3,
                    child: ConstsWidget.buildMyTextFormObrigatorio(
                        context, 'Quantidade',
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        // maxLength: 3,
                        // initialValue: qtdCartas.text
                        inputFormatters: [MaskTextInputFormatter(mask: '###')],
                        controller: qtdCartas),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: Consts.kColorApp),
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (qtdCartas.text != '' &&
                          int.parse(qtdCartas.text) < 999) {
                        setState(() {
                          qtdCartas.text = '${int.parse(qtdCartas.text) + 1}';
                        });
                      } else if (qtdCartas.text != '' &&
                          int.parse(qtdCartas.text) == 999) {
                        buildMinhaSnackBar(context,
                            hasError: true,
                            title: 'Cuidado',
                            subTitle: 'Máximo de 999 itens');
                      } else {
                        setState(() {
                          qtdCartas.text = '1';
                        });
                      }
                    },
                    child: Icon(Icons.add),
                  ),
                ],
              ),
              //  ConstsWidget.buildMyTextFormObrigatorio(
              //     context, 'Quantidade',
              //     controller: qtdCartas,
              //     keyboardType: TextInputType.number),

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
                  if (_formKey.currentState!.validate() &&
                      ((remetenteText != null &&
                              DropSearchRemet.idRemet == null) ||
                          (DropSearchRemet.idRemet != null))) {
                    _formKey.currentState!.save();

                    carregandoRetirada();
                  } else {
                    buildMinhaSnackBar(context,
                        hasError: true, subTitle: 'Preencha todos os campos');
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
