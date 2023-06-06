// ignore_for_file: prefer_const_literals_to_create_immutables, non_constant_identifier_names
import 'package:app_porteiro/consts/consts.dart';
import 'package:app_porteiro/consts/consts_future.dart';
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/moldals/modal_avisa_delivery.dart';
import 'package:app_porteiro/screens/correspondencias/correspondencias_screen.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:flutter/material.dart';

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
      required IconData icon,
      required bool avisa,
      Widget? pageRoute,
      void Function()? onPressed,
    }) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.005),
        child: MyBoxShadow(
          color: avisa ? null : Colors.grey,
          // border: Border.all(color: Theme.of(context).colorScheme.primary),
          paddingAll: 0.002,
          child: IconButton(
            onPressed: avisa
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
            icon: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
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
          // Text(widget.nome_moradores),
          SizedBox(
            height: size.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // mainAxisSize: MainAxisSize.min,
            children: [
              if (FuncionarioInfos.avisa_corresp)
                buildActionIcon(
                    titleModal: 'Correspondências',
                    labelModal: 'Remetente',
                    icon: Icons.email,
                    avisa: FuncionarioInfos.avisa_corresp,
                    pageRoute: CorrespondenciasScreen(
                      idunidade: widget.idunidade,
                      localizado: widget.bloco,
                      nome_responsavel: widget.nomeResponsavel,
                      tipoAviso: 3,
                    )),
              if (FuncionarioInfos.avisa_visita)
                buildActionIcon(
                    avisa: FuncionarioInfos.avisa_visita,
                    icon: Icons.person_add_alt_1_sharp,
                    onPressed: () {
                      showModalAvisaDelivery(context,
                          idunidade: widget.idunidade,
                          localizado: widget.bloco,
                          nome_responsavel: widget.nomeResponsavel,
                          tipoAviso: 2
                          // nome_moradores: widget.nome_moradores,
                          );
                    }),
              if (FuncionarioInfos.avisa_delivery)
                buildActionIcon(
                    avisa: FuncionarioInfos.avisa_delivery,
                    icon: Icons.delivery_dining,
                    onPressed: () {
                      showModalAvisaDelivery(context,
                          idunidade: widget.idunidade,
                          localizado: widget.bloco,
                          nome_responsavel: widget.nomeResponsavel,
                          tipoAviso: 1
                          // nome_moradores: widget.nome_moradores,
                          );
                    }),
              /* Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.005),
                child: MyBoxShadow(
                  color: FuncionarioInfos.avisa_delivery ? null : Colors.grey,
                  paddingAll: 0.002,
                  child: IconButton(
                    onPressed: FuncionarioInfos.avisa_delivery
                        ? () {
                            showModalAvisaDelivery(
                              context,
                              idunidade: widget.idunidade,
                              localizado: widget.bloco,
                              nome_responsavel: widget.nomeResponsavel,
                              // nome_moradores: widget.nome_moradores,
                            );
                          }
                        : () {
                            buildMinhaSnackBar(context,
                                title: 'Desculpe',
                                subTitle: 'Você não tem acesso à essa ação');
                          },
                    icon: Icon(
                      Icons.delivery_dining,
                    ),
                  ),
                ),
              ),
             */
              buildActionIcon(
                  icon: Icons.shopping_bag_rounded,
                  titleModal: 'Encomenda',
                  labelModal: 'Remetente',
                  avisa: FuncionarioInfos.avisa_encomendas,
                  pageRoute: CorrespondenciasScreen(
                    nome_responsavel: widget.nomeResponsavel,
                    idunidade: widget.idunidade,
                    localizado: widget.bloco,
                    tipoAviso: 4,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
