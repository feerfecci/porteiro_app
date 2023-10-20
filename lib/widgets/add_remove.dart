import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../consts/consts.dart';
import '../consts/consts_widget.dart';

class AddRemoveFild extends StatefulWidget {
  final TextEditingController qntCtrl;
  const AddRemoveFild({required this.qntCtrl, super.key});

  @override
  State<AddRemoveFild> createState() => _AddRemoveFildState();
}

class _AddRemoveFildState extends State<AddRemoveFild> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: CircleBorder(), backgroundColor: Consts.kColorApp),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            if (widget.qntCtrl.text != '') {
              if (int.parse(widget.qntCtrl.text) > 1) {
                setState(() {
                  widget.qntCtrl.text = '${int.parse(widget.qntCtrl.text) - 1}';
                });
              }
            } else {
              setState(() {
                widget.qntCtrl.text == '1';
              });
            }
          },
          child: Icon(
            Icons.remove,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: size.width * 0.27,
          child: ConstsWidget.buildMyTextFormObrigatorio(context, 'Quantidade',
              textAlign: TextAlign.center,
              inputFormatters: [MaskTextInputFormatter(mask: '###')],
              keyboardType: TextInputType.number,

              // initialValue: widget.qntCtrl.text
              controller: widget.qntCtrl),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: CircleBorder(), backgroundColor: Consts.kColorApp),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            if (widget.qntCtrl.text != '') {
              if (int.parse(widget.qntCtrl.text) >= 1 &&
                  int.parse(widget.qntCtrl.text) < 999) {
                setState(() {
                  widget.qntCtrl.text = '${int.parse(widget.qntCtrl.text) + 1}';
                });
              }
            } else {
              setState(() {
                widget.qntCtrl.text = '1';
              });
            }
          },
          child: Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }
}
