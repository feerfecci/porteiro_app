// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class FuncionarioInfos {
  static int? idFuncionario;
  static bool? ativo;
  static int? idcondominio;
  static int? idfuncao;
  static String? nome_funcao;
  static String? nome_condominio;
  static String? nome_funcionario;
  static String? login;
  static bool avisa_corresp = false;
  
  static bool avisa_visita = false;
  static bool avisa_delivery = false;
  static bool avisa_encomendas = false;
}

class Consts {
  static double fontTitulo = 18;
  static double fontSubTitulo = 16;
  static double borderButton = 60;

  static const kBackPageColor = Color.fromARGB(255, 245, 245, 255);
  // static const kButtonColor = Color.fromARGB(255, 0, 134, 252);
  static const kButtonColor = kColorApp;

  static const kColorApp = Color.fromARGB(255, 127, 99, 254);

  static const String iconApi = 'https://escritorioapp.com/img/ico-';

  static const String apiPortaria = 'https://a.portariaapp.com/portaria/api/';

  static final GlobalKey<ScaffoldState> modelScaffoldKey =
      GlobalKey<ScaffoldState>();
}
