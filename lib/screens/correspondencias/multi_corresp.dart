import 'package:app_porteiro/consts/consts.dart';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/my_textform_field.dart';
import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MultiCorrespScreen extends StatefulWidget {
  const MultiCorrespScreen({super.key});

  @override
  State<MultiCorrespScreen> createState() => _MultiCorrespScreenState();
}

class _MultiCorrespScreenState extends State<MultiCorrespScreen> {
  final TextEditingController apCtrl = TextEditingController();
  final TextEditingController qntCtrl = TextEditingController();
  int intQnt = 0;
  final TextEditingController remetenteCtrl = TextEditingController();
  List<MultiItem> itemsMulti = <MultiItem>[];
  @override
  Widget build(BuildContext context) {
    Widget buildForm() {
      return TextFormField(
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
        decoration:
            InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 0)),
      );
    }

    var size = MediaQuery.of(context).size;
    return ScaffoldAll(
        resizeToAvoidBottomInset: true,
        title: 'Entregas',
        body: ListView(
          children: [
            MyBoxShadow(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: Column(
                  children: [
                    ConstsWidget.buildPadding001(
                      context,
                      vertical: 0.01,
                      child: ConstsWidget.buildTitleText(context,
                          title: 'Informações para o recibo'),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            ConstsWidget.buildTitleText(context, title: 'Eu'),
                            SizedBox(
                              width: size.width * 0.02,
                            ),
                            SizedBox(
                                width: size.width * 0.76,
                                child: buildMyTextFormField(context,
                                    label: 'Nome entregador completo'))
                          ],
                        ),
                        Row(
                          children: [
                            ConstsWidget.buildSubTitleText(context,
                                fontSize: 16, subTitle: 'documento'),
                            SizedBox(
                              width: size.width * 0.03,
                            ),
                            SizedBox(
                                width: size.width * 0.4,
                                child: buildMyTextFormField(context,
                                    label: 'CPF', hintText: "RG, CPF")),
                            ConstsWidget.buildSubTitleText(context,
                                fontSize: 16, subTitle: '   , declaro'),
                          ],
                        ),
                        ConstsWidget.buildPadding001(
                          context,
                          child: Row(
                            children: [
                              ConstsWidget.buildSubTitleText(context,
                                  fontSize: 16, subTitle: 'ter entregue'),
                              SizedBox(
                                width: size.width * 0.02,
                              ),
                              StatefulBuilder(builder: (context, setState) {
                                return Container(
                                    alignment: Alignment.center,
                                    width: size.width * 0.08,
                                    child: ConstsWidget.buildTitleText(context,
                                        title: '$intQnt'));
                              }),
                              SizedBox(
                                width: size.width * 0.02,
                              ),
                              ConstsWidget.buildSubTitleText(context,
                                  fontSize: 16, subTitle: 'items para as'),
                            ],
                          ),
                        ),
                        ConstsWidget.buildPadding001(
                          context,
                          child: Row(
                            children: [
                              ConstsWidget.buildSubTitleText(context,
                                  fontSize: 16,
                                  subTitle: 'unidades do condomínio '),
                              SizedBox(
                                width: size.width * 0.37,
                                child: ConstsWidget.buildTitleText(context,
                                    fontSize: 17,
                                    title: FuncionarioInfos.nome_condominio),
                              )
                            ],
                          ),
                        ),
                        ConstsWidget.buildPadding001(
                          context,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ConstsWidget.buildSubTitleText(context,
                                  fontSize: 16, subTitle: 'em: '),
                              ConstsWidget.buildTitleText(context,
                                  fontSize: 18,
                                  title: DateFormat('dd/MM/yy')
                                      .format(DateTime.now())),
                              ConstsWidget.buildSubTitleText(context,
                                  fontSize: 16, subTitle: 'as:'),
                              ConstsWidget.buildTitleText(context,
                                  fontSize: 18,
                                  title: DateFormat('HH:mm')
                                      .format(DateTime.now())),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            MyBoxShadow(
                child: Column(
              children: [
                ConstsWidget.buildPadding001(context,
                    vertical: 0.01,
                    child: ConstsWidget.buildTitleText(context,
                        title: 'Items Recebidos')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: size.width * 0.475,
                      child: buildMyTextFormField(context,
                          label: 'Unidade', controller: apCtrl),
                    ),
                    SizedBox(
                        width: size.width * 0.4,
                        child: buildMyTextFormField(context,
                            label: 'Quantidade', controller: qntCtrl))
                  ],
                ),
                buildMyTextFormField(context,
                    label: 'Remetente', controller: remetenteCtrl),
                ConstsWidget.buildPadding001(
                  context,
                  child: ConstsWidget.buildCustomButton(
                    context,
                    'Adicionar Entrega',
                    icon: Icons.add,
                    onPressed: () {
                      if (apCtrl.text != '') {
                        setState(() {
                          itemsMulti.add(MultiItem(
                              apCtrl.text, qntCtrl.text, remetenteCtrl.text));
                          intQnt = intQnt + int.parse(qntCtrl.text);
                          qntCtrl.clear();
                          apCtrl.clear();
                        });
                      } else {
                        buildMinhaSnackBar(context,
                            title: 'Cuidado',
                            subTitle: 'Preencha os campos do apartamento');
                      }
                    },
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: itemsMulti
                      .map(
                        (e) => ConstsWidget.buildPadding001(
                          context,
                          vertical: 0.005,
                          child: MyBoxShadow(
                            key: ValueKey(e),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ConstsWidget.buildTitleText(context,
                                    fontSize: 18, title: 'Unidade: ${e.ap}'),
                                ConstsWidget.buildTitleText(context,
                                    title: 'Quantidade: ${e.qnt}')
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                ConstsWidget.buildPadding001(
                  context,
                  child: ConstsWidget.buildCustomButton(
                    context,
                    'Emitir Recibo',
                    onPressed: () {},
                    icon: Icons.edit_document,
                    color: Consts.kColorRed,
                  ),
                )
              ],
            ))
          ],
        ));
  }
}

class MultiItem {
  final String ap;
  final String qnt;
  final String remetente;
  MultiItem(
    this.ap,
    this.qnt,
    this.remetente,
  );
}
