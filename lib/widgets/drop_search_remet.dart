import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../consts/consts.dart';
import '../consts/consts_decoration_drop.dart';
import '../consts/consts_widget.dart';

// ignore: must_be_immutable
class DropSearchRemet extends StatefulWidget {
  static int? idRemet;
  static String? tituloRemente;
  static String? textoRemente;
  double vertical;
  int? tipoAviso;
  // tipoAviso 3 = carta; 4 = encomenda
  DropSearchRemet({required this.tipoAviso, this.vertical = 0.02, super.key});

  @override
  State<DropSearchRemet> createState() => DropSearchRemetState();
}

class DropSearchRemetState extends State<DropSearchRemet> {
  List<ModelRemet> itemsModelRemet = <ModelRemet>[];

  Future apiListarRemetente() async {
    var url = Uri.parse(
        '${Consts.apiPortaria}msgsprontas/index.php?fn=listarMensagens&tipo=${widget.tipoAviso}&idcond=${FuncionarioInfos.idcondominio}');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      final jsonResponse = json.decode(resposta.body);
      for (var i = 0; i <= jsonResponse['msgsprontas'].length - 1; i++) {
        var apiRemetente = jsonResponse['msgsprontas'][i];

        setState(() {
          itemsModelRemet.add(
            ModelRemet(
              idRemente: apiRemetente['idmsg'],
              tituloRemente: apiRemetente['titulo'],
              textoRemente: apiRemetente['texto'],
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
    apiListarRemetente();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstsWidget.buildPadding001(
      context,
      vertical: widget.vertical,
      child: DropdownSearch(
        selectedItem: 'Selecione Um Remetente',
        dropdownDecoratorProps:
            DecorationDropSearch.dropdownDecoratorProps(context),
        dropdownButtonProps: DecorationDropSearch.dropdownButtonProps(
          context,
        ),
        dropdownBuilder: (context, selectedItem) {
          if (selectedItem == 'Selecione Um Remetente') {
            return Center(child: Text(selectedItem.toString()));
          } else {
            return DecorationDropSearch.dropDownBuilder(
                context, selectedItem.toString());
          }
        },
        popupProps: PopupProps.menu(
          menuProps: DecorationDropSearch.menuProps(context),
          itemBuilder: (context, item, isSelected) {
            return DecorationDropSearch.itemBuilder(context, item.toString());
          },
          searchFieldProps: DecorationDropSearch.searchFieldProps(context,
              hintText: 'Procure por um Remetente'),
          showSearchBox: true,
          errorBuilder: (context, searchEntry, exception) {
            return DecorationDropSearch.errorBuilder(context);
          },
          emptyBuilder: (context, searchEntry) {
            return DecorationDropSearch.emptyBuilder(context);
          },
        ),
        onChanged: (value) {
          itemsModelRemet.map((e) {
            if ('${e.tituloRemente} - ${e.textoRemente}' == value) {
              setState(() {
                DropSearchRemet.idRemet = e.idRemente;
                DropSearchRemet.tituloRemente = e.tituloRemente;
                DropSearchRemet.textoRemente = e.textoRemente;
              });
            }
          }).toSet();
        },
        items: itemsModelRemet.map((ModelRemet e) {
          return '${e.tituloRemente} - ${e.textoRemente}';
        }).toList(),
      ),
    );
  }
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
