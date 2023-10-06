// ignore_for_file: no_leading_underscores_for_local_identifier
import 'dart:convert';
import 'package:app_porteiro/consts/consts.dart';
import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/screens/splash/splash_screen.dart';
import 'package:app_porteiro/widgets/alertdialog_all.dart';
import 'package:app_porteiro/widgets/drop_search_remet.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';

import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'assinatura_screen.dart';

class EncomendasScreen extends StatefulWidget {
  final int? idUnidade;
  final String? localizado;
  const EncomendasScreen({this.idUnidade, this.localizado, super.key});

  @override
  State<EncomendasScreen> createState() => _EncomendasScreenState();
}

bool _isLoading = false;
bool isLoadingAlertAddCorrep = false;
setOrientation(Orientation orientation) {
  if (orientation == Orientation.landscape) {
    return SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft]);
  } else {
    return SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]);
  }
}

class _EncomendasScreenState extends State<EncomendasScreen> {
  final TextEditingController nomeEntregador = TextEditingController();
  final TextEditingController docEntregador = TextEditingController();
  final TextEditingController apCtrl = TextEditingController();
  final TextEditingController qntCtrl = TextEditingController(text: '1');

  final entregadorInfos = GlobalKey<FormState>();
  final itemsInfos = GlobalKey<FormState>();

  List<MultiItem> itemsMulti = <MultiItem>[];
  List<ModelApto> itemsModelApto = <ModelApto>[];
  List<int> listIdUnidade = [];
  List<int> listIdCorresp = [];
  int idApto = 0;
  int idRemet = 0;
  String nomeApto = '';
// ignore: prefer_final_fields
  bool _apConfirmado = false;
  Object selectedItemAP = 'Selecione uma unidade';
  // String nomeRemet = '';
  int totalQnt = 0;
  Future apiListarApartamento() async {
    var url = Uri.parse(
        '${Consts.apiPortaria}unidades/?fn=listarUnidades&idcond=${FuncionarioInfos.idcondominio}');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      final jsonResponse = json.decode(resposta.body);
      for (var i = 0; i <= jsonResponse['unidades'].length - 1; i++) {
        var apiUnidade = jsonResponse['unidades'][i];
        setState(() {
          itemsModelApto.add(
            ModelApto(
              idap: apiUnidade['idunidade'],
              nomeUnidade:
                  '${apiUnidade['dividido_por']} ${apiUnidade['nome_divisao']} - ${apiUnidade['numero']}',
            ),
          );
        });
      }
    } else {
      return {'erro': true, 'mensagem': 'Erro no Servidor'};
    }
  }

  @override
  void initState() {
    apiListarApartamento();
    nomeApto = widget.idUnidade == null ? '' : widget.localizado!;
    widget.idUnidade != null
        ? listIdUnidade.add(widget.idUnidade!)
        : listIdUnidade;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var dataNow = DateFormat('yyyy-MM-dd').format(DateTime.now());

    double? height = itemsMulti.length >= 3
        ? SplashScreen.isSmall
            ? size.height * 0.25
            : size.height * 0.35
        : null;
    Widget buildDropSearchAp() {
      return DropdownSearch(
        selectedItem: selectedItemAP,
        dropdownDecoratorProps:
            DecorationDropSearch.dropdownDecoratorProps(context),
        dropdownButtonProps: DecorationDropSearch.dropdownButtonProps(context),
        dropdownBuilder: (context, selectedItem) {
          if (!_apConfirmado) {
            if (selectedItem == 'Selecione uma unidade') {
              return Center(
                child: Text(
                  selectedItem.toString(),
                ),
              );
            } else {
              return DecorationDropSearch.dropDownBuilder(
                context,
                selectedItem.toString(),
              );
            }
          } else {
            return Center(
              child: Text('Selecione uma unidade'),
            );
          }
        },
        popupProps: PopupProps.menu(
          itemBuilder: (context, item, isSelected) {
            return DecorationDropSearch.itemBuilder(context, item.toString());
          },
          searchFieldProps: DecorationDropSearch.searchFieldProps(context),
          showSearchBox: true,
          errorBuilder: (context, searchEntry, exception) {
            return DecorationDropSearch.errorBuilder(context);
          },
          emptyBuilder: (context, searchEntry) {
            return DecorationDropSearch.emptyBuilder(context);
          },
        ),
        onChanged: (value) {
          itemsModelApto.map((e) {
            if (e.nomeUnidade == value) {
              setState(() {
                idApto = e.idap;
                listIdUnidade.add(idApto);
                nomeApto = e.nomeUnidade;
                selectedItemAP = nomeApto;
                _apConfirmado = false;
              });
            }
          }).toString();
        },
        items: itemsModelApto.map((ModelApto e) {
          return e.nomeUnidade;
        }).toList(),
      );
    }

    Widget buildListCorrep() {
      return MyBoxShadow(
        child: ConstsWidget.buildPadding001(
          context,
          horizontal: 0.01,
          child: Column(
            children: [
              ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: itemsMulti.map((e) {
                  return ConstsWidget.buildPadding001(
                    context,
                    child: Container(
                      key: ValueKey(e),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ConstsWidget.buildSubTitleText(context,
                                      subTitle: 'Unidade'),
                                  SizedBox(
                                    width: SplashScreen.isSmall
                                        ? size.width * 0.4
                                        : size.width * 0.6,
                                    child: ConstsWidget.buildTitleText(context,
                                        fontSize: 18, title: e.ap, maxLines: 3),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ConstsWidget.buildSubTitleText(context,
                                      subTitle: 'Qtd'),
                                  ConstsWidget.buildTitleText(context,
                                      title: e.qnt),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Container(
                            color: Colors.grey[300],
                            height: 1,
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              ConstsWidget.buildPadding001(
                context,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StatefulBuilder(builder: (context, setState) {
                      return ConstsWidget.buildTitleText(context,
                          textAlign: TextAlign.center,
                          fontSize: 18,
                          title: 'Quantidade total: $totalQnt');
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    alertRecibo() {
      ConstsFuture.launchGetApi(context,
              'txt_recibo/index.php?fn=mostrarRecibo&idcond=${FuncionarioInfos.idcondominio}&idfuncionario=${FuncionarioInfos.idFuncionario}&nome_entregador=${nomeEntregador.text}&documento_entregador=${docEntregador.text}&total_itens=$totalQnt&nome_remetente=${DropSearchRemet.tituloRemente}&descricao=${DropSearchRemet.textoRemente}')
          .then((value) {
        if (!value['erro']) {
          showAllDialog(context,
              title: ConstsWidget.buildTitleText(context,
                  title: 'Emissão do Recibo', fontSize: 18),
              children: [
                SizedBox(
                  height: height,
                  child: ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: [
                      buildListCorrep(),
                    ],
                  ),
                ),

                // ListView(children: [],),
                // ConstsWidget.buildPadding001(
                //   context,
                //   child:
                //   //  Text(value['Recibo'][0]
                //   //     ['txt_recibo_preenchido']),
                // ),
                Html(
                  data: value['Recibo'][0]['txt_recibo_preenchido'],
                  style: {
                    'b': Style(
                      fontWeight: FontWeight.bold,
                    ),
                  },
                ),
                ConstsWidget.buildPadding001(
                  context,
                  child: ConstsWidget.buildCustomButton(
                    context,
                    'Assinar',
                    color: Consts.kColorRed,
                    onPressed: () {
                      setOrientation(Orientation.landscape);
                      ConstsFuture.navigatorPush(
                          context,
                          AssinaturaScreen(
                            docEntregador: docEntregador.text,
                            nomeEntregador: nomeEntregador.text,
                            listIdCorresp: listIdCorresp,
                          ));
                    },
                  ),
                )
              ]);
        } else {
          buildMinhaSnackBar(context,
              subTitle: value['mensagem'], hasError: true);
        }
      });
    }

    alertConfirmaCorresp(dataNow) {
      setState(() {
        isLoadingAlertAddCorrep = false;
      });
      return showAllDialog(context,
          title: ConstsWidget.buildTitleText(context,
              title: 'Cuidado!!', fontSize: 18),
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Ao continuar você enviará um aviso para a unidade ',
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontSize: 16),
                children: [
                  TextSpan(
                      text: nomeApto,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 18)),
                  TextSpan(
                    text: ' com ',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontSize: 16),
                  ),
                  TextSpan(
                      text: qntCtrl.text,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 18)),
                  TextSpan(
                    text: ' itens',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ConstsWidget.buildOutlinedButton(
                  context,
                  title: 'Cancelar',
                  rowSpacing: 0.04,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ConstsWidget.buildLoadingButton(
                  context,
                  title: 'Continuar',
                  isLoading: _isLoading,
                  rowSpacing: 0.07,
                  color: Consts.kColorRed,
                  onPressed: () {
                    setState(() {
                      _isLoading == true;
                    });
                    ConstsFuture.launchGetApi(
                            context,
                            // ignore: prefer_if_null_operators
                            'correspondencias/?fn=incluirCorrespondenciasMulti&idcond=${FuncionarioInfos.idcondominio}&idunidade=${widget.idUnidade == null ? idApto : widget.idUnidade}&idfuncionario=${FuncionarioInfos.idFuncionario}&datarecebimento=$dataNow&tipo=4&remetente=${DropSearchRemet.tituloRemente}&descricao=${DropSearchRemet.textoRemente}&nome_entregador=${nomeEntregador.text}&doc_entregador=${docEntregador.text}&qtd=${qntCtrl.text}')
                        .then((value) {
                      setState(() {
                        _isLoading = false;
                        _apConfirmado = true;
                      });
                      if (!value['erro']) {
                        listIdCorresp.add(value['correspondencias'][0]
                            ['ultima_correspondencia']);
                        if (widget.idUnidade != null) {
                          return alertRecibo();
                        } else {
                          if (idApto != 0) {
                            setState(() {
                              itemsMulti.add(MultiItem(nomeApto, qntCtrl.text));
                              totalQnt = totalQnt + int.parse(qntCtrl.text);
                              qntCtrl.text = '1';
                            });
                            Navigator.pop(context);
                          }
                        }
                      } else {
                        buildMinhaSnackBar(context,
                            hasError: true, subTitle: value['mensagem']);
                      }
                    });
                  },
                ),
              ],
            )
          ]);
    }

    return ScaffoldAll(
        resizeToAvoidBottomInset: true,
        title: 'Entregas',
        body: Column(
          children: [
            MyBoxShadow(
                child: Column(
              children: [
                ConstsWidget.buildPadding001(
                  context,
                  child: ConstsWidget.buildSubTitleText(context,
                      subTitle: '(*) Campo Obrigatório',
                      color: Consts.kColorRed),
                ),
                Form(
                  key: entregadorInfos,
                  child: Column(
                    children: [
                      ConstsWidget.buildPadding001(
                        context,
                        vertical: 0.02,
                        child: ConstsWidget.buildTitleText(context,
                            title: 'Informações para o Recibo'),
                      ),
                      ConstsWidget.buildMyTextFormObrigatorio(
                          context, 'Nome Completo do Entregador',
                          controller: nomeEntregador),
                      ConstsWidget.buildMyTextFormObrigatorio(context, 'CPF',
                          keyboardType: TextInputType.number,
                          controller: docEntregador,
                          hintText: "CPF"),
                    ],
                  ),
                ),
                DropSearchRemet(tipoAviso: 4),
                Form(
                  key: itemsInfos,
                  child: Column(
                    children: [
                      widget.idUnidade == null
                          ? buildDropSearchAp()
                          : MyBoxShadow(
                              child: ConstsWidget.buildPadding001(
                                context,
                                child: Center(
                                  child: ConstsWidget.buildTitleText(context,
                                      title: widget.localizado!),
                                ),
                              ),
                            ),
                      SizedBox(
                        height: SplashScreen.isSmall
                            ? size.height * 0.03
                            : size.height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                backgroundColor: Consts.kColorApp),
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (qntCtrl.text != '') {
                                if (int.parse(qntCtrl.text) > 1) {
                                  setState(() {
                                    qntCtrl.text =
                                        '${int.parse(qntCtrl.text) - 1}';
                                  });
                                }
                              } else {
                                setState(() {
                                  qntCtrl.text == '1';
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
                                inputFormatters: [
                                  MaskTextInputFormatter(mask: '###')
                                ],
                                keyboardType: TextInputType.number,

                                // initialValue: qntCtrl.text
                                controller: qntCtrl),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                backgroundColor: Consts.kColorApp),
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (qntCtrl.text != '') {
                                if (int.parse(qntCtrl.text) >= 1 &&
                                    int.parse(qntCtrl.text) < 999) {
                                  setState(() {
                                    qntCtrl.text =
                                        '${int.parse(qntCtrl.text) + 1}';
                                  });
                                }
                              } else {
                                setState(() {
                                  qntCtrl.text = '1';
                                });
                              }
                            },
                            child: Icon(Icons.add),
                          ),
                        ],
                      ),
                      if (widget.idUnidade == null)
                        ConstsWidget.buildPadding001(
                          context,
                          child: ConstsWidget.buildLoadingButton(
                            context, title: 'Gravar e Adicionar Entrega',
                            isLoading: isLoadingAlertAddCorrep,
                            color: Consts.kColorVerde,
                            // icon: Icons.add,
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();

                              var itemsValid =
                                  itemsInfos.currentState?.validate() ?? false;
                              var entregadorValid =
                                  entregadorInfos.currentState?.validate() ??
                                      false;
                              if (itemsValid &&
                                  entregadorValid &&
                                  selectedItemAP == nomeApto &&
                                  !_apConfirmado &&
                                  DropSearchRemet.tituloRemente != '') {
                                setState(() {
                                  isLoadingAlertAddCorrep = true;
                                });
                                alertConfirmaCorresp(dataNow);
                              } else
                              /* if (nomeApto == '' ||
                                  DropSearchRemet.tituloRemente == '' ||
                                  selectedItemAP == 'Selecione uma unidade')*/
                              {
                                buildMinhaSnackBar(context,
                                    title: 'Cuidado!',
                                    hasError: true,
                                    subTitle:
                                        'Selecione Remetente e Apartamento');
                              }
                            },
                          ),
                        ),
                      if (widget.idUnidade == null) buildListCorrep()
                    ],
                  ),
                ),
                ConstsWidget.buildPadding001(
                  context,
                  child: ConstsWidget.buildCustomButton(
                    context,
                    'Emitir Recibo',
                    // fontSize: 16,
                    onPressed: () async {
                      if (widget.idUnidade != null) {
                        var entregadorValid =
                            entregadorInfos.currentState?.validate() ?? false;
                        var itemsValid =
                            itemsInfos.currentState?.validate() ?? false;

                        if (itemsValid && entregadorValid) {
                          if (qntCtrl.text.isNotEmpty) {
                            setState(() {
                              itemsMulti.add(
                                  MultiItem(widget.localizado!, qntCtrl.text));
                              totalQnt = totalQnt + int.parse(qntCtrl.text);

                              alertConfirmaCorresp(dataNow);
                            });
                          } else {
                            return buildMinhaSnackBar(context,
                                title: 'Cuidado',
                                hasError: true,
                                subTitle: 'Termine de adicionar');
                          }
                        } else {
                          return buildMinhaSnackBar(context,
                              title: 'Cuidado',
                              hasError: true,
                              subTitle: 'Adicione pelo menos um item');
                        }
                      } else {
                        if (listIdCorresp.isNotEmpty) {
                          alertRecibo();
                        } else {
                          return buildMinhaSnackBar(context,
                              title: 'Cuidado',
                              hasError: true,
                              subTitle: 'Termine de adicionar');
                        }
                      }
                    },
                    // icon: Icons.edit_document,
                    color: Consts.kColorRed,
                  ),
                )
              ],
            ))
          ],
        ));
  }
}

class ModelApto {
  final int idap;
  final String nomeUnidade;
  ModelApto({
    required this.idap,
    required this.nomeUnidade,
  });
}

class ModelRemet {
  final int idRemente;
  final String tituloRemente;
  final String textoRemente;
  ModelRemet({
    required this.idRemente,
    required this.tituloRemente,
    required this.textoRemente,
  });
}

class MultiItem {
  final String ap;
  final String qnt;
  MultiItem(
    this.ap,
    this.qnt,
  );
}
