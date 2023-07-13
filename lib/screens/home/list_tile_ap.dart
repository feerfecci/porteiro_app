// ignore_for_file: prefer_const_literals_to_create_immutables, non_constant_identifier_names
import 'package:app_porteiro/consts/consts.dart';
import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/screens/correspondencias/correspondencias_screen.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:app_porteiro/moldals/modal_envia_avisos.dart';
import 'package:flutter/material.dart';

import '../correspondencias/scafffoldItem.dart';

class ListTileAp extends StatefulWidget {
  final String nomeResponsavel;
  // final String nome_moradores;
  final String bloco;
  final int idunidade;

  const ListTileAp(
      {required this.nomeResponsavel,
      // required  this.nome_moradores,
      required this.bloco,
      required this.idunidade,
      super.key});

  @override
  State<ListTileAp> createState() => _ListTileApState();
}

class _ListTileApState extends State<ListTileAp> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget buildActionIcon({
      String? titleModal,
      String? labelModal,
      required String iconApi,
      required bool avisa,
      Widget? pageRoute,
      void Function()? onPressed,
    }) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.0005),
        child: GestureDetector(
          onTap: avisa
              ? onPressed ??
                  () {
                    // Navigator.pop(context);
                    ConstsFuture.navigatorPush(context, pageRoute!);
                    // showCustomModalBottom(context,
                    //     label: labelModal,
                    //     title: titleModal,
                    //     idunidade: widget.idunidade);
                  }
              : () {
                  buildMinhaSnackBar(context,
                      title: 'Desculpe',
                      subTitle: 'Você não tem acesso à essa ação');
                },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder(
                  future: ConstsFuture.apiImage(iconApi),
                  builder: (context, snapshot) => SizedBox(
                      width: size.width * 0.15,
                      height: size.height * 0.07,
                      child: Image.network(
                        iconApi,
                        fit: BoxFit.cover,
                      ))),
              SizedBox(
                height: size.height * 0.01,
              ),
              SizedBox(
                  width: size.width * 0.21,
                  child: ConstsWidget.buildTitleText(
                    context,
                    textAlign: TextAlign.center,
                    title: titleModal,
                  ))
            ],
          ),
        ),
      );
    }

    return MyBoxShadow(
      child: ConstsWidget.buildPadding001(
        context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ConstsWidget.buildTitleText(context, title: '${widget.idunidade}'),
            ConstsWidget.buildTitleText(context,
                title: widget.bloco, fontSize: 22),
            SizedBox(
              height: size.height * 0.005,
            ),
            ConstsWidget.buildSubTitleText(context,
                subTitle: widget.nomeResponsavel, fontSize: 18),
            // Text(widget.nome_moradores),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // mainAxisSize: MainAxisSize.min,
              children: [
                if (FuncionarioInfos.avisa_corresp)
                  buildActionIcon(
                      titleModal: 'Cartas',
                      labelModal: 'Remetente',
                      iconApi: '${Consts.iconApiPort}correspondencias60px.png',
                      avisa: FuncionarioInfos.avisa_corresp,
                      pageRoute: ScaffoldBottom(
                        idunidade: widget.idunidade,
                        localizado: widget.bloco,
                        nome_responsavel: widget.nomeResponsavel,
                        tipoAviso: 3,
                      )),
                if (FuncionarioInfos.avisa_delivery)
                  buildActionIcon(
                      iconApi: '${Consts.iconApiPort}mercadorias60px.png',
                      titleModal: 'Caixas',
                      labelModal: 'Remetente',
                      avisa: FuncionarioInfos.avisa_encomendas,
                      pageRoute: ScaffoldBottom(
                        nome_responsavel: widget.nomeResponsavel,
                        idunidade: widget.idunidade,
                        localizado: widget.bloco,
                        tipoAviso: 4,
                      )),
                if (FuncionarioInfos.avisa_visita)
                  buildActionIcon(
                      avisa: FuncionarioInfos.avisa_visita,
                      iconApi: '${Consts.iconApiPort}visitas60px.png',
                      titleModal: 'Visitas',
                      onPressed: () {
                        showModalAvisaDelivery(context,
                            title: 'Visitas',
                            idunidade: widget.idunidade,
                            localizado: widget.bloco,
                            nome_responsavel: widget.nomeResponsavel,
                            tipoAviso: 2
                            // nome_moradores: widget.nome_moradores,
                            );
                      }),
                if (FuncionarioInfos.avisa_delivery)
                  buildActionIcon(
                      titleModal: 'Delivery',
                      avisa: FuncionarioInfos.avisa_delivery,
                      iconApi: '${Consts.iconApiPort}delivery60px.png',
                      onPressed: () {
                        showModalAvisaDelivery(context,
                            title: 'Delivery',
                            idunidade: widget.idunidade,
                            localizado: widget.bloco,
                            nome_responsavel: widget.nomeResponsavel,
                            tipoAviso: 1
                            // nome_moradores: widget.nome_moradores,
                            );
                      }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
