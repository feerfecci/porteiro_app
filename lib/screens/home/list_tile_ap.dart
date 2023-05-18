// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:ui';

import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:app_porteiro/screens/moldals/custom_modal.dart';

class ListTileAp extends StatefulWidget {
  final String ap;
  final String bloco;
  const ListTileAp({required this.ap, required this.bloco, super.key});

  @override
  State<ListTileAp> createState() => _ListTileApState();
}

class _ListTileApState extends State<ListTileAp> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget buildActionIcon(
        {required String titleModal,
        required String labelModal,
        required IconData icon}) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.005),
        child: MyBoxShadow(
          paddingAll: 0.002,
          child: IconButton(
            onPressed: () {
              showCustomModalBottom(context,
                  label: labelModal, title: titleModal);
            },
            icon: Icon(
              icon,
            ),
          ),
        ),
      );
    }

    return MyBoxShadow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstsWidget.buildTitleText(widget.ap),
          ConstsWidget.buildSubTitleText(widget.bloco),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // mainAxisSize: MainAxisSize.min,
            children: [
              buildActionIcon(
                titleModal: 'Correspondências',
                labelModal: 'Remetente',
                icon: Icons.email,
              ),
              buildActionIcon(
                icon: Icons.shopping_bag_rounded,
                titleModal: 'Encomenda',
                labelModal: 'Remetente',
              ),
              buildActionIcon(
                icon: Icons.delivery_dining,
                titleModal: 'Delivery',
                labelModal: 'Restaurante',
              ),
              buildActionIcon(
                icon: Icons.person_pin_sharp,
                titleModal: 'Visitas',
                labelModal: 'Nome',
              ),
            ],
          ),
        ],
      ),
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(16), side: BorderSide()),
    );
  }
}
