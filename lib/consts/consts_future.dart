// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:app_porteiro/consts/consts.dart';
import 'package:app_porteiro/items_bottom.dart';
import 'package:app_porteiro/screens/login/login_screen.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';

class ConstsFuture {
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
    return Navigator.push(
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
}
