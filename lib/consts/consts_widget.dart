import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:validatorless/validatorless.dart';
import '../screens/splash/splash_screen.dart';
import '../widgets/shimmer_widget.dart';
import 'consts.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';

class ConstsWidget {
  static alertDialogUpdate(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // Navigator.pop(context);
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => GestureDetector(
              child: AlertDialog(
                insetPadding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                title: Text('Nova Atualização',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Padding(
                      //   padding:
                      //       EdgeInsets.symmetric(vertical: size.height * 0.025),
                      //   child: Image(
                      //     image: NetworkImage(
                      //         '${Consts.arquivoAssets}logo-login-f.png'),
                      //   ),
                      // ),
                      Container(
                        child: Text(
                          'Por favor, atualize o aplicativo para uma melhor experiência e correções',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ConstsWidget.buildCustomButton(
                    context,
                    'Abrir Loja de Aplicativo',
                    onPressed: () {
                      if (Platform.isAndroid) {
                        launchUrl(
                            Uri.parse(
                                'https://play.google.com/store/apps/details?id=com.portariaapp.porteiroapp1'),
                            mode: LaunchMode.externalApplication);
                        print('launch google');
                      } else if (Platform.isIOS) {
                        // launchUrl(Uri.parse('https://apple.co/3IakBuM'),
                        //     mode: LaunchMode.externalApplication);

                        print('launch apple');
                      }

                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ));
  }

  static Widget buildPadding001(BuildContext context,
      {double horizontal = 0, double vertical = 0.01, required Widget? child}) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.height * vertical,
        horizontal: size.width * horizontal,
      ),
      child: child,
    );
  }

  static Widget buildTitleText(
    BuildContext context, {
    Color? color,
    double fontSize = 18,
    TextAlign? textAlign,
    double? sizedWidth,
    double? height,
    TextOverflow? overflow = TextOverflow.ellipsis,
    required String title,
    int? maxLines,
  }) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: sizedWidth == null ? null : size.width * sizedWidth,
      child: Text(
        title,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: TextStyle(
            height: height,
            fontWeight: FontWeight.bold,
            fontSize: SplashScreen.isSmall ? (fontSize - 3) : fontSize,
            color: color ?? Theme.of(context).textTheme.bodyLarge!.color),
      ),
    );
  }

  static Widget buildSubTitleText(
    BuildContext context, {
    Color? color,
    double? fontSize = 16,
    required String subTitle,
    double? sizedWidth,
    TextOverflow? overflow = TextOverflow.ellipsis,
    TextAlign? textAlign,
    int? maxLines,
  }) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: sizedWidth == null ? null : size.width * sizedWidth,
      child: Text(
        subTitle,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: TextStyle(
            fontSize: SplashScreen.isSmall ? (fontSize! - 2) : fontSize,
            color: color ?? Theme.of(context).textTheme.bodyLarge!.color),
      ),
    );
  }

  static Widget buildMyTextFormField(BuildContext context,
      {required String title,
      String? mask,
      TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormatters,
      TextEditingController? controller,
      String? hintText,
      String? initialValue,
      final void Function(String? text)? onSaved}) {
    // var size = MediaQuery.of(context).size;
    return ConstsWidget.buildPadding001(
      context,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: [MaskTextInputFormatter(mask: mask)],
        initialValue: initialValue,
        onSaved: onSaved,
        controller: controller,
        textAlign: TextAlign.start,
        textInputAction: TextInputAction.next,
        keyboardType: keyboardType,
        maxLines: 5,
        minLines: 1,
        decoration:
            buildTextFieldDecoration(context, title: title, hintText: hintText),
      ),
    );
  }

  static Widget buildMyTextFormObrigatorio(BuildContext context, String title,
      {String mensagem = 'Obrigatório',
      List<TextInputFormatter>? inputFormatters,
      String? hintText,
      String? initialValue,
      String? Function(String?)? validator,
      TextEditingController? controller,
      TextInputType? keyboardType,
      bool center = false,
      int? maxLength,
      int? maxLines,
      int? minLines,
      TextAlign textAlign = TextAlign.start,
      TextCapitalization textCapitalization = TextCapitalization.none,
      bool obscureText = false,
      Iterable<String>? autofillHints,
      void Function(PointerDownEvent)? onTapOutside,
      final void Function(String? text)? onSaved}) {
    // var size = MediaQuery.of(context).size;
    return ConstsWidget.buildPadding001(
      context,
      child: TextFormField(
          // style: TextStyle(color: Theme.of(context).colorScheme.primary),
          initialValue: initialValue,
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textAlign: textAlign,
          obscureText: obscureText,
          maxLength: maxLength,
          onTapOutside: onTapOutside,
          minLines: minLines,
          textInputAction: TextInputAction.next,
          keyboardType: keyboardType,
          onSaved: onSaved,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          autofillHints: autofillHints,
          textCapitalization: textCapitalization,
          validator: validator ??
              Validatorless.multiple([Validatorless.required(mensagem)]),
          decoration: buildTextFieldDecoration(
            context,
            title: title,
            hintText: hintText,
            isobrigatorio: true,
          )
          // InputDecoration(
          //   contentPadding: EdgeInsets.symmetric(
          //       horizontal: size.width * 0.045, vertical: size.height * 0.025),
          //   filled: true,
          //   fillColor: Theme.of(context).canvasColor,
          //   label: RichText(
          //       text: TextSpan(
          //           text: title,
          //           style: TextStyle(
          //               color: Theme.of(context).textTheme.bodyLarge!.color,
          //               fontSize: 16),
          //           children: [
          //         TextSpan(text: ' *', style: TextStyle(color: Consts.kColorRed))
          //       ])),
          //   hintText: hintText,
          //   border: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(16),
          //   ),
          //   enabledBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(16),
          //     borderSide:
          //         BorderSide(color: Theme.of(context).colorScheme.primary),
          //   ),
          // ),
          ),
    );
  }

  static InputDecoration buildTextFieldDecoration(BuildContext context,
      {required String title,
      String? hintText,
      bool isobrigatorio = false,
      Widget? suffixIcon}) {
    var size = MediaQuery.of(context).size;
    return InputDecoration(
      suffixIcon: suffixIcon,
      contentPadding: EdgeInsets.symmetric(
          horizontal: size.width * 0.035, vertical: size.height * 0.025),
      filled: true,
      fillColor: Theme.of(context).canvasColor,
      labelStyle: TextStyle(),
      label: isobrigatorio
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstsWidget.buildSubTitleText(
                  context,
                  subTitle: title,
                  fontSize: SplashScreen.isSmall ? 14 : 16,
                ),
                // Text(
                //   title,
                //   style: TextStyle(fontSize: SplashScreen.isSmall ? 14 : 16),
                // ),
                Text(
                  ' *',
                  style: TextStyle(
                      fontSize: SplashScreen.isSmall ? 14 : 16,
                      color: Consts.kColorRed),
                ),
              ],
            )
          : ConstsWidget.buildTitleText(
              context,
              title: title,
              fontSize: SplashScreen.isSmall ? 14 : 16,
            ),
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  static Widget buildCustomButton(BuildContext context, String title,
      {double altura = 0.025,
      double fontSize = 18,
      double rowSpacing = 0.0,
      Color? color = Consts.kButtonColor,
      Color? textColor = Colors.white,
      required void Function()? onPressed}) {
    var size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: StadiumBorder(),
      ),
      onPressed: onPressed,
      child: ConstsWidget.buildPadding001(
        context,
        vertical: SplashScreen.isSmall ? altura + 0.005 : altura,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: size.width * rowSpacing,
            ),
            Text(
              title,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: textColor,
                fontSize: SplashScreen.isSmall ? (fontSize - 2) : fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: size.width * rowSpacing,
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildOutlinedButton(BuildContext context,
      {required String title,
      required void Function()? onPressed,
      double fontSize = 16,
      double altura = 0.025,
      double rowSpacing = 0,
      Color colorBorder = Consts.kButtonColor,
      Color colorText = Consts.kButtonColor,
      Color colorIcon = Consts.kButtonColor,
      Color? backgroundColor = Colors.transparent}) {
    var size = MediaQuery.of(context).size;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        alignment: Alignment.center,
        backgroundColor: backgroundColor,
        side: BorderSide(width: size.width * 0.005, color: colorBorder),
        shape: StadiumBorder(),
      ),
      onPressed: onPressed,
      child: buildPadding001(
        context,
        vertical: SplashScreen.isSmall ? altura + 0.004 : altura,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: size.width * rowSpacing,
            ),
            Text(
              title,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: colorText,
                fontSize: SplashScreen.isSmall ? 14 : 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: size.width * rowSpacing,
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildLoadingButton(BuildContext context,
      {required void Function()? onPressed,
      required bool isLoading,
      required String title,
      color = Consts.kColorApp,
      double rowSpacing = 0.0,
      double height = 0.025,
      double fontSize = 18}) {
    var size = MediaQuery.of(context).size;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          // padding: EdgeInsets.symmetric(
          //     vertical: SplashScreen.isSmall
          //         ? size.height * height - 0.007
          //         : size.height * height),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Consts.borderButton))),
      onPressed: isLoading ? () {} : onPressed,
      child: buildPadding001(context,
          vertical: SplashScreen.isSmall ? height + 0.005 : height,
          child: !isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width * rowSpacing,
                    ),
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            SplashScreen.isSmall ? (fontSize - 2) : fontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: size.width * rowSpacing,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: size.height * 0.025,
                      width: size.width * 0.05,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )),
    );
  }

  static Widget buildAtivoInativo(
    BuildContext context,
    bool ativo, {
    String verdadeiro = 'Ativo',
    String falso = 'Inativo',
  }) {
    return Container(
      decoration: BoxDecoration(
          color: ativo ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildTitleText(context, title: ativo ? verdadeiro : falso),
      ),
    );
  }

  static Widget buildClosePop(BuildContext context,
      {required title, double paddingX = 0.02}) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * paddingX),
      child: Row(
        children: [
          ConstsWidget.buildTitleText(context, title: title),
          Spacer(),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                color: Theme.of(context).iconTheme.color,
              )),
        ],
      ),
    );
  }

  static Widget buildDropButtonAvisos(BuildContext context,
      {required List categoryItem, required Object? dropdownValue}) {
    var size = MediaQuery.of(context).size;
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
        child: Container(
          width: double.infinity,
          height: size.height * 0.07,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                // shape: Border.all(color: Colors.black),
                child: DropdownButton(
                  value: dropdownValue,
                  items: categoryItem.map((e) {
                    return DropdownMenuItem(
                        value: e['idmsg'],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstsWidget.buildTitleText(context,
                                title: e['titulo']),
                            ConstsWidget.buildSubTitleText(context,
                                subTitle: e['texto'])
                            // ListTile(
                            //   textColor: Theme.of(context)
                            // ,
                            //   title: Text(e['titulo']),
                            //   subtitle: Text(e['texto']),
                            // ),
                          ],
                        ));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      dropdownValue = value;
                    });
                  },
                  elevation: 24,
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_downward,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  hint: Text('Selecione Um Aviso'),
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  static Widget buildCheckBox(BuildContext context,
      {required bool isChecked,
      required void Function(bool?)? onChanged,
      required String title,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center}) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          buildTitleText(context, title: title),
          Transform.scale(
            scale: 1,
            child: Checkbox(
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(15)),
              value: isChecked,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildRefreshIndicadtor(BuildContext context,
      {required Widget child, required Future<void> Function() onRefresh}) {
    var size = MediaQuery.of(context).size;
    return RefreshIndicator(
        strokeWidth: 2,
        backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
        color: Theme.of(context).canvasColor,
        displacement: size.height * 0.1,
        onRefresh: onRefresh,
        child: child);
  }

  static Widget buildCachedImage(
    BuildContext context, {
    required String iconApi,
    double? width,
    double? height,
    bool iconQuadrado = false,
  }) {
    var size = MediaQuery.of(context).size;
    return CachedNetworkImage(
      imageUrl: iconApi,
      height: !iconQuadrado
          ? height != null
              ? size.height * height
              : null
          : width,
      width: !iconQuadrado
          ? width != null
              ? size.width * width
              : null
          : width,
      fit: BoxFit.fill,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholder: (context, url) => ShimmerWidget(
          height:
              SplashScreen.isSmall ? size.height * 0.06 : size.height * 0.068,
          width: size.width * 0.15),
      errorWidget: (context, url, error) => Image.asset('ico-error.png'),
    );
  }

  static Widget buildBadge(BuildContext context,
      {int title = 0,
      required bool showBadge,
      required Widget? child,
      BadgePosition? position}) {
    BadgeShape shape = title >= 10 ? BadgeShape.square : BadgeShape.circle;
    String titleString = title > 99
        ? '+99'
        : title == 0
            ? ''
            : title.toString();
    double? fontSize = title >= 10
        ? SplashScreen.isSmall
            ? 12
            : 14
        : SplashScreen.isSmall
            ? 14
            : 16;

    return badges.Badge(
        showBadge: showBadge,
        // stackFit: StackFit.expand,
        badgeAnimation: badges.BadgeAnimation.fade(toAnimate: false),
        badgeContent: Text(
          titleString,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize),
        ),
        position: position,
        badgeStyle: badges.BadgeStyle(
          badgeColor: Consts.kColorRed,
          borderRadius: BorderRadius.circular(16),
          shape: shape,
        ),
        child: child);
  }

  static Widget buildCamposObrigatorios(BuildContext context) {
    return ConstsWidget.buildPadding001(
      context,
      child: Center(
        child: buildTitleText(context,
            title: '(*) Campos Obrigatórios', color: Consts.kColorRed),
      ),
    );
  }
}
