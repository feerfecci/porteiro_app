// ignore_for_file: non_constant_identifier_names
import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/screens/correspondencias/cartas_caixas_screen/scafffold_item.dart';
import 'package:app_porteiro/widgets/date_picker.dart';
import 'package:app_porteiro/widgets/drop_search_remet.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../consts/consts.dart';
import '../../../consts/consts_widget.dart';

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
    ConstsFuture.launchGetApi(
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
                        setState(() {
                          remetenteText = text;
                        });
                      },
                    ),
                    ConstsWidget.buildMyTextFormObrigatorio(
                      context,
                      'Descrição',
                      onSaved: (text) {
                        setState(() {
                          descricaoText = text;
                        });
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                  ],
                ),
              ConstsWidget.buildCustomButton(
                  context, preencheMao ? 'Usar Padrão' : 'Personalizar',
                  onPressed: () {
                setState(() {
                  preencheMao = !preencheMao;
                });
              }),

              ConstsWidget.buildPadding001(context,
                  vertical: 0.02, child: MyDatePicker()),
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
                              qtdCartas.text =
                                  '${int.parse(qtdCartas.text) - 1}';
                            });
                          }
                        } else {
                          setState(() {
                            qtdCartas.text == '1';
                          });
                        }
                      },
                      child: Icon(Icons.remove, color: Colors.white)),
                  SizedBox(
                    height: size.height * 0.1,
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
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
              ConstsWidget.buildPadding001(
                context,
                child: ConstsWidget.buildLoadingButton(
                  context,
                  isLoading: loadingRetirada,
                  color: Consts.kColorRed,
                  title: 'Salvar e avisar',
                  onPressed: () {
                    _formKey.currentState!.save();
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
