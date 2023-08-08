// ignore_for_file: must_be_immutable
import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/widgets/my_box_shadow.dart';
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
      vertical: 0.025,
      horizontal: 0.2,
      center: true,
      readOnly: true,
      onTap: () => showSearch(context: context, delegate: delegate),
    );
  }
}
