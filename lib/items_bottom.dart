// import 'package:app_porteiro/consts/consts.dart';
// import 'package:app_porteiro/consts/consts_widget.dart';
// import 'package:app_porteiro/screens/home/home_page.dart';
// import 'package:app_porteiro/seach_pages/search_veiculo.dart';
// import 'package:app_porteiro/widgets/custom_drawer/custom_drawer.dart';
// import 'package:app_porteiro/widgets/floatingActionButton.dart';
// import 'package:app_porteiro/widgets/my_box_shadow.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

// import 'seach_pages/search_unidades.dart';

// class ItemsBottom extends StatefulWidget {
//   const ItemsBottom({super.key});

//   @override
//   State<ItemsBottom> createState() => _ItemsBottomState();
// }

// class _ItemsBottomState extends State<ItemsBottom> {
//   late final PageController _pageController = PageController();
//   int currentTab = 0;

//   Future oneSignalNotification() async {
//     OneSignal.shared.setAppId("5993cb79-853a-412e-94a1-f995c9797692");
//     OneSignal.shared.promptUserForPushNotificationPermission().then((value) {
//       // OneSignal.shared.setExternalUserId('34');
//     });
//     OneSignal.shared.sendTags({
//       'idfuncionario': FuncionarioInfos.idFuncionario.toString(),
//       'idcond': FuncionarioInfos.idcondominio.toString(),
//       'idfuncao': FuncionarioInfos.idfuncao.toString(),
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     oneSignalNotification();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       extendBody: true,
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leadingWidth: 40,
//         leading: Padding(
//           padding: EdgeInsets.only(left: 8),
//           child: Image.network(
//             'https://www.portariaapp.com/wp-content/uploads/2023/03/portria.png',
//           ),
//         ),
//       ),
//       // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//       floatingActionButton: SpeedDial(
//         animatedIcon: AnimatedIcons.menu_close,
//         icon: Icons.search,
//         overlayColor: Theme.of(context).colorScheme.primary,
//         iconTheme: IconThemeData(color: Colors.white),
//         backgroundColor: Consts.kColorApp,
//         children: [
//           SpeedDialChild(
//             label: 'Apartamentos',
//             child: Icon(Icons.business_outlined),
//             onTap: () =>
//                 showSearch(context: context, delegate: SearchUnidades()),
//           ),
//           SpeedDialChild(
//             label: 'Carros',
//             child: Icon(Icons.car_crash_sharp),
//             onTap: () =>
//                 showSearch(context: context, delegate: SearchVeiculo()),
//           ),
//         ],
//       ),
//       endDrawer: CustomDrawer(),
//       bottomNavigationBar: BottomNavigationBar(
//           currentIndex: currentTab,
//           iconSize: size.height * 0.035,
//           onTap: (value) {
//             setState(() {
//               _pageController.jumpToPage(value);
//             });
//           },
//           items: [
//             BottomNavigationBarItem(
//               label: 'Início',
//               icon: Icon(
//                 currentTab == 0 ? Icons.home_sharp : Icons.home_outlined,
//               ),
//             ),
//             BottomNavigationBarItem(
//               // icon: badge.Badge(
//               //   showBadge: logado.bolinha == 0 ? false : true,
//               // toAnimate: false,
//               icon: Icon(
//                 currentTab == 1
//                     ? Icons.shopping_cart_rounded
//                     : Icons.shopping_cart_outlined,
//                 // ),
//               ),
//               label: 'Divisões',
//             ),
//             BottomNavigationBarItem(
//               label: 'Moradores',
//               icon: Icon(
//                 currentTab == 2
//                     ? Icons.question_mark_sharp
//                     : Icons.question_mark_outlined,
//               ),
//             ),
//           ]),
//       body: PageView(
//         physics: ClampingScrollPhysics(),
//         controller: _pageController,
//         onPageChanged: (value) {
//           setState(() {
//             currentTab = value;
//           });
//         },
//         children: [
//           HomePage(),
//           Container(
//             color: Colors.blue,
//           ),
//           Container(
//             color: Colors.green,
//           )
//         ],
//       ),
//     );
//   }
// }
