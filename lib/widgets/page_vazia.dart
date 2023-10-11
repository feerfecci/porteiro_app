import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:flutter/material.dart';

class PageVazia extends StatefulWidget {
  final String title;
  const PageVazia({required this.title, super.key});

  @override
  State<PageVazia> createState() => _PageVaziaState();
}

class _PageVaziaState extends State<PageVazia> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: size.width * 0.06),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          ConstsWidget.buildCachedImage(context,
              iconApi: 'https://a.portariaapp.com/img/ico-nao-encontrado.png'),
          Padding(
            padding: EdgeInsets.only(
              top: size.height * 0.02,
            ),
            child: Center(
              child: SizedBox(
                width: size.width * 0.9,
                child: ConstsWidget.buildTitleText(context,
                    maxLines: 6,
                    title: widget.title,
                    textAlign: TextAlign.center,
                    fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }
}
