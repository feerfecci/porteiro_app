// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';
import 'package:app_porteiro/consts/consts.dart';
import 'package:app_porteiro/screens/login/login_screen.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';
import '../screens/home/home_page.dart';
import '../widgets/my_box_shadow.dart';
import '../widgets/page_erro.dart';
import '../widgets/page_vazia.dart';
import 'consts_widget.dart';

class ConstsFuture {
  static Future<dynamic> launchGetApi(BuildContext context, apiPortaria) async {
    var url = Uri.parse('${Consts.apiPortaria}$apiPortaria');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      try {
        return json.decode(resposta.body);
      } on Exception {
        return {'erro': true, 'mensagem': 'Tente Novamente'};
      }
    } else {
      return {'erro': true, 'mensagem': 'Algo saiu mal'};
    }
  }

  static navigatorPopPush(BuildContext context, String namedroute) {
    Navigator.pop(context);
    Navigator.popAndPushNamed(context, namedroute);
  }

  static navigatorPushRemoveUntil(
      BuildContext context, Widget pageRoute) async {
    return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => pageRoute,
        ),
        (route) => false);
  }

  static navigatorPush(BuildContext context, Widget pageRoute) {
    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => pageRoute,
        ));
  }

  static navigatorPopAndPush(BuildContext context, Widget pageRoute) {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => pageRoute,
        ));
  }

  static fazerLogin(BuildContext context, String usuario, String senha) async {
    var senhaCripto = md5.convert(utf8.encode(senha)).toString();
    var url = Uri.parse(
        'https://a.portariaapp.com/api/login-funcionario/?fn=login-funcionario&usuario=$usuario&senha=$senhaCripto');
    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      var apiBody = json.decode(resposta.body);
      bool erro = apiBody['erro'];
      if (erro == false) {
        var loginInfos = apiBody['login'];
        if (loginInfos['ativo']) {
          FuncionarioInfos.idFuncionario = loginInfos['id'];
          FuncionarioInfos.ativo = loginInfos['ativo'];
          FuncionarioInfos.idcondominio = loginInfos['idcondominio'];
          FuncionarioInfos.nome_condominio = loginInfos['nome_condominio'];
          FuncionarioInfos.nome_funcionario = loginInfos['nome_funcionario'];
          FuncionarioInfos.idfuncao = loginInfos['idfuncao'];
          FuncionarioInfos.nome_funcao = loginInfos['nome_funcao'];
          FuncionarioInfos.login = loginInfos['login'];
          FuncionarioInfos.avisa_corresp = loginInfos['avisa_corresp'];
          FuncionarioInfos.avisa_visita = loginInfos['avisa_visita'];
          FuncionarioInfos.avisa_delivery = loginInfos['avisa_delivery'];
          FuncionarioInfos.avisa_encomendas = loginInfos['avisa_encomendas'];
          // Navigator.pop(context);

          ConstsFuture.navigatorPushRemoveUntil(context, HomePage());
        } else {
          ConstsFuture.navigatorPushRemoveUntil(context, LoginScreen());
          return buildMinhaSnackBar(
            context,
          );
        }
      } else {
        ConstsFuture.navigatorPushRemoveUntil(context, LoginScreen());
        return buildMinhaSnackBar(context);
      }
    }
  }

  static Future<Widget> apiImage(String iconApi) async {
    // var url = Uri.parse(iconApi);
    // var resposta = await http.get(url);
    Widget? image;
    try {
      image = Image.network(
        iconApi,
      );
    } on HttpException catch (e) {
      print(e);
      image = Image.asset('assets/ico-error.png');
    }
    return image;

    // return resposta.statusCode == 200
    //     ? Image.network(
    //         iconApi,
    //       )
    //     : Image.asset('assets/ico-error.png');
  }

  // static AsyncSnapshot<dynamic> snapShotFora = snapShotFora;
  // static FutureBuilder buildFutureBuilder(
  //   BuildContext context, {
  //   required String api,
  //   required Widget widgetWaiting,
  // }) {
  //   return FutureBuilder<dynamic>(
  //       future: ConstsFuture.launchGetApi(context, api),
  //       builder: (context, snapshot) {
  //         snapShotFora = snapshot;
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return widgetWaiting;
  //         } else if (snapshot.hasData) {
  //           if (!snapshot.data['erro']) {
  //             return ListView.builder(
  //               shrinkWrap: true,
  //               physics: ClampingScrollPhysics(),
  //               itemCount: snapshot.data['reserva_espacos'].length,
  //               itemBuilder: (context, index) {
  //                 var apiReservas = snapshot.data['reserva_espacos'][index];
  //                 int idreserva = apiReservas['idreserva'];
  //                 int status = apiReservas['status'];
  //                 String texto_status = apiReservas['texto_status'];
  //                 int idespaco = apiReservas['idespaco'];
  //                 String nome_espaco = apiReservas['nome_espaco'];
  //                 int idcondominio = apiReservas['idcondominio'];
  //                 String nome_condominio = apiReservas['nome_condominio'];
  //                 int idmorador = apiReservas['idmorador'];
  //                 String nome_morador = apiReservas['nome_morador'];
  //                 int idunidade = apiReservas['idunidade'];
  //                 String unidade = apiReservas['unidade'];
  //                 String data_reserva = apiReservas['data_reserva'];
  //                 String datahora = apiReservas['datahora'];

  //                 return MyBoxShadow(
  //                     child: Column(
  //                   children: [
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                       children: [
  //                         ConstsWidget.buildSubTitleText(context,
  //                             subTitle: 'Reservado por: '),
  //                         ConstsWidget.buildTitleText(context,
  //                             title: nome_morador),
  //                       ],
  //                     ),
  //                     ConstsWidget.buildPadding001(
  //                       context,
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                         children: [
  //                           ConstsWidget.buildSubTitleText(context,
  //                               subTitle: 'Local Reservado: '),
  //                           ConstsWidget.buildTitleText(context,
  //                               title: nome_espaco),
  //                         ],
  //                       ),
  //                     ),
  //                     ConstsWidget.buildPadding001(
  //                       context,
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                         children: [
  //                           ConstsWidget.buildSubTitleText(context,
  //                               subTitle: 'Inicio da reserva:'),
  //                           ConstsWidget.buildTitleText(context,
  //                               title: data_reserva),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ));
  //               },
  //             );
  //           } else {
  //             return PageVazia(title: snapshot.data['mensagem']);
  //           }
  //         } else {
  //           return PageErro();
  //         }
  //       });
  // }
}
