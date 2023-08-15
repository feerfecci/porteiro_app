import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

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
            print(widget.listErro[index]);
            return MyBoxShadow(
                child: ConstsWidget.buildTitleText(context,
                    title: widget.listErro[index]));
          },
        ));
  }
}
