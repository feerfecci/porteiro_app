import 'package:app_porteiro/consts/consts.dart';
import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/screens/home/home_page.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/page_erro.dart';
import 'package:app_porteiro/widgets/page_vazia.dart';
import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:app_porteiro/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:url_launcher/url_launcher.dart';

class QuadroHistoricoNotificScreen extends StatefulWidget {
  const QuadroHistoricoNotificScreen({super.key});

  @override
  State<QuadroHistoricoNotificScreen> createState() =>
      _QuadroHistoricoNotificScreenState();
}

class _QuadroHistoricoNotificScreenState
    extends State<QuadroHistoricoNotificScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: ScaffoldAll(
        title: 'Quadro De Avisos',
        body: FutureBuilder<dynamic>(
            future: ConstsFuture.launchGetApi(context,
                'quadro_avisos/?fn=listarAvisos&idcond=${FuncionarioInfos.idcondominio}'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ShimmerWidget(height: 10);
              } else if (snapshot.hasData) {
                if (!snapshot.data['erro']) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: snapshot.data['avisos'].length,
                    itemBuilder: (context, index) {
                      var apiAvisos = snapshot.data['avisos'][index];

                      var idaviso = apiAvisos['idaviso'];
                      var tipo = apiAvisos['tipo'];
                      var txt_tipo = apiAvisos['txt_tipo'];
                      var titulo = apiAvisos['titulo'];
                      var texto = apiAvisos['texto'];
                      var arquivo = apiAvisos['arquivo'];
                      var datahora = apiAvisos['datahora'];
                      return MyBoxShadow(
                          child: ConstsWidget.buildPadding001(
                        context,
                        child: Column(
                          children: [
                            ConstsWidget.buildTitleText(
                              context,
                              fontSize: 18,
                              title: titulo,
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            ConstsWidget.buildSubTitleText(context,
                                subTitle: 'Descrição'),
                            ConstsWidget.buildTitleText(context, title: texto),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            if (arquivo != '')
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      width: size.width * 0.005,
                                      color: Colors.blue),
                                  shape: StadiumBorder(),
                                ),
                                onPressed: () {
                                  launchUrl(Uri.parse(arquivo),
                                      mode: LaunchMode
                                          .externalNonBrowserApplication);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.023),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ConstsWidget.buildSubTitleText(
                                        context,
                                        subTitle: 'Ver Anexo',
                                        fontSize: 18,
                                        color: Colors.blue,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
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
        hasDrawer: true,
      ),
    );
  }
}
