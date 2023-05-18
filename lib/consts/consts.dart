// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class FuncionarioInfos {
  static int? id;
  static bool? ativo;
  static int? idcondominio;
  static String? nome_condominio;
  static String? nome_funcionario;
  static String? login;
  static bool? avisa_corresp;
  static bool? avisa_visita;
  static bool? avisa_delivery;
  static bool? avisa_encomendas;
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
}
