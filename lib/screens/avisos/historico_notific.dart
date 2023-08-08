// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:app_porteiro/consts/consts.dart';
import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/page_erro.dart';
import 'package:app_porteiro/widgets/page_vazia.dart';
import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:app_porteiro/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoricoNotificScreen extends StatefulWidget {
  const HistoricoNotificScreen({super.key});

  @override
  State<HistoricoNotificScreen> createState() => _HistoricoNotificScreenState();
}

class _HistoricoNotificScreenState extends State<HistoricoNotificScreen> {
  int filtrar = 1;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          ConstsFuture.launchGetApi(context,
              'msgsprontas/index.php?fn=historicoAvisos&idcond=${FuncionarioInfos.idcondominio}&resposta=$filtrar');
        });
      },
      child: ScaffoldAll(
          title: 'Histórico de Avisos',
          hasDrawer: true,
          fontSize: 26,
          body: Column(
            children: [
              ConstsWidget.buildPadding001(
                context,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ConstsWidget.buildOutlinedButton(
                      context,
                      title: 'Enviados',
                      fontSize: 18,
                      backgroundColor: filtrar == 0 ? Colors.grey[300] : null,
                      icon: Icons.mobile_friendly_sharp,
                      onPressed: () {
                        setState(() {
                          filtrar = 0;
                        });
                      },
                    ),
                    ConstsWidget.buildOutlinedButton(
                      context,
                      title: 'Recebidos',
                      fontSize: 18,
                      icon: Icons.install_mobile_rounded,
                      backgroundColor: filtrar == 1 ? Colors.grey[300] : null,
                      onPressed: () {
                        setState(() {
                          filtrar = 1;
                        });
                      },
                    ),
                  ],
                ),
              ),
              FutureBuilder<dynamic>(
                  future: ConstsFuture.launchGetApi(context,
                      'msgsprontas/index.php?fn=historicoAvisos&idcond=${FuncionarioInfos.idcondominio}&resposta=$filtrar'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return MyBoxShadow(
                          child: Column(
                        children: [ShimmerWidget(height: size.height * 0.01)],
                      ));
                    } else if (snapshot.hasData) {
                      if (!snapshot.data['erro']) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: snapshot.data['historico_avisos'].length,
                          itemBuilder: (context, index) {
                            var apiHistorico =
                                snapshot.data['historico_avisos'][index];
                            int id = apiHistorico['id'];
                            int resp_recebida_porteiro =
                                apiHistorico['resp_recebida_porteiro'];
                            int idfuncionario = apiHistorico['idfuncionario'];
                            int idmorador = apiHistorico['idmorador'];
                            String unidade = apiHistorico['unidade'];
                            String nome_morador = apiHistorico['nome_morador'];
                            int idunidade = apiHistorico['idunidade'];
                            int idcond = apiHistorico['idcond'];
                            String tipo_msg = apiHistorico['tipo_msg'];
                            String titulo = apiHistorico['titulo'];
                            String texto = apiHistorico['texto'];
                            String datahora = DateFormat('HH:mm - dd/MM')
                                .format(
                                    DateTime.parse(apiHistorico['datahora']));

                            return MyBoxShadow(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    if (nome_morador != '')
                                      ConstsWidget.buildTitleText(context,
                                          title: nome_morador),
                                    ConstsWidget.buildTitleText(context,
                                        title: unidade),
                                  ],
                                ),
                                ConstsWidget.buildPadding001(
                                  context,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ConstsWidget.buildSubTitleText(
                                            context,
                                            subTitle: 'Assunto',
                                          ),
                                          ConstsWidget.buildTitleText(context,
                                              title: tipo_msg),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ConstsWidget.buildSubTitleText(
                                            context,
                                            subTitle:
                                                '${resp_recebida_porteiro == 0 ? 'Enviado' : 'Recebido'} em',
                                          ),
                                          ConstsWidget.buildTitleText(context,
                                              title: datahora),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ConstsWidget.buildSubTitleText(
                                      context,
                                      subTitle: 'Mensagem',
                                    ),
                                    SizedBox(
                                      height: size.height * 0.005,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.9,
                                      child: ConstsWidget.buildTitleText(
                                          context,
                                          title: titulo),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.005,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.9,
                                      child: ConstsWidget.buildTitleText(
                                          context,
                                          title: texto),
                                    ),
                                  ],
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
                  }),
            ],
          )),
    );
  }
}
