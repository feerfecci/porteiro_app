// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:app_porteiro/widgets/search_bar.dart';
import 'package:flutter/material.dart';

import 'list_tile_ap.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      endDrawer: Drawer(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
          child: ListView(
            children: [
              SearchBar(),
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: 36,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: size.height * 0.005),
                    child: ListTileAp(
                      ap: '36',
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
