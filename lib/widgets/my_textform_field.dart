import 'package:app_porteiro/screens/home/home_page.dart';
import 'package:app_porteiro/screens/splash/splash_screen.dart';
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
    bool center = false,
    TextEditingController? controller,
    double vertical = 0,
    double horizontal = 0.03,
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
      controller: controller,
      textAlign: TextAlign.start,
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: 5,
      minLines: 1,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: size.width * horizontal,
          vertical: size.height * vertical,
        ),
        filled: true,
        fillColor: Theme.of(context).canvasColor,
        label: center ? Center(child: Text(label)) : Text(label),
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
    TextCapitalization textCapitalization = TextCapitalization.none,
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
      textCapitalization: textCapitalization,
      maxLines: maxLines,
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
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
        label: ConstsWidget.buildTitleText(context,
            title: title, fontSize: SplashScreen.isSmall ? 16 : 18),
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
