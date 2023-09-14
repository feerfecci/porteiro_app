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
      child: SeachBar(
        label: 'Pesquise',
        hintText: 'a0x1',
        delegate:
            SearchProtocolos(/*idunidade: idunidade, tipoAviso: tipoAviso*/),
      ),
    );
  }
}
