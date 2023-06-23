import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/screens/correspondencias/correspondencias_screen.dart';
import 'package:app_porteiro/screens/correspondencias/procura_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../widgets/custom_drawer/custom_drawer.dart';

class ScaffoldBottom extends StatefulWidget {
  final int? idunidade;
  final String? localizado;

  final String? nome_responsavel;
  final int? tipoAviso;
  const ScaffoldBottom(
      {required this.localizado,
      required this.nome_responsavel,
      required this.idunidade,
      required this.tipoAviso,
      super.key});

  @override
  State<ScaffoldBottom> createState() => _ScaffoldBottomState();
}

class _ScaffoldBottomState extends State<ScaffoldBottom> {
  late final PageController _pageController = PageController();
  int currentTab = 0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        backgroundColor: Colors.transparent,
        title: ConstsWidget.buildTitleText(context,
            title: widget.tipoAviso == 3 ? 'Correspondências' : ' Encomendas',
            fontSize: 24),
        elevation: 0,
        leadingWidth: 40,
        // leading: Padding(
        //   padding: EdgeInsets.only(left: 8),
        //   child: Image.network(
        //     'https://a.portariaapp.com/img/logo_vermelho.png',
        //   ),
        // ),
      ),
      endDrawer: CustomDrawer(),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentTab,
          iconSize: size.height * 0.04,
          selectedFontSize: 18,
          unselectedFontSize: 16,
          onTap: (value) {
            setState(() {
              _pageController.jumpToPage(value);
            });
          },
          items: [
            BottomNavigationBarItem(
              label: widget.tipoAviso == 3 ? 'Correspondências' : ' Encomendas',
              icon: Icon(
                currentTab == 0
                    ? widget.tipoAviso == 3
                        ? Icons.mail
                        : Icons.shopping_bag
                    : widget.tipoAviso == 3
                        ? Icons.mail_outline
                        : Icons.shopping_bag_outlined,
              ),
            ),
            BottomNavigationBarItem(
              // icon: badge.Badge(
              //   showBadge: logado.bolinha == 0 ? false : true,
              // toAnimate: false,
              icon: Icon(
                currentTab == 1 ? Icons.search : Icons.search_rounded,
                // ),
              ),
              label: 'Buscar Protocolos',
            ),
          ]),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.height * 0.01),
        child: PageView(
          physics: ClampingScrollPhysics(),
          controller: _pageController,
          onPageChanged: (value) {
            setState(() {
              currentTab = value;
            });
          },
          children: [
            CorrespondenciasScreen(
                idunidade: widget.idunidade,
                localizado: widget.localizado,
                nome_responsavel: widget.nome_responsavel,
                tipoAviso: widget.tipoAviso),
            ProcuraProtocolo(
                idunidade: widget.idunidade, tipoAviso: widget.tipoAviso),
          ],
        ),
      ),
    );
  }
}
