import 'dart:convert';

import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/main.dart';
import 'package:app_porteiro/widgets/drop_search_remet.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../consts/consts.dart';
import 'encomendas_screen.dart';

class MultiCorresp extends StatefulWidget {
  const MultiCorresp({super.key});

  @override
  State<MultiCorresp> createState() => _MultiCorrespState();
}

class _MultiCorrespState extends State<MultiCorresp> {
  List<ModelApto> itemsModelApto = <ModelApto>[];
  List<int> listAptos = <int>[];

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldAll(
        title: 'Cartas',
        body: Column(
          children: [
            MyBoxShadow(
              child: Column(
                children: [
                  DropSearchRemet(tipoAviso: 3),
                  DropdownSearch.multiSelection(
                    dropdownDecoratorProps:
                        DecorationDropSearch.dropdownDecoratorProps(context),
                    dropdownButtonProps:
                        DecorationDropSearch.dropdownButtonProps(context),
                    // onChanged: (value) {
                    //   itemsModelApto.map((e) {
                    //     if (e.nomeUnidade == value) {
                    //       setState(() {
                    //         listAptos.add(e.idap);
                    //       });
                    //     }
                    //   }).toString();
                    // },
                    popupProps: PopupPropsMultiSelection.menu(
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
                                listAptos.remove(e.idap);
                              });
                            }
                          }).toString();
                        },

                        onItemAdded: (selectedItems, addedItem) {
                          itemsModelApto.map((e) {
                            if (e.nomeUnidade == addedItem.toString()) {
                              setState(() {
                                listAptos.add(e.idap);
                                print(selectedItems);
                              });
                            }
                          }).toString();
                        },
                        showSearchBox: true,
                        searchFieldProps:
                            DecorationDropSearch.searchFieldProps(context)),
                    items: itemsModelApto.map((ModelApto e) {
                      return e.nomeUnidade;
                    }).toList(),
                  ),
                  ConstsWidget.buildPadding001(
                    context,
                    child: ConstsWidget.buildOutlinedButton(
                      context,
                      title: 'Print',
                      onPressed: () {
                        print(listAptos);
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
