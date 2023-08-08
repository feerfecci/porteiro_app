import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:flutter/material.dart';

class PageErro extends StatefulWidget {
  const PageErro({super.key});

  @override
  State<PageErro> createState() => _PageVaziaErro();
}

class _PageVaziaErro extends State<PageErro> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/erro.png'),
        SizedBox(
          height: size.height * 0.01,
        ),
      ],
    );
  }
}
