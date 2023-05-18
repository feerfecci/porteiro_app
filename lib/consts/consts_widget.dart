import 'package:flutter/material.dart';

import 'consts.dart';

class ConstsWidget {
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
}
