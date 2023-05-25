import 'package:app_porteiro/consts/consts.dart';
import 'package:app_porteiro/screens/home/home_page.dart';
import 'package:app_porteiro/widgets/custom_drawer/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'screens/home/search_page.dart';

class ItemsBottom extends StatefulWidget {
  const ItemsBottom({super.key});

  @override
  State<ItemsBottom> createState() => _ItemsBottomState();
}

class _ItemsBottomState extends State<ItemsBottom> {
  late final PageController _pageController = PageController();
  int currentTab = 0;

  String oneSignalAppId = "56d855ee-f534-4c40-97b5-272bebcee2f1";
  Future oneSignalNotification() async {
    OneSignal.shared.setAppId(oneSignalAppId);
    OneSignal.shared.promptUserForPushNotificationPermission().then((value) {
      OneSignal.shared.setExternalUserId('26');
    });
  }

  @override
  void initState() {
    super.initState();
    // oneSignalNotification();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 40,
        leading: Padding(
          padding: EdgeInsets.only(left: 8),
          child: Image.network(
            'https://www.portariaapp.com/wp-content/uploads/2023/03/portria.png',
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: SizedBox(
        height: size.height * 0.1,
        width: size.width * 0.15,
        child: FloatingActionButton(
          isExtended: true,
          onPressed: () {
            showSearch(context: context, delegate: SearchPage());
          },
          backgroundColor: Consts.kColorApp,
          foregroundColor: Colors.white,
          child: Icon(Icons.search),
        ),
      ),
      endDrawer: CustomDrawer(),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentTab,
          iconSize: size.height * 0.035,
          onTap: (value) {
            setState(() {
              _pageController.jumpToPage(value);
            });
          },
          items: [
            BottomNavigationBarItem(
              label: 'Início',
              icon: Icon(
                currentTab == 0 ? Icons.home_sharp : Icons.home_outlined,
              ),
            ),
            BottomNavigationBarItem(
              // icon: badge.Badge(
              //   showBadge: logado.bolinha == 0 ? false : true,
              // toAnimate: false,
              icon: Icon(
                currentTab == 1
                    ? Icons.shopping_cart_rounded
                    : Icons.shopping_cart_outlined,
                // ),
              ),
              label: 'Divisões',
            ),
            BottomNavigationBarItem(
              label: 'Moradores',
              icon: Icon(
                currentTab == 2
                    ? Icons.question_mark_sharp
                    : Icons.question_mark_outlined,
              ),
            ),
          ]),
      body: PageView(
        physics: ClampingScrollPhysics(),
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            currentTab = value;
          });
        },
        children: [
          HomePage(),
          Container(
            color: Colors.blue,
          ),
          Container(
            color: Colors.green,
          )
        ],
      ),
    );
  }
}
