// ignore_for_file: prefer_const_literals_to_create_immutables, non_constant_identifier_names
import 'package:app_porteiro/consts/consts.dart';
import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/screens/correspondencias/correspondencias_screen.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:flutter/material.dart';

class ListTileAp extends StatefulWidget {
  final String nomeResponsavel;
  final String nome_moradores;
  final String bloco;
  final int idunidade;
  const ListTileAp(
      {required this.nomeResponsavel,
      this.nome_moradores = '',
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
      required String titleModal,
      required String labelModal,
      required IconData icon,
      required bool avisa,
      required Widget pageRoute,
    }) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.005),
        child: MyBoxShadow(
          color: avisa ? null : Colors.grey,
          paddingAll: 0.002,
          child: IconButton(
            onPressed: avisa
                ? () {
                    // Navigator.pop(context);
                    ConstsFuture.navigatorPush(context, pageRoute);
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
            icon: Icon(
              icon,
            ),
          ),
        ),
      );
    }

    return MyBoxShadow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ConstsWidget.buildTitleText(context, title: '${widget.idunidade}'),
          ConstsWidget.buildSubTitleText(context, subTitle: widget.bloco),
          ConstsWidget.buildTitleText(context, title: widget.nomeResponsavel),
          Text(widget.nome_moradores),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // mainAxisSize: MainAxisSize.min,
            children: [
              buildActionIcon(
                  titleModal: 'Correspondências',
                  labelModal: 'Remetente',
                  icon: Icons.email,
                  avisa: FuncionarioInfos.avisa_corresp,
                  pageRoute: CorrespondenciasScreen(
                    idunidade: widget.idunidade,
                    localizado: widget.bloco,
                    nome_responsavel: widget.nomeResponsavel,
                    tipoAviso: 1,
                  )),
              buildActionIcon(
                  icon: Icons.person_pin_sharp,
                  titleModal: 'Visitas',
                  labelModal: 'Nome',
                  avisa: FuncionarioInfos.avisa_visita,
                  pageRoute: CorrespondenciasScreen(
                    nome_responsavel: widget.nomeResponsavel,
                    idunidade: widget.idunidade,
                    localizado: widget.bloco,
                    tipoAviso: 1,
                  )),
              buildActionIcon(
                  icon: Icons.delivery_dining,
                  titleModal: 'Delivery',
                  labelModal: 'Restaurante',
                  avisa: FuncionarioInfos.avisa_delivery,
                  pageRoute: CorrespondenciasScreen(
                    nome_responsavel: widget.nomeResponsavel,
                    idunidade: widget.idunidade,
                    localizado: widget.bloco,
                    tipoAviso: 1,
                  )),
              buildActionIcon(
                  icon: Icons.shopping_bag_rounded,
                  titleModal: 'Encomenda',
                  labelModal: 'Remetente',
                  avisa: FuncionarioInfos.avisa_encomendas,
                  pageRoute: CorrespondenciasScreen(
                    nome_responsavel: widget.nomeResponsavel,
                    idunidade: widget.idunidade,
                    localizado: widget.bloco,
                    tipoAviso: 2,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
