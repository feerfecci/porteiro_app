import 'package:app_porteiro/seach_pages/search_unidades.dart';
import 'package:app_porteiro/widgets/my_textform_field.dart';
import 'package:flutter/material.dart';

class SeachBar extends StatelessWidget {
  SearchDelegate<String> delegate;
  String label;
  String hintText;
  SeachBar(
      {required this.delegate,
      required this.label,
      required this.hintText,
      super.key});

  @override
  Widget build(BuildContext context) {
    return buildMyTextFormField(
      context,
      label: label,
      hintText: 'Exemplo: $hintText',
      readOnly: true,
      onTap: () => showSearch(context: context, delegate: delegate),
    );
  }
}
