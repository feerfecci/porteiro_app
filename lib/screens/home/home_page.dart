// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/screens/avisos/historico_notific.dart';
import 'package:app_porteiro/screens/quadro_avisos/quadro_avisos.dart';
import 'package:app_porteiro/screens/reservas_espacos/espacos_screen.dart';
import 'package:app_porteiro/screens/seach_pages/search_protocolo.dart';
import 'package:app_porteiro/screens/seach_pages/search_visitante.dart';
import 'package:app_porteiro/screens/seach_pages/search_veiculo.dart';
import 'package:app_porteiro/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../consts/consts.dart';
import '../../consts/consts_future.dart';
import '../../widgets/seach_bar.dart';
import '../seach_pages/search_unidades.dart';
import '../../widgets/custom_drawer/custom_drawer.dart';
import 'alerts_home.dart';
import 'build_gradeview.dart';
import 'card_home.dart';

class HomePage extends StatefulWidget {
  static int qntEventos = 0;
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime timeBackPressed = DateTime.now();
  Future oneSignalNotification() async {
    OneSignal.shared.setAppId('d75e42a6-49bd-4c8d-b13f-51e054634942');
    OneSignal.shared.deleteTags([
      'idcond',
      'idfuncionario',
      'idfuncao',
    ]);
    OneSignal.shared.promptUserForPushNotificationPermission().then((value) {
      // OneSignal.shared.setExternalUserId('34');
      OneSignal.shared.deleteTags([
        'idcond${FuncionarioInfos.idcondominio.toString()}',
        'idfuncionario${FuncionarioInfos.idFuncionario.toString()}',
        'idfuncao${FuncionarioInfos.idfuncao.toString()}'
      ]);
      OneSignal.shared.sendTags({
        'idcond${FuncionarioInfos.idcondominio.toString()}':
            FuncionarioInfos.idcondominio.toString(),
        'idfuncionario${FuncionarioInfos.idFuncionario.toString()}':
            FuncionarioInfos.idFuncionario.toString(),
        'idfuncao${FuncionarioInfos.idfuncao.toString()}':
            FuncionarioInfos.idfuncao.toString(),
      });
      OneSignal.shared.setOnDidDisplayInAppMessageHandler((message) {
        message.messageId;
      });

      OneSignal.shared.setNotificationOpenedHandler((openedResult) {
        if (openedResult.notification.additionalData!['rota'] == 'aviso') {
          ConstsFuture.navigatorPush(context, QuadroHistoricoNotificScreen());
        } else if (openedResult.notification.additionalData!['rota'] ==
                'visita' ||
            openedResult.notification.additionalData!['rota'] == 'delivery') {
          ConstsFuture.navigatorPush(context, HistoricoNotificScreen());
        } else if (openedResult.notification.additionalData!['rota'] ==
            'respostas') {
          ConstsFuture.navigatorPush(context, HistoricoNotificScreen());
        }
      });
    });
  }

  @override
  void initState() {
    oneSignalNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    int lenghtNumeroSindico = 0;

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
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  title: FuncionarioInfos.nome_condominio!,
                  fontSize: SplashScreen.isSmall ? 18 : 20),
              iconTheme: IconThemeData(
                  color: Theme.of(context).textTheme.bodyLarge!.color),
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
                buildGridViewer(context, children: [
                  buildCard(context, title: 'Bombeiros', onTap: () {
                    launchNumber('193');
                  }, iconApi: 'bombeiro.png', isWhatss: true),
                  buildCard(context, title: 'Samu', iconApi: 'ambulancia.png',
                      onTap: () {
                    launchNumber('192');
                  }, isWhatss: true),
                  buildCard(context, title: 'Polícia', iconApi: 'policia.png',
                      onTap: () {
                    launchNumber('190');
                  }, isWhatss: true),

                  buildCard(
                    context,
                    title: 'Quadro de Avisos',
                    iconApi: 'quadrodeavisos.png',
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
                    context,
                    title: 'Espaços Reservados',
                    idEspacos: true,
                    iconApi: 'reservas-solicitadas.png',
                    onTap: () {
                      ConstsFuture.navigatorPush(context, EspacosScreen());
                    },
                  ),
                  buildCard(
                    context,
                    title: 'Visitas Cadastradas',
                    iconApi: 'visitas.png',
                    onTap: () {
                      showSearch(context: context, delegate: SearchVisitante());
                      // ConstsFuture.navigatorPush(context, VisitasScreen());
                    },
                  ),
                ]),
                SeachBar(
                  title: 'Pesquisar Protocolos',
                  color: Color.fromARGB(255, 39, 211, 104),
                  delegate: SearchProtocolos(),
                ),
                SeachBar(
                  title: 'Cartas, Caixas, Visitas e Delivery',
                  color: Consts.kColorRed,
                  delegate: SearchUnidades(),
                ),
                buildGridViewer(
                  context,
                  children: [
                    buildCard(
                      context,
                      title: 'Histórico',
                      onTap: () {
                        ConstsFuture.navigatorPush(
                            context, HistoricoNotificScreen());
                      },
                      iconApi: 'historico-notificacoes.png',
                    ),
                    buildCard(context,
                        title: 'Procurar Veículos',
                        iconApi: 'pesquisa-veiculos.png', onTap: () {
                      showSearch(context: context, delegate: SearchVeiculo());
                    }, isSearchVeiculo: true),
                    buildCard(
                      context,
                      title: 'Avisar em Massa',
                      iconApi: 'multi.png',
                      avisa: FuncionarioInfos.avisa_corresp,
                      onTap: () {
                        alertMultiCorresp(context);
                      },
                    ),
                    buildCard(context, title: 'Informe o Síndico', onTap: () {
                      alertInformeSindico(context);
                    }, isWhatss: true, iconApi: 'informe-sindico.png'),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  static launchNumber(number) async {
    await launchUrl(Uri.parse('tel:$number'));
  }
}
