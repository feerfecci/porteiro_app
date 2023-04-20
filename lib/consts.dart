import 'package:flutter/material.dart';

class Consts {
  static Widget buildTitleText(String title) {
    return Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    );
  }

  static Widget buildSubTitleText(String subTitle) {
    return Text(
      subTitle,
      style: TextStyle(fontSize: 16),
    );
  }

  static Widget buildTextFormField({required String label}) {
    return TextFormField(
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        label: Text(label),
        fillColor: Colors.grey[200],
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
      ),
    );
  }
}
