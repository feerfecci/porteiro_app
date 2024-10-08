// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:app_porteiro/consts/consts.dart';
import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/widgets/page_erro.dart';
import 'package:app_porteiro/widgets/page_vazia.dart';
import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:app_porteiro/widgets/shimmer_widget.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../consts/consts_widget.dart';
import '../../widgets/my_box_shadow.dart';

class EspacosScreen extends StatefulWidget {
  const EspacosScreen({super.key});

  @override
  State<EspacosScreen> createState() => _EspacosScreenState();
}

class _EspacosScreenState extends State<EspacosScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: ScaffoldAll(
          title: 'Espaços Reservados',
          body: FutureBuilder<dynamic>(
              future: ConstsFuture.launchGetApi(
                  'reserva_espacos/?fn=listarReservas&idcond=${FuncionarioInfos.idcondominio}&idfuncionario=${FuncionarioInfos.idFuncionario}&ativo=1'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return MyBoxShadow(
                          child: Column(
                        children: [
                          ShimmerWidget(
                            height: size.height * 0.04,
                            width: size.width * 0.4,
                          ),
                          ConstsWidget.buildPadding001(
                            context,
                            vertical: 0.02,
                            child: ShimmerWidget(
                              height: size.height * 0.04,
                              width: size.width * 0.7,
                            ),
                          ),
                          ShimmerWidget(
                            height: size.height * 0.04,
                            width: size.width * 0.4,
                          ),
                          SizedBox(
                            height: size.height * 0.007,
                          ),
                        ],
                      ));
                    },
                  );
                } else if (snapshot.hasData) {
                  if (!snapshot.data['erro']) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data['reserva_espacos'].length,
                      itemBuilder: (context, index) {
                        var apiReservas =
                            snapshot.data['reserva_espacos'][index];
                        bool isToday = false;

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
                        String data_reserva_ini =
                            apiReservas['data_reserva_ini'];
                        String data_reserva_fim =
                            apiReservas['data_reserva_fim'];
                        String datahora = apiReservas['datahora'];

                        DateTime now = DateTime.now();
                        int difference =
                            DateTime(DateTime.parse(data_reserva_ini).day)
                                .difference(DateTime(now.day))
                                .inDays;

                        if (difference == 0) {
                          isToday = true;
                        }

                        return MyBoxShadow(
                            child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ConstsWidget.buildBadge(
                              context,
                              showBadge: isToday,
                              position:
                                  BadgePosition.topEnd(end: -size.width * 0.28),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      ConstsWidget.buildSubTitleText(context,
                                          subTitle: 'Reservado por'),
                                      SizedBox(
                                        height: size.height * 0.005,
                                      ),
                                      ConstsWidget.buildTitleText(context,
                                          sizedWidth: size.height * 0.9,
                                          textAlign: TextAlign.center,
                                          title: '$nome_morador - $unidade'),
                                    ],
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  ConstsWidget.buildPadding001(
                                    context,
                                    child: Column(
                                      children: [
                                        ConstsWidget.buildSubTitleText(context,
                                            subTitle: 'Local Reservado'),
                                        SizedBox(
                                          height: size.height * 0.005,
                                        ),
                                        ConstsWidget.buildTitleText(context,
                                            title: nome_espaco),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ConstsWidget.buildPadding001(
                                        context,
                                        child: Column(
                                          children: [
                                            ConstsWidget.buildSubTitleText(
                                                context,
                                                subTitle: 'Inicio da Reserva'),
                                            SizedBox(
                                              height: size.height * 0.005,
                                            ),
                                            ConstsWidget.buildTitleText(context,
                                                title: DateFormat(
                                                        'dd/MM/yyyy • HH:mm')
                                                    .format(DateTime.parse(
                                                        data_reserva_ini))),
                                          ],
                                        ),
                                      ),
                                      ConstsWidget.buildPadding001(
                                        context,
                                        child: Column(
                                          children: [
                                            ConstsWidget.buildSubTitleText(
                                                context,
                                                subTitle: 'Término da Reserva'),
                                            SizedBox(
                                              height: size.height * 0.005,
                                            ),
                                            ConstsWidget.buildTitleText(context,
                                                title: DateFormat(
                                                        'dd/MM/yyyy • HH:mm')
                                                    .format(DateTime.parse(
                                                        data_reserva_fim))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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
              })),
    );
  }
}
