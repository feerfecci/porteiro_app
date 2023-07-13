import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:validatorless/validatorless.dart';

import '../consts/consts_widget.dart';

Widget buildMyTextFormField(BuildContext context,
    {required String label,
    String? mask,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
    String? initialValue,
    bool readOnly = false,
    final void Function(String? text)? onSaved,
    void Function()? onTap}) {
  var size = MediaQuery.of(context).size;
  return ConstsWidget.buildPadding001(
    context,
    child: TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [MaskTextInputFormatter(mask: mask)],
      initialValue: initialValue,
      onTap: onTap,
      onSaved: onSaved,
      textAlign: TextAlign.start,
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: 5,
      minLines: 1,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: size.width * 0.03,
          vertical: size.height * 0.020,
        ),
        filled: true,
        fillColor: Theme.of(context).canvasColor,
        label: Text(label),
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

Widget buildMyTextFormObrigatorio(BuildContext context, String title,
    {String mensagem = 'Obrigatório',
    String? mask,
    String? hintText,
    String? initialValue,
    TextInputType? keyboardType,
    bool readOnly = false,
    int? maxLength,
    int? maxLines,
    int? minLines,
    TextEditingController? controller,
    String? Function(String?)? validator,
    final void Function(String? text)? onSaved}) {
  var size = MediaQuery.of(context).size;
  return ConstsWidget.buildPadding001(
    context,
    child: TextFormField(
      controller: controller,
      initialValue: initialValue,
      keyboardType: keyboardType,
      readOnly: readOnly,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlign: TextAlign.start,
      textInputAction: TextInputAction.next,
      onSaved: onSaved,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines,
      inputFormatters: [MaskTextInputFormatter(mask: mask)],
      validator: Validatorless.multiple([Validatorless.required(mensagem)]),
      decoration: InputDecoration(
        hintStyle: TextStyle(height: 1.4),
        contentPadding: EdgeInsets.symmetric(
          horizontal: size.width * 0.03,
          vertical: size.height * 0.020,
        ),
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
