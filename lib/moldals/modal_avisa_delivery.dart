import 'dart:convert';

import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../consts/consts.dart';

showModalAvisaDelivery(BuildContext context) {
  var size = MediaQuery.of(context).size;
  return showModalBottomSheet(
    enableDrag: false,
    isScrollControlled: true,
    isDismissible: false,
    context: context,
    builder: (context) => SizedBox(
      height: size.height * 0.8,
      child: Scaffold(
        key: Consts.modelScaffoldKey,
        body: WidgetAvisaDelivery(),
      ),
    ),
  );
}

class WidgetAvisaDelivery extends StatefulWidget {
  const WidgetAvisaDelivery({super.key});

  @override
  State<WidgetAvisaDelivery> createState() => _WidgetAvisaDeliveryState();
}

class _WidgetAvisaDeliveryState extends State<WidgetAvisaDelivery> {
  List categoryItemListAvisos = [];
  @override
  void initState() {
    apiListarAvisos();
    super.initState();
  }

  Future apiListarAvisos() async {
    var url = Uri.parse(
        '${Consts.apiPortaria}msgsprontas/index.php?fn=listarMensagens&tipo=1&idcond=${FuncionarioInfos.idcondominio}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print(categoryItemListAvisos);
      setState(() {
        categoryItemListAvisos = jsonResponse['msgsprontas'];
        print(categoryItemListAvisos);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Object? dropdownValue;
    var size = MediaQuery.of(context).size;
    Widget buildDropButtonAvisos() {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            shape: Border.all(color: Colors.black),
            child: DropdownButton(
              value: dropdownValue,
              items: categoryItemListAvisos.map((e) {
                print(e['titulo']);
                return DropdownMenuItem(
                    value: e['idmsg'],
                    child: ListTile(
                      title: Text(e['titulo']),
                      subtitle: Text(e['texto']),
                    ));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
              elevation: 24,
              isExpanded: true,
              icon: Icon(
                Icons.arrow_downward,
                color: Theme.of(context).iconTheme.color,
              ),
              borderRadius: BorderRadius.circular(16),
              hint: Text('Selecione Uma Função'),
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w400,
                  fontSize: 18),
            ),
          ),
        ),
      );
    }

    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            ConstsWidget.buildTitleText(context, title: 'Delivery'),
            Spacer(),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close)),
          ],
        ),
        ConstsWidget.buildTitleText(context, title: 'Nome Responsável'),
        Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
          child: ConstsWidget.buildTitleText(context, title: 'Bloco C - Ap03'),
        ),
        ConstsWidget.buildTitleText(context,
            title: 'Morador 1,Morador 2,Morador 3,Morador 4'),
        ConstsWidget.buildTitleText(context, title: 'Nome Morador'),
        buildDropButtonAvisos(),
      ],
    );
  }
}
