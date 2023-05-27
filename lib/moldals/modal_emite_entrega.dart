import 'dart:async';
import 'dart:convert';

import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/items_bottom.dart';
import 'package:app_porteiro/screens/home/home_page.dart';
import 'package:app_porteiro/widgets/scaffold_all.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../consts/consts.dart';

showModalEmiteEntrega(BuildContext context,
    {required int? idunidade, required String? protocoloRetirada}) {
  var size = MediaQuery.of(context).size;
  showModalBottomSheet(
    context: context,
    builder: (context) => SizedBox(
      height: size.height * 0.8,
      child: SafeArea(
        child: Scaffold(
          key: Consts.modelScaffoldKey,
          body: Padding(
            padding: EdgeInsets.all(size.height * 0.01),
            child: WidgetEmiteEntrega(
                idunidade: idunidade, protocoloRetirada: protocoloRetirada),
          ),
        ),
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
  bool isLoading = false;
  loadingConfirmacao() {
    setState(() {
      isLoading = !isLoading;
      codigoConfirmadoApi = false;
    });
    // comparaCodigoEntrega(widget.idunidade, protocoloRetirada: confirmacao);

    Timer(Duration(seconds: 2), () {
      setState(() {
        isLoading = !isLoading;
      });
      comparaCodigoEntrega(context, widget.idunidade,
              protocoloRetirada: widget.protocoloRetirada)
          .then((value) {
        if (!codigoConfirmadoApi) {
          buildMinhaSnackBar(context,
              title: 'Tudo Certo', subTitle: mensagemApi);
          ConstsFuture.navigatorPushRemoveUntil(context, ItemsBottom());
        } else if (codigoConfirmadoApi) {
          buildMinhaSnackBar(context,
              title: 'Algo Errado', subTitle: mensagemApi);
          setState(() {
            codigoConfirmadoApi == true;
          });
        }
      });
    });
  }

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
            mensagem: 'Peça o código de entrega',
            onSaved: (text) {
              confirmacao = text;
            },
          ),
          Text('Peça o código de entrega',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ConstsWidget.buildLoadingButton(context, onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();

              loadingConfirmacao();
            }
          }, isLoading: isLoading, title: 'Confirmar Entrega'),
          Visibility(
              visible: false,
              //  codigoConfirmadoApi ? true0
              // : false,
              child: Text('Código Errado')),
        ],
      ),
    );
  }
}

bool codigoConfirmadoApi = false;
String mensagemApi = '';
Future<bool> comparaCodigoEntrega(BuildContext context, idunidade,
    {required String? protocoloRetirada}) async {
  var url = Uri.parse(
      '${Consts.apiPortaria}correspondencias/?fn=compararProtocolos&idcond=${FuncionarioInfos.idcondominio}&idunidade=$idunidade&protocolo=$protocoloRetirada&protocoloentrega=$confirmacao');
  var resposta = await http.get(url);
  if (resposta.statusCode == 200) {
    var jsons = json.decode(resposta.body);
    // if (!jsons['erro']) {
    //   return jsons['erro'];
    // }
    mensagemApi = jsons['mensagem'];
    return codigoConfirmadoApi = jsons['erro'];
  } else {
    return false;
  }
}
