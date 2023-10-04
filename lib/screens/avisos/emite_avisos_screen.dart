import 'dart:convert';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../consts/consts.dart';
import '../../consts/consts_future.dart';

class EmiteAvisosScreen extends StatefulWidget {
  final int? idunidade;
  final String? localizado;
  final int? tipoAviso;
  final String? nomeCadastrado;
  final String? title;
  final int? idVisita;
  const EmiteAvisosScreen(
      {required this.idunidade,
      super.key,
      required this.localizado,
      required this.title,
      required this.tipoAviso,
      this.nomeCadastrado,
      this.idVisita});

  @override
  State<EmiteAvisosScreen> createState() => _EmiteAvisosScreenState();
}

bool isLoading = false;

class _EmiteAvisosScreenState extends State<EmiteAvisosScreen> {
  final keyFormField = GlobalKey<FormState>();
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
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return ScaffoldAll(
      title: widget.title,
      body: ConstsWidget.buildPadding001(
        context,
        horizontal: 0.02,
        child: Form(
          key: keyFormField,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ConstsWidget.buildCamposObrigatorios(
                context,
              ),
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
              ConstsWidget.buildMyTextFormObrigatorio(
                context,
                widget.tipoAviso == 1
                    ? 'Nome Restaurante'
                    : 'Nome e Documento Visitante',
                hintText: 'Exemplo: Gustavo da Silva Sousa',
                initialValue: widget.nomeCadastrado,
                onSaved: (text) => nomeVisitante = text,
              ),

              SizedBox(
                height: size.height * 0.01,
              ),
              ConstsWidget.buildLoadingButton(
                context,
                title: 'Enviar Aviso',
                isLoading: isLoading,
                color: Consts.kColorRed,
                onPressed: dropdownValue != null
                    ? () {
                        setState(() {
                          isLoading = true;
                        });
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
                          FocusManager.instance.primaryFocus!.unfocus();
                          ConstsFuture.launchGetApi(context,
                                  'msgsprontas/index.php?fn=enviarMensagem&idcond=${FuncionarioInfos.idcondominio}&idfuncionario=${FuncionarioInfos.idFuncionario}&idmsg=$dropdownValue&idunidade=${widget.idunidade}&idfuncionario=${FuncionarioInfos.idFuncionario}&nome_visitante=${widget.idVisita == null ? nomeVisitante : widget.nomeCadastrado}&tipo=$respostaTipo')
                              .then((value) {
                            if (!value['erro']) {
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pop(context);
                              if (widget.idVisita != null) {
                                ConstsFuture.launchGetApi(context,
                                    'lista_visitantes/?fn=compareceuVisitante&idcond=${FuncionarioInfos.idcondominio}&idfuncionario=${FuncionarioInfos.idFuncionario}&idvisita=${widget.idVisita}');
                              }
                              return buildMinhaSnackBar(context,
                                  title: 'Aviso Enviado',
                                  subTitle: value['mensagem']);
                            } else {
                              return buildMinhaSnackBar(context,
                                  title: 'Que pena!',
                                  hasError: true,
                                  subTitle: value['mensagem']);
                            }
                          });
                        }
                      }
                    : () {
                        buildMinhaSnackBar(context,
                            hasError: true,
                            subTitle: 'Escolha um aviso para seguir');
                      },
              )
            ],
          ),
        ),
      ),
    );
  }
}
