import 'package:app_porteiro/consts/consts.dart';
import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/widgets/page_erro.dart';
import 'package:app_porteiro/widgets/page_vazia.dart';
import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../consts/consts_widget.dart';
import '../../widgets/alertdialog_all.dart';
import '../../widgets/my_box_shadow.dart';
import '../../widgets/snack_bar.dart';

class EspacosScreen extends StatefulWidget {
  const EspacosScreen({super.key});

  @override
  State<EspacosScreen> createState() => _EspacosScreenState();
}

class _EspacosScreenState extends State<EspacosScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ScaffoldAll(
        hasDrawer: true,
        title: 'Espaços',
        body: FutureBuilder<dynamic>(
            future: ConstsFuture.launchGetApi(context,
                'reserva_espacos/?fn=listarReservas&idcond=${FuncionarioInfos.idcondominio}&ativo=2'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return MyBoxShadow(
                    child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ConstsWidget.buildSubTitleText(context,
                            subTitle: 'Reservado por: '),
                        ConstsWidget.buildTitleText(context,
                            title: 'Ferando Amorim Fecci'),
                      ],
                    ),
                    ConstsWidget.buildPadding001(
                      context,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ConstsWidget.buildSubTitleText(context,
                              subTitle: 'Local Reservado: '),
                          ConstsWidget.buildTitleText(context,
                              title: 'Churrasqueira Bloco 2'),
                        ],
                      ),
                    ),
                    ConstsWidget.buildPadding001(
                      context,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ConstsWidget.buildSubTitleText(context,
                              subTitle: 'Inicio da reserva:'),
                          ConstsWidget.buildTitleText(context, title: '15:00'),
                        ],
                      ),
                    ),
                  ],
                ));
              } else if (snapshot.hasData) {
                if (!snapshot.data['erro']) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: snapshot.data['reserva_espacos'].length,
                    itemBuilder: (context, index) {
                      var apiReservas = snapshot.data['reserva_espacos'][index];

                      int idreserva = apiReservas['idreserva'];
                      int status = apiReservas['status'];
                      String texto_status = apiReservas['texto_status'];
                      int idespaco = apiReservas['idespaco'];
                      String nome_espaco = apiReservas['nome_espaco'];
                      int idcondominio = apiReservas['idcondominio'];
                      String nome_condominio = apiReservas['nome_condominio'];
                      int idmorador = apiReservas['idmorador'];
                      String nome_morador = apiReservas['nome_morador'];
                      int idunidade = apiReservas['idunidade'];
                      String unidade = apiReservas['unidade'];
                      String data_reserva = apiReservas['data_reserva'];
                      String datahora = apiReservas['datahora'];

                      return MyBoxShadow(
                          child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ConstsWidget.buildSubTitleText(context,
                                  subTitle: 'Reservado por: '),
                              ConstsWidget.buildTitleText(context,
                                  title: nome_morador),
                            ],
                          ),
                          ConstsWidget.buildPadding001(
                            context,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ConstsWidget.buildSubTitleText(context,
                                    subTitle: 'Local Reservado: '),
                                ConstsWidget.buildTitleText(context,
                                    title: nome_espaco),
                              ],
                            ),
                          ),
                          ConstsWidget.buildPadding001(
                            context,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ConstsWidget.buildSubTitleText(context,
                                    subTitle: 'Inicio da reserva:'),
                                ConstsWidget.buildTitleText(context,
                                    title: data_reserva),
                              ],
                            ),
                          ),
                        ],
                      ));
                    },
                  );
                } else {
                  return PageVazia(title: snapshot.data['mensagem']);
                }
              } else {
                return PageErro();
              }
            }));
  }
}
