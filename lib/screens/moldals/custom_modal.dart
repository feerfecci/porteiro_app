import 'package:flutter/material.dart';
import '../../consts/consts.dart';
import '../../consts/consts_widget.dart';

showCustomModalBottom(BuildContext context,
    {required String title, required String label}) {
  var size = MediaQuery.of(context).size;
  showModalBottomSheet(
    enableDrag: false,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (context) => SizedBox(
        height: size.height * 0.7,
        child: Padding(
          padding: EdgeInsets.all(size.height * 0.01),
          child: WidgetCustomModal(title: title, label: label),
        )),
  );
}

class WidgetCustomModal extends StatefulWidget {
  final String title;
  final String label;
  const WidgetCustomModal(
      {required this.title, required this.label, super.key});

  @override
  State<WidgetCustomModal> createState() => _WidgetCustomModalState();
}

class _WidgetCustomModalState extends State<WidgetCustomModal> {
  int qnt = 0;
  increment() {
    setState(() {
      qnt++;
    });
  }

  decrement() {
    setState(() {
      qnt--;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
          child: ConstsWidget.buildTitleText(widget.title),
        ),
        Row(
          children: [
            SizedBox(
              width: size.width * 0.80,
              child: ConstsWidget.buildTextFormField(label: widget.label),
            ),
            SizedBox(
              width: size.width * 0.005,
            ),
            // Container(
            //   height: 30,
            //   width: 30,
            //   color: Colors.grey,
            //   child: Icon(Icons.remove_outlined),
            // ),
            IconButton(
                onPressed: qnt == 0
                    ? () {}
                    : () {
                        decrement();
                      },
                icon: Icon(
                  Icons.remove_circle,
                  color: qnt == 0 ? Colors.grey : Colors.black,
                  size: size.height * 0.035,
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              child: Text(
                '$qnt',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            IconButton(
                onPressed: () {
                  increment();
                },
                icon: Icon(
                  Icons.add_circle,
                  size: size.height * 0.035,
                )),
            // Container(
            //   height: 30,
            //   width: 30,
            //   color: Colors.grey,
            //   child: Icon(Icons.plus_one),
            // ),
          ],
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        ElevatedButton(
          onPressed: () {},
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Salvar e avisar',
            ),
          ),
        ),
      ],
    );
  }
}
