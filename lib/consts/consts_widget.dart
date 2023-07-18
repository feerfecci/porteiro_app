import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:validatorless/validatorless.dart';

import 'consts.dart';

class ConstsWidget {
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
    double fontSize = 16,
    TextAlign? textAlign,
    required String? title,
  }) {
    return Text(
      title ?? '',
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          color: color ?? Theme.of(context).colorScheme.primary),
    );
  }

  static Widget buildSubTitleText(
    BuildContext context, {
    Color? color,
    double? fontSize = 14,
    required String subTitle,
  }) {
    return Text(
      subTitle,
      style: TextStyle(
          fontSize: fontSize,
          color: color ?? Theme.of(context).colorScheme.primary),
    );
  }

  static Widget buildMyTextFormField(BuildContext context,
      {required String title,
      String? mask,
      TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormatters,
      String? hintText,
      String? initialValue,
      final void Function(String? text)? onSaved}) {
    var size = MediaQuery.of(context).size;
    return ConstsWidget.buildPadding001(
      context,
      child: TextFormField(
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: [MaskTextInputFormatter(mask: mask)],
        initialValue: initialValue,
        onSaved: onSaved,
        textAlign: TextAlign.start,
        textInputAction: TextInputAction.next,
        keyboardType: keyboardType,
        maxLines: 5,
        minLines: 1,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: size.width * 0.04),
          filled: true,
          fillColor: Theme.of(context).canvasColor,
          label: Text(title),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.black26),
          ),
        ),
      ),
    );
  }

  static Widget buildMyTextFormObrigatorio(BuildContext context, String title,
      {String mensagem = 'Este campo é obrigatótio',
      List<TextInputFormatter>? inputFormatters,
      String? hintText,
      String? initialValue,
      String? Function(String?)? validator,
      bool obscureText = false,
      final void Function(String? text)? onSaved}) {
    var size = MediaQuery.of(context).size;
    return ConstsWidget.buildPadding001(
      context,
      child: TextFormField(
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        initialValue: initialValue,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textAlign: TextAlign.start,
        obscureText: obscureText,
        textInputAction: TextInputAction.next,
        onSaved: onSaved,
        inputFormatters: inputFormatters,
        validator: validator ??
            Validatorless.multiple([Validatorless.required(mensagem)]),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: size.width * 0.045, vertical: size.height * 0.025),
          filled: true,
          fillColor: Theme.of(context).canvasColor,
          label: Text(title),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.black26),
          ),
        ),
      ),
    );
  }

  static Widget buildCustomButton(BuildContext context, String title,
      {IconData? icon,
      double? altura,
      double fontSize = 16,
      Color? color = Consts.kButtonColor,
      Color? textColor = Colors.white,
      Color? iconColor = Colors.white,
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
        vertical: 0.023,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (icon != null) Icon(size: 18, icon, color: iconColor),
            if (icon != null)
              SizedBox(
                width: size.width * 0.015,
              ),
            Text(
              title,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildAtivoInativo(BuildContext context, bool ativo) {
    return Container(
      decoration: BoxDecoration(
          color: ativo ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildTitleText(context, title: ativo ? 'Ativo' : 'Inativo'),
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

  static Widget buildLoadingButton(BuildContext context,
      {required void Function()? onPressed,
      required bool isLoading,
      required String title,
      color = Consts.kColorApp,
      double fontSize = 14}) {
    var size = MediaQuery.of(context).size;

    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.025),
            backgroundColor: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Consts.borderButton))),
        onPressed: onPressed,
        child: isLoading == false
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                    ),
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
              ));
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
                            //   textColor: Theme.of(context).colorScheme.primary,
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
                      color: Theme.of(context).colorScheme.primary,
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
            scale: 1.3,
            child: Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              value: isChecked,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildOutlinedButton(
    BuildContext context, {
    required String title,
    required void Function()? onPressed,
    double fontSize = 16,
    IconData? icon,
    double? altura,
    Color? color = Consts.kButtonColor,
  }) {
    var size = MediaQuery.of(context).size;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        alignment: Alignment.center,
        side: BorderSide(width: size.width * 0.005, color: Colors.blue),
        shape: StadiumBorder(),
      ),
      onPressed: onPressed,
      child: buildPadding001(
        context,
        vertical: 0.023,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (icon != null) Icon(size: 18, icon, color: Consts.kButtonColor),
            if (icon != null)
              SizedBox(
                width: size.width * 0.015,
              ),
            Text(
              title,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Consts.kButtonColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
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
}
