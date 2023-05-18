// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:app_porteiro/widgets/search_bar.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_drawer.dart';
import 'list_tile_ap.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

List<String> aps = ['16', '18', '20', '22', '24', '26', '28', '30', '32'];
List<String> blocos = ['1', '2', '3'];

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('widget.title'),
      ),
      endDrawer: CustomDrawer(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
          child: ListView(
            children: [
              SearchBar(),
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: aps.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: size.height * 0.005),
                    child: ListTileAp(
                      ap: aps.elementAt(index),
                      bloco: '1',
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
