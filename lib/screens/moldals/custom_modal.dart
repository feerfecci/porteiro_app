import 'dart:convert';

import 'package:app_porteiro/widgets/my_textform_field.dart';
import 'package:flutter/material.dart';
import '../../consts/consts.dart';
import '../../consts/consts_future.dart';
import '../../consts/consts_widget.dart';
import 'package:http/http.dart' as http;

showCustomModalBottom(BuildContext context,
    {required String title, required String label, required int idunidade}) {
  var size = MediaQuery.of(context).size;
  showModalBottomSheet(
    enableDrag: false,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (context) => SizedBox(
        height: size.height * 0.7,
        child: Padding(
          padding: EdgeInsets.all(size.height * 0.01),
          child: WidgetCustomModal(
              title: title, label: label, idunidade: idunidade),
        )),
  );
}

class WidgetCustomModal extends StatefulWidget {
  final String title;
  final String label;
  final int idunidade;
  const WidgetCustomModal(
      {required this.title,
      required this.label,
      required this.idunidade,
      super.key});

  @override
  State<WidgetCustomModal> createState() => _WidgetCustomModalState();
}

class _WidgetCustomModalState extends State<WidgetCustomModal> {
  lauchNotification(int idunidade) async {
    // var url = Uri.parse(
    //     'https://a.portariaapp.com/sindico/api/notificacao/?fn=enviarNotificacoes&idcond=${FuncionarioInfos.idcondominio}&idunidade=$idunidade');
    // var resposta = await http.get(url);
    print(idunidade);

    // if (resposta.statusCode == 200) {
    //   return json.encode(resposta.body);
    // } else {
    //   return false;
    // }
  }

  int qnt = 0;
  increment() {
    setState(() {
      qnt++;
    });
  }

  decrement() {
    setState(() {
      qnt--;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
          child: buildMyTextFormField(context, title: widget.title),
        ),
        buildMyTextFormField(context, title: widget.label),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: qnt == 0
                    ? () {}
                    : () {
                        decrement();
                      },
                icon: Icon(
                  Icons.remove_circle,
                  color: qnt == 0 ? Colors.grey : Colors.black,
                  size: size.height * 0.035,
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              child: Text(
                '$qnt',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
                onPressed: () {
                  increment();
                },
                icon: Icon(
                  Icons.add_circle,
                  size: size.height * 0.035,
                )),
          ],
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            lauchNotification(widget.idunidade);
          },
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Salvar e avisar',
            ),
          ),
        ),
      ],
    );
  }
}
