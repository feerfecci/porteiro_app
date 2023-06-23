// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:app_porteiro/consts/consts.dart';
import 'package:app_porteiro/screens/login/login_screen.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';

import '../items_bottom.dart';
import '../screens/home/home_page.dart';

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
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => ItemsBottom(),
            ),
            (route) => true);
      } else {
        ConstsFuture.navigatorPushRemoveUntil(context, LoginScreen());
        return buildMinhaSnackBar(context);
      }
    }
  }

  static Future<Widget> apiImage(String iconApi) async {
    var url = Uri.parse(iconApi);
    var resposta = await http.get(url);

    return resposta.statusCode == 200
        ? Image.network(
            iconApi,
          )
        : Image.asset('assets/erro_png.png');
  }
}
