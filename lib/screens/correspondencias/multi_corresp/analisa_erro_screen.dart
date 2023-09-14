import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AnalisaErroScreen extends StatefulWidget {
  Map listErro;
  AnalisaErroScreen({required this.listErro, super.key});

  @override
  State<AnalisaErroScreen> createState() => _AnalisaErroScreenState();
}

class _AnalisaErroScreenState extends State<AnalisaErroScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldAll(
        title: 'Analise De Erro',
        body: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.listErro.length,
          itemBuilder: (context, index) {
            return MyBoxShadow(
                child: ConstsWidget.buildTitleText(context,
                    title: widget.listErro[index]));
          },
        ));
  }
}
