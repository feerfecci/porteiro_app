import 'dart:io';

import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/screens/avisos/historico_notific.dart';
import 'package:app_porteiro/screens/correspondencias/correspondencias_screen.dart';
import 'package:app_porteiro/screens/correspondencias/multi_corresp/encomendas_screen.dart';
import 'package:app_porteiro/screens/quadro_avisos/quadro_avisos.dart';
import 'package:app_porteiro/screens/reservas_espacos/espacos_screen.dart';
import 'package:app_porteiro/screens/seach_pages/search_protocolo.dart';
import 'package:app_porteiro/screens/seach_pages/search_visitante.dart';
import 'package:app_porteiro/screens/visitas/visitas_screen.dart';
import 'package:app_porteiro/screens/seach_pages/search_veiculo.dart';
import 'package:app_porteiro/widgets/alertdialog_all.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../consts/consts.dart';
import '../../consts/consts_future.dart';
import '../correspondencias/multi_corresp/multicorresp_screen.dart';
import '../seach_pages/search_unidades.dart';
import '../../widgets/custom_drawer/custom_drawer.dart';
import '../../widgets/seachBar.dart';
import '../../widgets/snack_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime timeBackPressed = DateTime.now();
  Future oneSignalNotification() async {
    OneSignal.shared.setAppId("5993cb79-853a-412e-94a1-f995c9797692");
    // OneSignal.shared.promptUserForPushNotificationPermission().then((value) {
    //   // OneSignal.shared.setExternalUserId('34');
    // });
    OneSignal.shared.sendTags({
      'idfuncionario': FuncionarioInfos.idFuncionario.toString(),
      'idcond': FuncionarioInfos.idcondominio.toString(),
      'idfuncao': FuncionarioInfos.idfuncao.toString(),
    });
  }

  @override
  void initState() {
    super.initState();
    oneSignalNotification();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget buildCard({
      required String title,
      required String iconApi,
      bool avisa = true,
      bool isWhatss = false,
      bool isSearchVeiculo = false,
      void Function()? onTap,
    }) {
      return GestureDetector(
        onTap: avisa
            ? onTap
            : () {
                buildMinhaSnackBar(context,
                    title: 'Desculpe',
                    subTitle: 'Você não tem acesso à essa ação');
              },
        child: MyBoxShadow(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: ConstsFuture.apiImage(iconApi),
              builder: (context, snapshot) => SizedBox(
                width: size.width * 0.13,
                height: size.height * 0.059,
                child: Image.network(
                  iconApi,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            ConstsWidget.buildTitleText(context, title: title, fontSize: 17),
          ],
        )),
      );
    }

    Widget buildGridViewer({required List<Widget> children}) {
      return ConstsWidget.buildPadding001(
        context,
        vertical: 0,
        horizontal: 0.005,
        child: GridView.count(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            crossAxisSpacing: 5,
            mainAxisSpacing: 0.1,
            crossAxisCount: 2,
            childAspectRatio: 1.55,
            children: children),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        final differenceBack = DateTime.now().difference(timeBackPressed);
        final isExitWarning = differenceBack >= Duration(seconds: 1);
        timeBackPressed = DateTime.now();

        if (isExitWarning) {
          Fluttertoast.showToast(
              msg: 'Pressione novamente para sair',
              fontSize: 18,
              backgroundColor: Colors.black);
          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            centerTitle: true,
            title: ConstsWidget.buildTitleText(context,
                title: FuncionarioInfos.nome_condominio, fontSize: 20),
            iconTheme:
                IconThemeData(color: Theme.of(context).colorScheme.primary),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            leadingWidth: size.height * 0.06,
            leading: Padding(
              padding: EdgeInsets.only(left: size.width * 0.025),
              child: FutureBuilder(
                future: ConstsFuture.apiImage(
                  'https://a.portariaapp.com/img/logo_vermelho.png',
                ),
                builder: (context, snapshot) {
                  return SizedBox(child: snapshot.data);
                },
              ),
            ),
          ),
          endDrawer: CustomDrawer(),
          body: ListView(
            // padding: EdgeInsets.symmetric(horizontal: size.height * 0.005),
            children: [
              buildGridViewer(children: [
                buildCard(
                    title: 'Samu',
                    iconApi: '${Consts.iconApiPort}ambulancia.png',
                    onTap: () {
                      launchNumber('192');
                    },
                    isWhatss: true),
                buildCard(
                    title: 'Polícia',
                    iconApi: '${Consts.iconApiPort}policia.png',
                    onTap: () {
                      launchNumber('190');
                    },
                    isWhatss: true),
                buildCard(
                    title: 'Bombeiros',
                    onTap: () {
                      launchNumber('193');
                    },
                    iconApi: '${Consts.iconApiPort}bombeiro.png',
                    isWhatss: true),
                buildCard(
                  title: 'Quadro de Avisos',
                  iconApi: '${Consts.iconApiPort}quadrodeavisos.png',
                  onTap: () {
                    ConstsFuture.navigatorPush(
                        context, QuadroHistoricoNotificScreen());
                  },
                ),
                buildCard(
                  title: 'Reservas de Espaços',
                  iconApi: '${Consts.iconApiPort}reservas-solicitadas.png',
                  onTap: () {
                    ConstsFuture.navigatorPush(context, EspacosScreen());
                  },
                ),
                buildCard(
                  title: 'Visitante',
                  iconApi: '${Consts.iconApiPort}visitas.png',
                  onTap: () {
                    showSearch(context: context, delegate: SearchVisitante());
                    // ConstsFuture.navigatorPush(context, VisitasScreen());
                  },
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: size.width * 0.5,
                    child: ConstsWidget.buildPadding001(
                      context,
                      vertical: 0,
                      horizontal: 0.01,
                      child: GestureDetector(
                        onTap: () => showSearch(
                            context: context, delegate: SearchProtocolos()),
                        child: ConstsWidget.buildPadding001(
                          context,
                          horizontal: 0.01,
                          child: Container(
                            height: size.height * 0.085,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                border: Border.all(
                                    color: Consts.kColorRed,
                                    width: size.width * 0.007),
                                borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Spacer(flex: 3),
                                ConstsWidget.buildTitleText(context,
                                    title: 'Protocolos',
                                    textAlign: TextAlign.center),
                                Spacer(),
                                Container(
                                  height: size.height * 0.3,
                                  width: size.width * 0.1,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Consts.kColorRed,
                                  ),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    fill: 1,
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.5,
                    child: ConstsWidget.buildPadding001(
                      context,
                      vertical: 0,
                      horizontal: 0.01,
                      child: GestureDetector(
                        onTap: () => showSearch(
                            context: context, delegate: SearchUnidades()),
                        child: ConstsWidget.buildPadding001(
                          context,
                          horizontal: 0.01,
                          child: Container(
                            height: size.height * 0.085,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                border: Border.all(
                                    color: Consts.kColorRed,
                                    width: size.width * 0.007),
                                borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Spacer(flex: 3),
                                ConstsWidget.buildTitleText(context,
                                    title: 'Unidades',
                                    textAlign: TextAlign.center),
                                Spacer(),
                                Container(
                                  height: size.height * 0.3,
                                  width: size.width * 0.1,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Consts.kColorRed,
                                  ),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    fill: 1,
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              buildGridViewer(
                children: [
                  buildCard(
                    title: 'Notificações',
                    onTap: () {
                      ConstsFuture.navigatorPush(
                          context, HistoricoNotificScreen());
                    },
                    iconApi: '${Consts.iconApiPort}historico-notificacoes.png',
                  ),
                  buildCard(
                      title: 'Procurar Veículos',
                      iconApi: '${Consts.iconApiPort}pesquisa-veiculos.png',
                      onTap: () {
                        showSearch(context: context, delegate: SearchVeiculo());
                      },
                      isSearchVeiculo: true),
                  buildCard(
                    title: 'Adicionar Itens',
                    iconApi: '${Consts.iconApiPort}multi.png',
                    avisa: FuncionarioInfos.avisa_corresp,
                    onTap: () {
                      showAllDialog(context,
                          children: [
                            Column(
                              children: [
                                ConstsWidget.buildOutlinedButton(
                                  context,
                                  title: 'Várias Caixas',
                                  onPressed: () {
                                    ConstsFuture.navigatorPush(
                                        context, EncomendasScreen());
                                  },
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                ConstsWidget.buildOutlinedButton(
                                  context,
                                  title: 'Várias Cartas',
                                  onPressed: () {
                                    ConstsFuture.navigatorPush(
                                      context,
                                      MultiCorresp(),
                                    );
                                  },
                                ),
                              ],
                            )
                          ],
                          title: ConstsWidget.buildTitleText(context,
                              title: 'Escolha um modo'));
                    },
                  ),
                  buildCard(
                      title: 'Informe o Síndico',
                      isWhatss: true,
                      iconApi: '${Consts.iconApiPort}multi.png'),
                ],
              ),
            ],
          )),
    );
  }

  launchNumber(number) async {
    await launchUrl(Uri.parse('tel:$number'));
  }
}
