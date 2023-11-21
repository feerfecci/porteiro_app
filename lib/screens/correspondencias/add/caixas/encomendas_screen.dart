// ignore_for_file: no_leading_underscores_for_local_identifier
import 'dart:async';
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
import '../../../../consts/consts_decoration_drop.dart';
import '../../../../widgets/add_remove.dart';
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
bool remetentePersonalizado = false;
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
  final TextEditingController remetenteText = TextEditingController();
  final TextEditingController descricaoText = TextEditingController();
  final TextEditingController apCtrl = TextEditingController();
  final TextEditingController qntCtrl = TextEditingController(text: '1');

  final entregadorInfos = GlobalKey<FormState>();
  final itemsInfos = GlobalKey<FormState>();
  final formRemetentePers = GlobalKey<FormState>();

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
    remetentePersonalizado = false;
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
          menuProps: DecorationDropSearch.menuProps(context),
          itemBuilder: (context, item, isSelected) {
            return DecorationDropSearch.itemBuilder(context, item.toString());
          },
          searchFieldProps: DecorationDropSearch.searchFieldProps(context,
              hintText: 'Procure por uma Unidade'),
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
      );
    }

    alertRecibo() {
      ConstsFuture.launchGetApi(
              'txt_recibo/index.php?fn=mostrarRecibo&idcond=${FuncionarioInfos.idcondominio}&idfuncionario=${FuncionarioInfos.idFuncionario}&nome_entregador=${nomeEntregador.text}&documento_entregador=${docEntregador.text}&total_itens=$totalQnt&nome_remetente=${remetenteText.text.isNotEmpty ? remetenteText.text : DropSearchRemet.tituloRemente}&descricao=${descricaoText.text.isNotEmpty ? descricaoText.text : DropSearchRemet.textoRemente}')
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
                SizedBox(
                  height: size.height * 0.01,
                ),
                if (itemsMulti.length >= 3)
                  SizedBox(
                    // height: 1,
                    child: Icon(
                      Icons.arrow_circle_down_rounded,
                    ),
                    // decoration: BoxDecoration(
                    //     border: Border.all(
                    //         color: Theme.of(context).colorScheme.primary)),
                  ),
                Html(
                  data: value['Recibo'][0]['txt_recibo_preenchido'],
                  style: {
                    'b': Style(
                      height: Height(1.5),
                      alignment: Alignment.center,
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
                StatefulBuilder(builder: (context, setState) {
                  return ConstsWidget.buildLoadingButton(
                    context,
                    title: 'Continuar',
                    isLoading: _isLoading,
                    rowSpacing: SplashScreen.isSmall ? 0.04 : 0.06,
                    color: Consts.kColorRed,
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      ConstsFuture.launchGetApi(
                              // ignore: prefer_if_null_operators
                              'correspondencias/?fn=incluirCorrespondenciasMulti&idcond=${FuncionarioInfos.idcondominio}&idunidade=${widget.idUnidade == null ? idApto : widget.idUnidade}&idfuncionario=${FuncionarioInfos.idFuncionario}&datarecebimento=$dataNow&tipo=4&remetente=${remetentePersonalizado ? remetenteText.text : DropSearchRemet.tituloRemente}&descricao=${remetentePersonalizado ? remetenteText.text : DropSearchRemet.textoRemente}&nome_entregador=${nomeEntregador.text}&doc_entregador=${docEntregador.text}&qtd=${qntCtrl.text}')
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
                                itemsMulti
                                    .add(MultiItem(nomeApto, qntCtrl.text));
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
                  );
                }),
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
                  vertical: 0.01,
                  child: ConstsWidget.buildTitleText(context,
                      title: 'Informações para o Recibo'),
                ),
                ConstsWidget.buildCamposObrigatorios(
                  context,
                ),
                Form(
                  key: entregadorInfos,
                  child: Column(
                    children: [
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
                if (!remetentePersonalizado)
                  DropSearchRemet(tipoAviso: 4, vertical: 0.01),
                if (remetentePersonalizado)
                  Form(
                    key: formRemetentePers,
                    child: Column(
                      children: [
                        ConstsWidget.buildMyTextFormObrigatorio(
                            context, 'Remetente',
                            controller: remetenteText),
                        ConstsWidget.buildMyTextFormObrigatorio(
                            context, 'Descrição',
                            controller: descricaoText),
                      ],
                    ),
                  ),
                ConstsWidget.buildPadding001(
                  context,
                  child: ConstsWidget.buildCustomButton(
                    context,
                    !remetentePersonalizado
                        ? 'Personalizar'
                        : 'Mensagens Prontas',
                    color: Consts.kColorVerde,
                    onPressed: () {
                      setState(() {
                        remetentePersonalizado = !remetentePersonalizado;
                        DropSearchRemet.tituloRemente = '';
                        DropSearchRemet.textoRemente = '';
                        DropSearchRemet.idRemet = null;
                        remetenteText.clear();
                        descricaoText.clear();
                      });
                    },
                  ),
                ),
                Form(
                  key: itemsInfos,
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      widget.idUnidade == null
                          ? buildDropSearchAp()
                          : Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    width: 1,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )),
                              child: ConstsWidget.buildPadding001(
                                context,
                                vertical: 0.02,
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
                      AddRemoveFild(qntCtrl: qntCtrl),
                      if (widget.idUnidade == null)
                        ConstsWidget.buildPadding001(
                          context,
                          child: ConstsWidget.buildLoadingButton(
                            context, title: 'Gravar e Adicionar Entrega',
                            isLoading: isLoadingAlertAddCorrep,
                            // icon: Icons.add,
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();

                              var itemsValid =
                                  itemsInfos.currentState?.validate() ?? false;
                              var entregadorValid =
                                  nomeEntregador.text.isNotEmpty &&
                                          docEntregador.text.isNotEmpty
                                      ? true
                                      : false;
                              var remetentePersValid =
                                  formRemetentePers.currentState?.validate() ??
                                      false;
                              if (itemsValid &&
                                  entregadorValid &&
                                  selectedItemAP == nomeApto &&
                                  !_apConfirmado &&
                                  (remetentePersonalizado && remetentePersValid
                                      ? remetenteText.text.isNotEmpty &&
                                          remetenteText.text.isNotEmpty
                                      : DropSearchRemet.tituloRemente != '')) {
                                setState(() {
                                  isLoadingAlertAddCorrep = true;
                                });
                                alertConfirmaCorresp(dataNow);
                              } else if (!entregadorValid) {
                                buildMinhaSnackBar(context,
                                    title: 'Cuidado',
                                    hasError: true,
                                    subTitle: 'Complete o Cadastro');
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
                        var entregadorValid = nomeEntregador.text.isNotEmpty &&
                                docEntregador.text.isNotEmpty
                            ? true
                            : false;
                        var itemsValid =
                            itemsInfos.currentState?.validate() ?? false;
                        var remetentePersValid =
                            formRemetentePers.currentState?.validate() ?? false;

                        if (itemsValid &&
                            entregadorValid &&
                            (remetentePersonalizado
                                ? remetentePersValid
                                : DropSearchRemet.textoRemente!.isNotEmpty)) {
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
                        } else if (!entregadorValid) {
                          return buildMinhaSnackBar(context,
                              title: 'Cuidado',
                              hasError: true,
                              subTitle: 'Complete o Cadastro');
                        } else if (remetentePersValid) {
                          return buildMinhaSnackBar(context,
                              title: 'Cuidado',
                              hasError: true,
                              subTitle: 'Complete o Cadastro');
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
                ),
                SizedBox(
                  height: size.height * 0.005,
                ),
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
