import 'dart:convert';

import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/items_bottom.dart';
import 'package:app_porteiro/screens/home/home_page.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../consts/consts.dart';

showModalEmiteEntrega(BuildContext context,
    {required int? idunidade, required String? protocoloRetirada}) {
  var size = MediaQuery.of(context).size;
  showModalBottomSheet(
    context: context,
    builder: (context) => SizedBox(
      height: size.height * 0.7,
      child: Padding(
        padding: EdgeInsets.all(size.height * 0.01),
        child: WidgetEmiteEntrega(
            idunidade: idunidade, protocoloRetirada: protocoloRetirada),
      ),
    ),
    enableDrag: false,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
  );
}

class WidgetEmiteEntrega extends StatefulWidget {
  final int? idunidade;
  final String? protocoloRetirada;
  const WidgetEmiteEntrega(
      {required this.idunidade, required this.protocoloRetirada, super.key});

  @override
  State<WidgetEmiteEntrega> createState() => _WidgetEmiteEntregaState();
}

String? confirmacao;

class _WidgetEmiteEntregaState extends State<WidgetEmiteEntrega> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ConstsWidget.buildClosePop(context),
          ConstsWidget.buildTitleText(context, title: 'Confirmar entrega'),
          ConstsWidget.buildMyTextFormObrigatorio(
            context,
            'Código de confirmação',
            onSaved: (text) {
              confirmacao = text;
            },
          ),
          ConstsWidget.buildCustomButton(context, 'Confirmar Entrega',
              onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              FutureBuilder<dynamic>(
                future: comparaCodigoEntrega(widget.idunidade,
                    protocoloRetirada: widget.protocoloRetirada),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erro no Servidor');
                  } else if (snapshot.data['erro']) {
                    buildMinhaSnackBar(context,
                        title: 'Tente Novamente',
                        subTitle: snapshot.data['mensagem']);
                  }
                  return buildMinhaSnackBar(context,
                      title: 'Tudo Certo', subTitle: snapshot.data['mensagem']);
                },
              );
              ConstsFuture.navigatorPushRemoveUntil(context, ItemsBottom());
            }
          })
        ],
      ),
    );
  }
}

Future<dynamic> comparaCodigoEntrega(idunidade,
    {required String? protocoloRetirada}) async {
  var url = Uri.parse(
      '${Consts.apiPortaria}correspondencias/?fn=compararProtocolos&idcond=${FuncionarioInfos.idcondominio}&idunidade=$idunidade&protocolo=$protocoloRetirada&protocoloentrega=$confirmacao');
  var resposta = await http.get(url);
  if (resposta.statusCode == 200) {
    return json.decode(resposta.body);
  } else {
    return ['Não foi!'];
  }
}
