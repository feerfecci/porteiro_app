import 'dart:async';
import 'dart:convert';

import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/items_bottom.dart';
import 'package:app_porteiro/moldals/modal_all.dart';
import 'package:app_porteiro/screens/home/home_page.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import '../consts/consts.dart';

showModalEmiteEntrega(
  BuildContext context, {
  required int? idunidade,
  String? protocoloRetirada,
  required int? tipoCompara,
  String? listEntregar,
  int? idMorador,
}) {
  buildModalAll(
    context,
    title: 'Emitir Entrega',
    isDrawer: false,
    child: WidgetEmiteEntrega(
        idMorador: idMorador,
        idunidade: idunidade,
        protocoloRetirada: protocoloRetirada,
        tipoCompara: tipoCompara,
        listEntregar: listEntregar),
  );
}

class WidgetEmiteEntrega extends StatefulWidget {
  final int? idunidade;
  final String? protocoloRetirada;
  final int? tipoCompara;
  final String? listEntregar;
  final int? idMorador;
  const WidgetEmiteEntrega(
      {required this.idunidade,
      required this.protocoloRetirada,
      required this.tipoCompara,
      this.listEntregar,
      this.idMorador,
      super.key});

  @override
  State<WidgetEmiteEntrega> createState() => _WidgetEmiteEntregaState();
}

String? confirmacao;

class _WidgetEmiteEntregaState extends State<WidgetEmiteEntrega> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool codigoConfirmadoApi = false;
  String mensagemApi = '';

  Future<bool> comparaCodigoEntrega(BuildContext context, idunidade,
      {required String? protocoloRetirada,
      required int? tipoCompara,
      String? listEntregar,
      String? senha}) async {
    tipoCompara ?? senha;
    String senhaCripto;
    if (tipoCompara == 2) {
      senhaCripto = md5.convert(utf8.encode(senha!)).toString();
    } else {
      senhaCripto = '';
    }

    var url = Uri.parse(tipoCompara == 1
        //tipoCompara 1 CÓDIGO
        ? '${Consts.apiPortaria}correspondencias/?fn=compararProtocolos&idcond=${FuncionarioInfos.idcondominio}&idunidade=$idunidade&protocolo=$protocoloRetirada&protocoloentrega=$confirmacao'
        //tipoCompara 2 SENHA
        : '${Consts.apiPortaria}correspondencias/?fn=compararSenhaRetirada&idcond=${FuncionarioInfos.idcondominio}&idmorador=${widget.idMorador}&listacorrespondencias=$listEntregar&senha_retirada=$senhaCripto');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      var jsons = json.decode(resposta.body);
      mensagemApi = jsons['mensagem'];
      return codigoConfirmadoApi = jsons['erro'];
    } else {
      return false;
    }
  }

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
              protocoloRetirada: widget.protocoloRetirada,
              tipoCompara: widget.tipoCompara,
              senha: confirmacao,
              listEntregar: widget.listEntregar)
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

  bool isChecked = false;
  // Widget buildFuture() {
  //   return FutureBuilder<dynamic>(
  //     initialData: listarMoradores(),
  //     future: listarMoradores(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return CircularProgressIndicator();
  //       } else if (snapshot.hasData) {
  //         if (!snapshot.data['erro']) {
  //           return ListView.builder(
  //             shrinkWrap: true,
  //             physics: ClampingScrollPhysics(),
  //             itemCount: snapshot.data['morador'].length,
  //             itemBuilder: (context, index) {
  //               return StatefulBuilder(
  //                 builder: (context, setState) {
  //                   return MyBoxShadow(
  //                     child: CheckboxListTile(
  //                       title: ConstsWidget.buildTitleText(context,
  //                           title: snapshot.data['morador'][index]
  //                               ['nome_morador']),
  //                       value: isChecked,
  //                       onChanged: (value) {
  //                         setState(
  //                           () {
  //                             isChecked = value!;
  //                             idMorador =
  //                                 snapshot.data['morador'][index]['idmorador'];
  //                           },
  //                         );
  //                       },
  //                     ),
  //                   );
  //                 },
  //               );
  //             },
  //           );
  //         } else {
  //           return Text('Algo saiu mal');
  //         }
  //       } else {
  //         return Text('Algo saiu mal');
  //       }
  //     },
  //   );
  // }

  @override
  void initState() {
    isChecked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // ConstsWidget.buildClosePop(context, title: 'Confirmar entrega'),
          // if (widget.tipoCompara == 2)
          // buildFuture(),
          ConstsWidget.buildMyTextFormObrigatorio(
            context,
            'Código de confirmação',
            mensagem: 'Peça o código de entrega',
            obscureText: true,
            onSaved: (text) {
              confirmacao = text;
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
            child: ConstsWidget.buildTitleText(
              context,
              title: 'Peça o código de entrega',
              color: Colors.red,
            ),
          ),
          ConstsWidget.buildLoadingButton(context, onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();

              loadingConfirmacao();
            }
          }, isLoading: isLoading, title: 'Confirmar Entrega'),
        ],
      ),
    );
  }
}
