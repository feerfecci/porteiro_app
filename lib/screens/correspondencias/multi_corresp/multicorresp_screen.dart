import 'dart:async';
import 'dart:convert';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/screens/splash/splash_screen.dart';
import 'package:app_porteiro/widgets/drop_search_remet.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../consts/consts.dart';
import '../../../consts/consts_future.dart';
import 'encomendas_screen.dart';

class MultiCartas extends StatefulWidget {
  const MultiCartas({super.key});

  @override
  State<MultiCartas> createState() => _MultiCartasState();
}

bool isLoading = false;
// List<Map<String, dynamic>> hasError = [];
Map<String, dynamic> hasError = {};
bool? isErro;

class _MultiCartasState extends State<MultiCartas> {
  final dropDownKey = GlobalKey<DropdownSearchState>();
  List<ModelApto> itemsModelApto = <ModelApto>[];
  List<int> listarUniApi = <int>[];
  List<int> listUnidade = <int>[];

  var now = DateFormat('yyyy-MM-dd').format(DateTime.now());
  Future apiListarApartamento() async {
    var url = Uri.parse(
        '${Consts.apiPortaria}unidades/?fn=listarUnidades&idcond=${FuncionarioInfos.idcondominio}');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      final jsonResponse = json.decode(resposta.body);
      for (var i = 0; i <= jsonResponse['unidades'].length - 1; i++) {
        var apiUnidade = jsonResponse['unidades'][i];
        setState(() {
          listarUniApi.add(apiUnidade['idunidade']);
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

  resetinfos() {
    setState(() {
      hasError.clear();
      isLoading = false;
      DropSearchRemet.tituloRemente == null;
      DropSearchRemet.textoRemente == null;
    });
  }

  @override
  void initState() {
    apiListarApartamento();
    resetinfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    TextStyle buildTextStyle({
      double? fontSize,
      FontWeight? fontWeight,
    }) {
      return TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize ?? 18,
          height: 1.5,
          color: Consts.kColorRed);
    }

    return RefreshIndicator(
      onRefresh: () async {
        resetinfos();
      },
      child: ScaffoldAll(
          title: 'Cartas',
          body: Column(
            children: [
              MyBoxShadow(
                child: Column(
                  children: [
                    DropSearchRemet(tipoAviso: 3),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Aqui você avisará ',
                        style: buildTextStyle(),
                        children: [
                          TextSpan(
                            text: 'todas as unidades',
                            style: buildTextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SplashScreen.isSmall ? 18 : 20),
                          ),
                          TextSpan(
                              text: ', exceto quais selecionar abaixo',
                              style: buildTextStyle()),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    DropdownSearch.multiSelection(
                      key: dropDownKey,
                      dropdownBuilder: (context, selectedItems) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: selectedItems.map((eSelec) {
                            return ConstsWidget.buildPadding001(
                              context,
                              child: Container(
                                decoration: UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ConstsWidget.buildTitleText(context,
                                        title: eSelec.toString()),
                                    IconButton(
                                        onPressed: () {
                                          itemsModelApto.map((e) {
                                            if (e.nomeUnidade == eSelec) {
                                              setState(() {
                                                listUnidade.remove(e.idap);
                                                selectedItems.remove(eSelec);
                                              });
                                            }
                                          }).toString();
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        )),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                      clearButtonProps: ClearButtonProps(
                        isVisible: true,
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          dropDownKey.currentState?.clear();
                          setState(() {
                            setState(() {
                              listUnidade.clear();
                            });
                          });
                        },
                      ),
                      dropdownDecoratorProps:
                          DecorationDropSearch.dropdownDecoratorProps(context),
                      dropdownButtonProps:
                          DecorationDropSearch.dropdownButtonProps(context),
                      popupProps: PopupPropsMultiSelection.menu(
                        selectionWidget: (context, item, isSelected) {
                          return Transform.scale(
                            scale: 1.3,
                            child: Checkbox(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              value: isSelected,
                              onChanged: (value) {
                                isSelected == value;
                              },
                            ),
                          );
                        },
                        emptyBuilder: (context, searchEntry) {
                          return DecorationDropSearch.emptyBuilder(context);
                        },
                        errorBuilder: (context, searchEntry, exception) {
                          return DecorationDropSearch.errorBuilder(context);
                        },
                        itemBuilder: (context, item, isSelected) {
                          return DecorationDropSearch.itemBuilder(
                              context, item.toString());
                        },
                        onItemRemoved: (selectedItems, removedItem) {
                          itemsModelApto.map((e) {
                            if (e.nomeUnidade == removedItem.toString()) {
                              setState(() {
                                listUnidade.remove(e.idap);
                              });
                            }
                          }).toString();
                        },
                        onItemAdded: (selectedItems, addedItem) {
                          itemsModelApto.map((e) {
                            if (e.nomeUnidade == addedItem.toString()) {
                              setState(() {
                                listUnidade.add(e.idap);
                                // print(selectedItems);
                              });
                            }
                          }).toString();
                        },
                        showSearchBox: true,
                        containerBuilder: (context, popupWidget) {
                          return MyBoxShadow(child: popupWidget);
                        },
                        searchFieldProps:
                            DecorationDropSearch.searchFieldProps(context),
                      ),
                      items: itemsModelApto.map((ModelApto e) {
                        return e.nomeUnidade;
                      }).toList(),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    ConstsWidget.buildPadding001(
                      context,
                      child: ConstsWidget.buildLoadingButton(
                        context,
                        isLoading: isLoading,
                        title: 'Gravar e Avisar',
                        onPressed: () {
                          if (DropSearchRemet.tituloRemente == null) {
                            buildMinhaSnackBar(context,
                                title: 'Cuidado',
                                subTitle: 'Selecione um Remetente');
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            enviarNotifc().then((valueList) async {
                              // $qtdCartas
                              ConstsFuture.launchGetApi(context,
                                      'correspondencias/?fn=incluirCorrespondenciasMultiLista&idcond=${FuncionarioInfos.idcondominio}&listaunidades=${valueList.join(',')}&idfuncionario=${FuncionarioInfos.idFuncionario}&datarecebimento=$now&tipo=3&remetente=${DropSearchRemet.tituloRemente}&descricao=${DropSearchRemet.textoRemente}')
                                  .then((value) {
                                setState(() {
                                  isLoading = false;
                                });
                                if (!value['erro']) {
                                  ConstsFuture.navigatorPopPush(
                                      context, '/homePage');
                                  buildMinhaSnackBar(context,
                                      title: 'Tudo certo',
                                      subTitle: value['mensagem']);
                                } else {
                                  buildMinhaSnackBar(context,
                                      title: 'Algo Saiu mal',
                                      subTitle: value['mensagem']);
                                }
                              });
                            });
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Future<List<int>> enviarNotifc() async {
    listUnidade.map((e) {
      listarUniApi.remove(e);
    }).toSet();

    return listarUniApi;
  }
}
