import 'package:app_porteiro/screens/seach_pages/search_protocolo.dart';
import 'package:app_porteiro/widgets/seach_bar.dart';
import 'package:flutter/material.dart';

class ProcuraProtocolo extends StatelessWidget {
  final int? idunidade;
  final int? tipoAviso;
  const ProcuraProtocolo(
      {required this.idunidade, required this.tipoAviso, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SeachBar(
            title: 'Pesquisar Protocolos',
            color: Color.fromARGB(255, 39, 211, 104),
            delegate: SearchProtocolos(),
          ),
        ],
      ),
    );
  }
}
