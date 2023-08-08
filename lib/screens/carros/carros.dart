import 'package:app_porteiro/screens/seach_pages/search_veiculo.dart';
import 'package:app_porteiro/widgets/seachBar.dart';
import 'package:flutter/material.dart';

class CarrosPage extends StatefulWidget {
  const CarrosPage({super.key});

  @override
  State<CarrosPage> createState() => _CarrosPageState();
}

class _CarrosPageState extends State<CarrosPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
      child: SeachBar(
        label: 'Pesquise um carro',
        hintText: 'aaa0101',
        delegate: SearchVeiculo(),
      ),
    ));
  }
}
