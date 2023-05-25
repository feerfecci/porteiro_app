import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:validatorless/validatorless.dart';

import 'consts.dart';

class ConstsWidget {
  static Widget buildTitleText(
    BuildContext context, {
    Color? color,
    required String? title,
  }) {
    return Text(
      title ?? '',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: color ?? Theme.of(context).colorScheme.primary),
    );
  }

  static Widget buildSubTitleText(
    BuildContext context, {
    Color? color,
    required String subTitle,
  }) {
    return Text(
      subTitle,
      style: TextStyle(
          fontSize: 14, color: color ?? Theme.of(context).colorScheme.primary),
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: TextFormField(
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
      final void Function(String? text)? onSaved}) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: TextFormField(
        initialValue: initialValue,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textAlign: TextAlign.start,
        textInputAction: TextInputAction.next,
        onSaved: onSaved,
        maxLines: 5,
        minLines: 1,
        inputFormatters: inputFormatters,
        validator: validator ??
            Validatorless.multiple([Validatorless.required(mensagem)]),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: size.width * 0.02),
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
      Color? color = Consts.kButtonColor,
      Color? textColor = Colors.white,
      Color? iconColor = Colors.white,
      required void Function()? onPressed}) {
    var size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Consts.borderButton),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              title,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: size.width * 0.015,
            ),
            icon != null ? Icon(size: 18, icon, color: iconColor) : SizedBox(),
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

  static Widget buildClosePop(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: Theme.of(context).iconTheme.color,
            )),
      ],
    );
  }
}
