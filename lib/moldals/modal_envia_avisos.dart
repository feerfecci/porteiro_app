// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/moldals/modal_all.dart';
import 'package:app_porteiro/widgets/my_textform_field.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../consts/consts.dart';
import '../consts/consts_future.dart';

showModalAvisaDelivery(
  BuildContext context, {
  required int? idunidade,
  required String? localizado,
  required int? tipoAviso,
  required String title,
  String? nomeCadastrado,
  int? idVisita,
  // required String nome_moradores
}) {
  return buildModalAll(context,
      title: title,
      hasDrawer: false,
      child: WidgetAvisaDelivery(
          idunidade: idunidade,
          localizado: localizado,
          tipoAviso: tipoAviso,
          nomeCadastrado: nomeCadastrado,
          idVisita: idVisita
          // nome_moradores: nome_moradores
          ));
}

class WidgetAvisaDelivery extends StatefulWidget {
  final int? idunidade;
  final String? localizado;
  final int? tipoAviso;
  final String? nomeCadastrado;
  final int? idVisita;
  // final String? nome_moradores;
  const WidgetAvisaDelivery(
      {required this.idunidade,
      super.key,
      required this.localizado,
      required this.tipoAviso,
      this.nomeCadastrado,
      this.idVisita
      // required this.nome_moradores,
      });

  @override
  State<WidgetAvisaDelivery> createState() => _WidgetAvisaDeliveryState();
}

class _WidgetAvisaDeliveryState extends State<WidgetAvisaDelivery> {
  var keyFormField = GlobalKey<FormState>();
  String? nomeVisitante;
  List categoryItemListAvisos = [];
  Object? dropdownValue;
  @override
  void initState() {
    apiListarAvisos();
    super.initState();
  }

  Future apiListarAvisos() async {
    var url = Uri.parse(
        '${Consts.apiPortaria}msgsprontas/index.php?fn=listarMensagens&tipo=${widget.tipoAviso}&idcond=${FuncionarioInfos.idcondominio}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        categoryItemListAvisos = jsonResponse['msgsprontas'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget buildDropButtonAvisos() {
      return ConstsWidget.buildPadding001(
        context,
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
                // shape: Border.all(color: Colors.black),
                child: DropdownButton(
                  value: dropdownValue,
                  items: categoryItemListAvisos.map((e) {
                    return DropdownMenuItem(
                        value: e['idmsg'],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstsWidget.buildTitleText(
                              context,
                              title: e['titulo'],
                            ),
                            Expanded(
                              child: ConstsWidget.buildSubTitleText(context,
                                  subTitle: e['texto'], fontSize: 16),
                            )
                          ],
                        ));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      dropdownValue = value;
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

    return Form(
      key: keyFormField,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstsWidget.buildPadding001(
            context,
            vertical: 0.02,
            child: ConstsWidget.buildTitleText(context,
                title: widget.localizado!, fontSize: 22),
          ),
          // SizedBox(
          //     height: size.height * 0.1,
          //     width: size.width * 0.9,
          //     child: ConstsWidget.buildTitleText(context,
          //         title: widget.nome_moradores)),
          buildDropButtonAvisos(),
          buildMyTextFormObrigatorio(
            context,
            widget.tipoAviso == 1 ? 'Nome Restaurante' : 'Nome Visitante',
            hintText: 'Exemplo: Gustavo da Silva Sousa',
            initialValue: widget.nomeCadastrado,
            onSaved: (text) => nomeVisitante = text,
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          ConstsWidget.buildCustomButton(
            context,
            'Avisar Apartamento',
            color: Consts.kColorRed,
            onPressed: dropdownValue != null
                ? () {
                    var validForm = keyFormField.currentState!.validate();
                    if (validForm) {
                      keyFormField.currentState!.save();

                      int respostaTipo;

                      if (widget.tipoAviso == 1) {
                        respostaTipo = 5;
                      } else if (widget.tipoAviso == 2) {
                        respostaTipo = 6;
                      } else if (widget.tipoAviso == 3) {
                        respostaTipo = 7;
                      } else {
                        respostaTipo = 8;
                      }
                      ConstsFuture.launchGetApi(context,
                              'msgsprontas/index.php?fn=enviarMensagem&idcond=${FuncionarioInfos.idcondominio}&idmsg=$dropdownValue&idunidade=${widget.idunidade}&idfuncionario=${FuncionarioInfos.idFuncionario}&nome_visitante=${widget.idVisita == null ? nomeVisitante : widget.nomeCadastrado}&tipo=$respostaTipo')
                          .then((value) {
                        if (!value['erro']) {
                          Navigator.pop(context);
                          if (widget.idVisita != null) {
                            ConstsFuture.launchGetApi(context,
                                'lista_visitantes/?fn=compareceuVisitante&idcond=${FuncionarioInfos.idcondominio}&idvisita=${widget.idVisita}');
                          }
                          return buildMinhaSnackBar(context,
                              title: 'Aviso Enviado',
                              subTitle: value['mensagem']);
                        } else {
                          return buildMinhaSnackBar(context,
                              title: 'Que pena!', subTitle: value['mensagem']);
                        }
                      });
                    }
                  }
                : () {
                    buildMinhaSnackBar(context,
                        subTitle: 'Escolha um aviso para seguir');
                  },
          )
        ],
      ),
    );
  }
}
