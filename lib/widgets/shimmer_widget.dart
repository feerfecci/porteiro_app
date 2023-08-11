import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final double circular;
  final ShapeBorder shapeBorder;
  const ShimmerWidget(
      {this.width = double.infinity,
      required this.height,
      this.circular = 16,
      super.key})
      : shapeBorder = const RoundedRectangleBorder();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[400]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(circular),
            ),
          ),
        ));
  }
}
