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
import '../../../consts/consts_decoration_drop.dart';
import '../../../consts/consts_future.dart';
import 'caixas/encomendas_screen.dart';

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
      print(listarUniApi);
    } else {
      return {'erro': true, 'mensagem': 'Erro no Servidor'};
    }
  }

  resetinfos() {
    setState(() {
      hasError.clear();
      isLoading = false;
      DropSearchRemet.tituloRemente = null;
      DropSearchRemet.textoRemente = null;
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
                        text: '',
                        children: [
                          TextSpan(
                            text: 'Não avise ',
                            style: buildTextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SplashScreen.isSmall ? 18 : 20),
                          ),
                          TextSpan(
                              text: 'as unidades selecionadas abaixo:',
                              style: buildTextStyle()),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    DropdownSearch.multiSelection(
                      key: dropDownKey,
                      // selectedItems: const ['Selecione unidades se preciso'],
                      dropdownBuilder: (context, selectedItems) {
                        if (selectedItems.isEmpty) {
                          return Center(
                              child: Text('Selecione unidades se preciso'));
                        } else {
                          return Column(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: selectedItems.map((eSelec) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ConstsWidget.buildTitleText(context,
                                      sizedWidth: 0.6,
                                      overflow: null,
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
                              );
                            }).toList(),
                          );
                        }
                      },
                      // clearButtonProps: ClearButtonProps(
                      //   isVisible: true,
                      //   color: Theme.of(context).textTheme.bodyLarge!.color,
                      //   onPressed: () {
                      //     dropDownKey.currentState?.clear();
                      //     setState(() {
                      //       setState(() {
                      //         listUnidade.clear();
                      //       });
                      //     });
                      //   },
                      // ),
                      dropdownDecoratorProps:
                          DecorationDropSearch.dropdownDecoratorProps(context),
                      dropdownButtonProps:
                          DecorationDropSearch.dropdownButtonProps(context),
                      popupProps: PopupPropsMultiSelection.menu(
                        menuProps: DecorationDropSearch.menuProps(context),
                        selectionWidget: (context, item, isSelected) {
                          return ConstsWidget.buildPadding001(
                            context,
                            child: Center(
                              child: Transform.scale(
                                scale: 1,
                                child: Checkbox(
                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius: BorderRadius.circular(15),
                                  // ),
                                  value: isSelected,
                                  onChanged: (value) {
                                    isSelected == value;
                                  },
                                ),
                              ),
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
                              context, item.toString(),
                              divisor: false);
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
                              });
                            }
                          }).toString();
                        },
                        showSearchBox: true,
                        containerBuilder: (context, popupWidget) {
                          return popupWidget;
                        },
                        searchFieldProps: DecorationDropSearch.searchFieldProps(
                            context,
                            hintText: 'Procure por uma Unidade'),
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
                        color: Consts.kColorRed,
                        onPressed: () {
                          if (DropSearchRemet.tituloRemente == null) {
                            buildMinhaSnackBar(context,
                                title: 'Cuidado',
                                hasError: true,
                                subTitle: 'Selecione um Remetente');
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            enviarNotifc().then((valueList) async {
                              // $qtdCartas
                              ConstsFuture.launchGetApi(
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
                                      hasError: true,
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
