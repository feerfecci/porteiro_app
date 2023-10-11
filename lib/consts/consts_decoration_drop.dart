import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../widgets/page_erro.dart';
import '../widgets/page_vazia.dart';
import 'consts_widget.dart';

class DecorationDropSearch {
  static dropdownDecoratorProps(BuildContext context) {
    return DropDownDecoratorProps(
      textAlign: TextAlign.center,
      dropdownSearchDecoration: InputDecoration(
        hintText: 'asdgfasdgsad',
        hintStyle: TextStyle(color: Colors.black, fontSize: 18),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }

  static dropdownButtonProps(BuildContext context) {
    return DropdownButtonProps(
        style: ButtonStyle(
          alignment: Alignment.center,
        ),
        alignment: Alignment.center,
        color: Theme.of(context).colorScheme.primary,
        icon: Icon(Icons.arrow_downward,
            color:
                //  Colors.red
                Theme.of(context).textTheme.bodyLarge!.color));
  }

  static searchFieldProps(BuildContext context, {String? hintText}) {
    return TextFieldProps(
      textAlign: TextAlign.center,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyLarge!.color),
      decoration: InputDecoration(
        hintText: hintText,
        // hintStyle: TextStyle(
        //   color: Theme.of(context).colorScheme.primary,
        // ),
        filled: true,
        fillColor: Theme.of(context).canvasColor,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }

  static itemBuilder(BuildContext context, String title,
      {bool divisor = true}) {
    var size = MediaQuery.of(context).size;
    return ConstsWidget.buildPadding001(
      context,
      vertical: 0.02,
      horizontal: 0.03,
      child: Column(
        children: [
          Center(
            child: ConstsWidget.buildTitleText(context,
                title: title, maxLines: 3, textAlign: TextAlign.center),
          ),
          if (divisor)
            Container(
              height: size.height * 0.02,
            ),
          if (divisor)
            Container(
              color: Theme.of(context).colorScheme.primary,
              height: 1,
            ),
        ],
      ),
    );
  }

  static dropDownBuilder(BuildContext context, String title) {
    return Center(
      child: ConstsWidget.buildTitleText(context, title: title),
    );
  }

  static emptyBuilder(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        height: size.height * 0.6,
        width: size.width * 0.6,
        child: PageVazia(
          title: 'Não Encontramos Nada',
        ),
      ),
    );
  }

  static errorBuilder(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        height: size.height * 0.6,
        width: size.width * 0.6,
        child: PageErro(),
      ),
    );
  }

  static MenuProps menuProps(BuildContext context) {
    return MenuProps(
      barrierColor: Colors.black38,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
