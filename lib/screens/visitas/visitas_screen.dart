import 'package:app_porteiro/consts/consts.dart';
import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/widgets/alertdialog_all.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/page_erro.dart';
import 'package:app_porteiro/widgets/page_vazia.dart';
import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:app_porteiro/widgets/shimmer_widget.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

class VisitasScreen extends StatefulWidget {
  const VisitasScreen({super.key});

  @override
  State<VisitasScreen> createState() => _VisitasScreenState();
}

class _VisitasScreenState extends State<VisitasScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: ScaffoldAll(
          hasDrawer: true,
          title: 'Visitas Agendadas',
          body: FutureBuilder<dynamic>(
              future: ConstsFuture.launchGetApi(context,
                  'lista_visitantes/?fn=listarVisitantes&idcond=${FuncionarioInfos.idcondominio}'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return MyBoxShadow(
                      child: ShimmerWidget(height: size.height * 0.01));
                } else if (snapshot.hasData) {
                  if (!snapshot.data['erro']) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data['ListaVisitantes'].length,
                      itemBuilder: (context, index) {
                        var apiVisitas =
                            snapshot.data['ListaVisitantes'][index];

                        var idvisita = apiVisitas['idvisita'];
                        var idcond = apiVisitas['idcond'];
                        var nome_condominio = apiVisitas['nome_condominio'];
                        var idunidade = apiVisitas['idunidade'];
                        var unidade = apiVisitas['unidade'];
                        var convidado_por = apiVisitas['convidado_por'];
                        var idmorador = apiVisitas['idmorador'];
                        var nome_convidado = apiVisitas['nome_convidado'];
                        var doc_convidado = apiVisitas['doc_convidado'];
                        var acompanhante = apiVisitas['acompanhante'];
                        var datahora_visita = DateFormat('HH:mm - dd/MM/yyyy')
                            .format(
                                DateTime.parse(apiVisitas['datahora_visita']));
                        var confirmado = apiVisitas['confirmado'];
                        var autorizado = apiVisitas['autorizado'];

                        return MyBoxShadow(
                            child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ConstsWidget.buildSubTitleText(context,
                                        subTitle: 'Nome Convidado'),
                                    ConstsWidget.buildTitleText(context,
                                        title: '$nome_convidado'),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ConstsWidget.buildSubTitleText(context,
                                        subTitle: 'Documento'),
                                    ConstsWidget.buildPadding001(
                                      context,
                                      child: ConstsWidget.buildTitleText(
                                          context,
                                          title: '$doc_convidado'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (acompanhante != null)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ConstsWidget.buildSubTitleText(context,
                                          subTitle: 'Nome Acompanhante'),
                                      ConstsWidget.buildTitleText(context,
                                          title: '$acompanhante'),
                                    ],
                                  ),
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
                                      ConstsWidget.buildSubTitleText(context,
                                          subTitle: 'Nome Anfitrião'),
                                      ConstsWidget.buildTitleText(context,
                                          title: '$convidado_por'),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ConstsWidget.buildSubTitleText(context,
                                          subTitle: 'Local'),
                                      ConstsWidget.buildPadding001(
                                        context,
                                        child: ConstsWidget.buildTitleText(
                                            context,
                                            title: '$unidade'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ConstsWidget.buildTitleText(context,
                                    title: datahora_visita),
                                ConstsWidget.buildAtivoInativo(
                                    context, autorizado,
                                    verdadeiro: 'Autorizado',
                                    falso: 'Recusado'),
                              ],
                            ),
                            ConstsWidget.buildPadding001(
                              context,
                              child: ConstsWidget.buildOutlinedButton(
                                context,
                                title: 'Anunciar Visita',
                                onPressed: () {
                                  double? fontSize = 18;
                                  TextStyle styleBold = TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19);
                                  TextStyle style = TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: fontSize,
                                      height: size.height * 0.002);
                                  showAllDialog(context,
                                      title: ConstsWidget.buildTitleText(
                                          context,
                                          title: 'Anunciar Visita'),
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                              style: styleBold,
                                              text: 'Cuidado!!  ',
                                              children: [
                                                TextSpan(
                                                  text:
                                                      'Após confirmar a visita, o condômino será avisado e não poderá mais voltar a ação',
                                                  style: styleBold,
                                                ),
                                              ]),
                                        ),
                                        ConstsWidget.buildPadding001(
                                          context,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ConstsWidget.buildOutlinedButton(
                                                context,
                                                title: 'Cancelar',
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              SizedBox(
                                                  width: size.width * 0.02),
                                              ConstsWidget.buildCustomButton(
                                                context,
                                                'Confirmar',
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  buildMinhaSnackBar(context,
                                                      title: 'Obrigado',
                                                      subTitle:
                                                          'A visita confirmada e condômino avisado');
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ]);
                                },
                              ),
                            )
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
