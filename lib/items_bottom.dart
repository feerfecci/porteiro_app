import 'package:app_porteiro/screens/home/home_page.dart';
import 'package:app_porteiro/widgets/custom_drawer/custom_drawer.dart';
import 'package:flutter/material.dart';

class ItemsBottom extends StatefulWidget {
  const ItemsBottom({super.key});

  @override
  State<ItemsBottom> createState() => _ItemsBottomState();
}

class _ItemsBottomState extends State<ItemsBottom> {
  late PageController _pageController = PageController();
  int currentTab = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 40,
        leading: Padding(
          padding: EdgeInsets.only(left: 8),
          child: Image.network(
            'https://www.portariaapp.com/wp-content/uploads/2023/03/portria.png',
          ),
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
