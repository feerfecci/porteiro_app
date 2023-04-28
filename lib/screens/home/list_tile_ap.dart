// ignore_for_file: prefer_const_literals_to_create_immutables
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
        {required String title,
        required String label,
        required IconData icon}) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
        child: IconButton(
          onPressed: () {
            showCustomModalBottom(context, label: label, title: title);
          },
          icon: Icon(icon),
        ),
      );
    }

    return ListTile(
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildActionIcon(
            title: 'Correspondências',
            label: 'Remetente',
            icon: Icons.email,
          ),
          buildActionIcon(
            icon: Icons.delivery_dining,
            title: 'Delivery',
            label: 'Restaurante',
          ),
        ],
      ),
      title: Text('Apartamento ${widget.ap}'),
      subtitle: Text('Bloco ${widget.bloco}'),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), side: BorderSide()),
    );
  }
}
