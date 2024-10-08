import 'package:app_porteiro/screens/correspondencias/cartas_caixas_screen/emite_entrega_screen.dart';
import 'package:app_porteiro/screens/splash/splash_screen.dart';
import 'package:app_porteiro/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import '../../../consts/consts.dart';
import '../../../consts/consts_future.dart';
import '../../../consts/consts_widget.dart';

import '../../../widgets/my_box_shadow.dart';
import '../../../widgets/page_erro.dart';
import '../../../widgets/page_vazia.dart';

class AlertListMoradores extends StatefulWidget {
  final int idunidade;
  final String listEntregar;
  const AlertListMoradores(
      {required this.idunidade, required this.listEntregar, super.key});

  @override
  State<AlertListMoradores> createState() => _AlertListMoradoresState();
}

class _AlertListMoradoresState extends State<AlertListMoradores> {
  bool isChecked = false;
  int idMorador = 0;
  @override
  void initState() {
    ConstsFuture.launchGetApi(
        'moradores/index.php?fn=listarMoradores&idcond=${FuncionarioInfos.idcondominio}&idfuncionario=${FuncionarioInfos.idFuncionario}&idunidade=${widget.idunidade}');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return
        // AlertDialog(
        //   insetPadding: EdgeInsets.symmetric(
        //     horizontal: size.width * 0.03,
        //   ),
        //   title: Row(
        //     children: [
        //       ConstsWidget.buildTitleText(context, title: 'Quem está retirando'),
        //       Spacer(),
        //       ConstsWidget.buildClosePop(context),
        //     ],
        //   ),
        //   content:
        // Column(
        //   children: [
        //     ConstsWidget.buildTitleText(context, title: 'Quem está retirando'),
        FutureBuilder(
      future: ConstsFuture.launchGetApi(
          'moradores/index.php?fn=listarMoradores&idcond=${FuncionarioInfos.idcondominio}&idunidade=${widget.idunidade}&idfuncionario=${FuncionarioInfos.idFuncionario}'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          if (!snapshot.data['erro']) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: EdgeInsets.all(size.width * 0.02),
              insetPadding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.02, vertical: size.height * 0.05),
              title: ConstsWidget.buildTitleText(context,
                  title: 'Quem Está Retirando', textAlign: TextAlign.center),
              content: SizedBox(
                width: size.width * 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstsWidget.buildPadding001(
                      context,
                      child: SizedBox(
                        height: snapshot.data['morador'].length > 4
                            ? size.height * 0.6
                            : null,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data['morador'].length,
                          itemBuilder: (context, index) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return MyBoxShadow(
                                child: ConstsWidget.buildCheckBox(context,
                                    isChecked: isChecked, onChanged: (value) {
                                  setState(
                                    () {
                                      isChecked = value!;
                                      if (value) {
                                        idMorador = snapshot.data['morador']
                                            [index]['idmorador'];
                                      } else {
                                        idMorador = 0;
                                      }
                                    },
                                  );
                                },
                                    title: snapshot.data['morador'][index]
                                        ['nome_morador']),
                              );
                            });
                          },
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: size.height * 0.01,
                    // ),
                    ConstsWidget.buildPadding001(
                      context,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ConstsWidget.buildOutlinedButton(
                            context,
                            title: "Cancelar",
                            rowSpacing: 0.08,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ConstsWidget.buildCustomButton(
                            context,
                            "Continuar",
                            color: Consts.kColorRed,
                            rowSpacing: 0.06,
                            onPressed: () {
                              if (idMorador != 0) {
                                Navigator.of(context).pop();
                                ConstsFuture.navigatorPush(
                                    context,
                                    EmiteEntregaScreen(
                                        idunidade: widget.idunidade,
                                        idMorador: idMorador,
                                        tipoCompara: 'senha',
                                        listEntregar: widget.listEntregar));

                                // showModalEmiteEntrega(context,
                                //     idunidade: widget.idunidade,
                                //     idMorador: idMorador,
                                //     tipoCompara: 'senha',
                                //     listEntregar: widget.listEntregar);
                              } else {
                                buildMinhaSnackBar(context, hasError: true);
                              }
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return AlertDialog(
              contentPadding: EdgeInsets.all(size.width * 0.02),
              insetPadding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.02, vertical: size.height * 0.05),
              content: PageVazia(
                title: snapshot.data['mensagem'],
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                  child: ConstsWidget.buildOutlinedButton(
                    context,
                    title: "Cancelar",
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            );
          }
        } else {
          return PageErro();
        }
      },
      // ),
      // actions: [
      //   Padding(
      //     padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
      //     child: ElevatedButton(
      //       onPressed: () {
      //         Navigator.of(context).pop();
      //       },
      //       style: ElevatedButton.styleFrom(
      //         backgroundColor: Colors.red,
      //       ),
      //       child: Text(
      //         "Cancelar",
      //         style: TextStyle(color: Colors.white),
      //       ),
      //     ),
      //   ),
      //   ElevatedButton(
      //     onPressed: () {
      //       if (idMorador != 0) {
      //         Navigator.of(context).pop();

      //         showModalEmiteEntrega(context,
      //             idunidade: widget.idunidade,
      //             idMorador: idMorador,
      //             tipoCompara: 2,
      //             listEntregar: widget.listEntregar);
      //       } else {
      //         buildMinhaSnackBar(context);
      //       }
      //     },
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: Colors.blue,
      //     ),
      //     child: Text(
      //       "Continuar",
      //       style: TextStyle(color: Colors.white),
      //     ),
      //   ),
      // ],

      // ConstsWidget.buildCustomButton(
      //   context,
      //   'asd',
      //   onPressed: () {
      //     showModalEmiteEntrega(
      //       context,
      //       idunidade: idunidade,
      //       tipoCompara: 2,
      //       listEntregar: listEntregar,
      //       idMorador: idMorador,
      //     );
      //   },
      // )
      //   ],
      // ),
    );
  }
}
