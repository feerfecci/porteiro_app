// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/screens/avisos/historico_notific.dart';
import 'package:app_porteiro/screens/correspondencias/multi_corresp/encomendas_screen.dart';
import 'package:app_porteiro/screens/quadro_avisos/quadro_avisos.dart';
import 'package:app_porteiro/screens/reservas_espacos/espacos_screen.dart';
import 'package:app_porteiro/screens/seach_pages/search_protocolo.dart';
import 'package:app_porteiro/screens/seach_pages/search_visitante.dart';
import 'package:app_porteiro/screens/splash/splash_screen.dart';
import 'package:app_porteiro/screens/seach_pages/search_veiculo.dart';
import 'package:app_porteiro/widgets/alertdialog_all.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/page_erro.dart';
import 'package:app_porteiro/widgets/page_vazia.dart';
import 'package:app_porteiro/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../consts/consts.dart';
import '../../consts/consts_future.dart';
import '../correspondencias/multi_corresp/multicorresp_screen.dart';
import '../seach_pages/search_unidades.dart';
import '../../widgets/custom_drawer/custom_drawer.dart';
import '../../widgets/snack_bar.dart';

import 'package:badges/badges.dart' as badges;

class HomePage extends StatefulWidget {
  static int qntEventos = 0;
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime timeBackPressed = DateTime.now();
  Future oneSignalNotification() async {
    OneSignal.shared.setAppId("5993cb79-853a-412e-94a1-f995c9797692");
    OneSignal.shared.promptUserForPushNotificationPermission().then((value) {
      // OneSignal.shared.setExternalUserId('34');
      if (value) {
        OneSignal.shared.sendTags({
          'idfuncionario': FuncionarioInfos.idFuncionario.toString(),
          'idcond': FuncionarioInfos.idcondominio.toString(),
          'idfuncao': FuncionarioInfos.idfuncao.toString(),
        });
      }
      OneSignal.shared.setNotificationOpenedHandler((openedResult) {
        if (openedResult.notification.additionalData!.values.last == 'aviso') {
          ConstsFuture.navigatorPush(context, QuadroHistoricoNotificScreen());
        } else if (openedResult.notification.additionalData!.values.last ==
                'visita' ||
            openedResult.notification.additionalData!.values.last ==
                'delivery') {
          ConstsFuture.navigatorPush(context, HistoricoNotificScreen());
        }
      });
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
    alertMultiCorresp() {
      showAllDialog(context,
          children: [
            Column(
              children: [
                ConstsWidget.buildOutlinedButton(
                  context,
                  title: 'Várias Caixas',
                  onPressed: () {
                    ConstsFuture.navigatorPush(context, EncomendasScreen());
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
                      MultiCartas(),
                    );
                  },
                ),
              ],
            )
          ],
          title:
              ConstsWidget.buildTitleText(context, title: 'Escolha um modo'));
    }

    alertInformeSindico() {
      showAllDialog(context,
          children: [
            FutureBuilder<dynamic>(
                future: ConstsFuture.launchGetApi(context,
                    'contato_sindicos/?fn=telefonesSindicos&idcond=${FuncionarioInfos.idcondominio}'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return MyBoxShadow(
                        child: Column(
                      children: const [ShimmerWidget(height: 40)],
                    ));
                  } else if (snapshot.hasData) {
                    if (!snapshot.data['erro']) {
                      return ListView.builder(
                        itemCount: snapshot.data['telefonesSindicos'].length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var apiContatos =
                              snapshot.data['telefonesSindicos'][index];
                          var idfuncionario = apiContatos['idfuncionario'];
                          var idcond = apiContatos['idcond'];
                          var nome_funcionario =
                              apiContatos['nome_funcionario'];
                          var telefone = apiContatos['telefone'];
                          var whatsapp = apiContatos['whatsapp'];
                          return ConstsWidget.buildPadding001(
                            context,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    width: 1,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              child: ConstsWidget.buildPadding001(
                                context,
                                horizontal: 0.02,
                                vertical: 0.015,
                                child: Row(
                                  children: [
                                    ConstsWidget.buildTitleText(context,
                                        sizedWidth: 0.4,
                                        title: nome_funcionario),
                                    // Column(
                                    //   crossAxisAlignment:
                                    //       CrossAxisAlignment.start,
                                    //   children: [
                                    //     ConstsWidget.buildSubTitleText(context,
                                    //         subTitle: nome_funcionario),
                                    //     ConstsWidget.buildTitleText(context,
                                    //         title: telefone),
                                    //   ],
                                    // ),
                                    Spacer(
                                      flex: 3,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        launchNumber(telefone);
                                      },
                                      icon: Icon(Icons.phone),
                                    ),
                                    if (whatsapp != '') Spacer(),
                                    if (whatsapp != '')
                                      IconButton(
                                          onPressed: () {
                                            launchUrl(
                                                Uri.parse(
                                                    'https://wa.me/+55$whatsapp'),
                                                mode: LaunchMode
                                                    .externalApplication);
                                          },
                                          icon: Icon(Icons.chat)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return PageVazia(title: snapshot.data['mensagem']);
                    }
                  } else {
                    return PageErro();
                  }
                })
          ],
          title: ConstsWidget.buildTitleText(context,
              title: 'Escolha um contato', fontSize: 20));
    }

    Widget buildCard({
      required String title,
      required String iconApi,
      bool avisa = true,
      bool isWhatss = false,
      bool isSearchVeiculo = false,
      bool idEspacos = false,
      void Function()? onTap,
    }) {
      return GestureDetector(
        onTap: avisa
            ? onTap
            : () {
                buildMinhaSnackBar(context,
                    title: 'Desculpe',
                    hasError: true,
                    subTitle: 'Você não tem acesso à essa ação');
              },
        child: MyBoxShadow(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstsWidget.buildBadge(
              context,
              // QuadroHistoricoNotificScreen.qntAvisos.isNotEmpty,

              showBadge: title == 'Quadro de Avisos' &&
                      QuadroHistoricoNotificScreen.qntAvisos.isNotEmpty
                  ? true
                  : idEspacos
                      ? HomePage.qntEventos != 0
                      : false,
              title: title == 'Quadro de Avisos'
                  ? QuadroHistoricoNotificScreen.qntAvisos.length
                  : HomePage.qntEventos,
              position: badges.BadgePosition.topEnd(top: -15, end: -55),

              child: ConstsWidget.buildCachedImage(
                context,
                iconApi: iconApi,
                height: SplashScreen.isSmall ? 0.06 : 0.065,
                width: SplashScreen.isSmall ? 0.13 : 0.14,
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            ConstsWidget.buildTitleText(context,
                title: title, fontSize: SplashScreen.isSmall ? 15 : 17),
          ],
        )),
      );
    }

    Widget buildGridViewer({required List<Widget> children}) {
      return ConstsWidget.buildPadding001(
        context,
        vertical: 0,
        horizontal: SplashScreen.isSmall ? 0.015 : 0.005,
        child: GridView.count(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            crossAxisSpacing: 5,
            mainAxisSpacing: SplashScreen.isSmall ? 0.2 : 0.1,
            crossAxisCount: 2,
            childAspectRatio: SplashScreen.isSmall ? 1.65 : 1.55,
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
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            ConstsFuture.apiTotalResarvaHoje(context);
            HomePage.qntEventos;
          });
        },
        child: Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              centerTitle: true,
              title: ConstsWidget.buildTitleText(context,
                  title: FuncionarioInfos.nome_condominio!, fontSize: 20),
              iconTheme:
                  IconThemeData(color: Theme.of(context).colorScheme.primary),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              leadingWidth: size.width * 0.13,
              leading: Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.025,
                    top: size.height * 0.01,
                    bottom: size.height * 0.01,
                  ),
                  child: Center(
                    child: ConstsWidget.buildCachedImage(
                      context,
                      iconApi:
                          'https://a.portariaapp.com/img/logo_vermelho.png',
                    ),
                  )

                  //  FutureBuilder(
                  //   future: ConstsFuture.apiImage(
                  //     'https://a.portariaapp.com/img/logo_vermelho.png',
                  //   ),
                  //   builder: (context, snapshot) {
                  //     return SizedBox(child: snapshot.data);
                  //   },
                  // ),
                  ),
            ),
            endDrawer: CustomDrawer(),
            body: ListView(
              // padding: EdgeInsets.symmetric(horizontal: size.height * 0.005),
              children: [
                buildGridViewer(children: [
                  buildCard(
                      title: 'Bombeiros',
                      onTap: () {
                        launchNumber('193');
                      },
                      iconApi: '${Consts.iconApiPort}bombeiro.png',
                      isWhatss: true),
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
                    title: 'Quadro de Avisos',
                    iconApi: '${Consts.iconApiPort}quadrodeavisos.png',
                    onTap: () {
                      ConstsFuture.navigatorPush(
                          context, QuadroHistoricoNotificScreen());
                    },
                  ),
                  // badges.Badge(
                  //   showBadge: HomePage.qntEventos != 0,
                  //   badgeAnimation:
                  //       badges.BadgeAnimation.fade(toAnimate: false),
                  //   badgeContent: ConstsWidget.buildTitleText(context,
                  //       title: HomePage.qntEventos.toString(),
                  //       color: Colors.white),
                  //   position: badges.BadgePosition.topEnd(),
                  //   badgeStyle: badges.BadgeStyle(
                  //     badgeColor: Consts.kColorRed,
                  //   ),
                  //   child:
                  // ),
                  buildCard(
                    title: 'Espaços Reservados',
                    idEspacos: true,
                    iconApi: '${Consts.iconApiPort}reservas-solicitadas.png',
                    onTap: () {
                      ConstsFuture.navigatorPush(context, EspacosScreen());
                    },
                  ),
                  buildCard(
                    title: 'Visitas Cadastradas',
                    iconApi: '${Consts.iconApiPort}visitas.png',
                    onTap: () {
                      showSearch(context: context, delegate: SearchVisitante());
                      // ConstsFuture.navigatorPush(context, VisitasScreen());
                    },
                  ),
                ]),
                ConstsWidget.buildPadding001(
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
                                color: Color.fromARGB(255, 39, 211, 104),
                                width: size.width * 0.007),
                            borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(flex: 3),
                            ConstsWidget.buildTitleText(context,
                                title: 'Pesquisar Protocolos',
                                textAlign: TextAlign.center),
                            Spacer(
                              flex: 2,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.04),
                              child: Container(
                                height: size.height * 0.3,
                                width: size.width * 0.1,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 39, 211, 104),
                                ),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  fill: 1,
                                ),
                              ),
                            ),
                            // Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ConstsWidget.buildPadding001(
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
                                title: 'Localizar e Avisar a Unidade ',
                                textAlign: TextAlign.center),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.04),
                              child: Container(
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
                            ),
                            // Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                buildGridViewer(
                  children: [
                    buildCard(
                      title: 'Notificações',
                      onTap: () {
                        ConstsFuture.navigatorPush(
                            context, HistoricoNotificScreen());
                      },
                      iconApi:
                          '${Consts.iconApiPort}historico-notificacoes.png',
                    ),
                    buildCard(
                        title: 'Procurar Veículos',
                        iconApi: '${Consts.iconApiPort}pesquisa-veiculos.png',
                        onTap: () {
                          showSearch(
                              context: context, delegate: SearchVeiculo());
                        },
                        isSearchVeiculo: true),
                    buildCard(
                      title: 'Avisar em Massa',
                      iconApi: '${Consts.iconApiPort}multi.png',
                      avisa: FuncionarioInfos.avisa_corresp,
                      onTap: () {
                        alertMultiCorresp();
                      },
                    ),
                    buildCard(
                        title: 'Informe o Síndico',
                        onTap: () {
                          alertInformeSindico();
                        },
                        isWhatss: true,
                        iconApi: '${Consts.iconApiPort}informe-sindico.png'),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  launchNumber(number) async {
    await launchUrl(Uri.parse('tel:$number'));
  }
}
