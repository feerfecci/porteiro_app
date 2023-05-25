import 'package:flutter/material.dart';
import '../consts/consts_widget.dart';

buildMinhaSnackBar(
  BuildContext context, {
  IconData icon = Icons.error_outline,
  String title = 'Algo deu errado',
  String subTitle = 'Tente novamente',
  /*required String categoria*/
}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  var size = MediaQuery.of(context).size;
  // apiAvisos() async {
  //   var url = Uri.parse('${logado.comecoAPI}snackbars/?fn=$categoria');
  //   var resposta = await http.get(url);
  //   if (resposta.statusCode == 200) {
  //     return json.decode(resposta.body);
  //   } else {
  //     return null;
  //   }
  // }
  // Widget buildCorpoSnack(double width) {
  //   return Row(
  //     children: [
  //       Icon(icon, color: Colors.white),
  //       SizedBox(
  //         width: size.width * width,
  //       ),
  //       Expanded(
  //         child: FutureBuilder<dynamic>(
  //           future: apiAvisos(),
  //           builder: (context, snapshot) {
  //             if (snapshot.connectionState == ConnectionState.waiting) {
  //               return Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   ShimmerWidget.rectangular(
  //                     height: size.height * 0.015,
  //                     width: size.width * 0.25,
  //                   ),
  //                   SizedBox(
  //                     height: size.height * 0.01,
  //                   ),
  //                   ShimmerWidget.rectangular(height: size.height * 0.03)
  //                 ],
  //               );
  //             }
  //             var titulo = snapshot.data!['titulo'];
  //             var texto = snapshot.data!['texto'];
  //             return Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 logado.buildTextTitle(titulo, color: Colors.white
  //                     // color: Theme.of(context).snackBarTheme.actionTextColor,
  //                     ),
  //                 logado.buildTextSubTitle(texto, color: Colors.white
  //                     // color: Theme.of(context).snackBarTheme.actionTextColor,
  //                     ),
  //               ],
  //             );
  //           },
  //         ),
  //       ),
  //       // ElevatedButton(
  //       //     onPressed: () {
  //       //       Navigator.pop(context);
  //       //     },
  //       //     child: Text('fechar'))
  //     ],
  //   );
  // }

  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        showCloseIcon: true,
        closeIconColor: Colors.white,
        dismissDirection: DismissDirection.endToStart,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        // action: SnackBarAction(
        //     label: 'Entendi',
        //     textColor: Colors.white,
        //     onPressed: (() {
        //       try {
        //         ScaffoldMessenger.of(context).clearSnackBars();
        //       } on FlutterError catch (e) {
        //         print(e);
        //       }
        //     })),
        elevation: 8,
        duration: Duration(seconds: 4),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              width: size.width * 0.02,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstsWidget.buildTitleText(context,
                    title: title, color: Colors.white),
                ConstsWidget.buildSubTitleText(context,
                    subTitle: subTitle, color: Colors.white)
              ],
            ),
          ],
        )),
  );
}
