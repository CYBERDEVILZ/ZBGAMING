import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key, required this.indent, required this.height, required this.radius}) : super(key: key);

  final double indent;
  final double height;
  final bool radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: indent),
      height: height,
      decoration: BoxDecoration(
          image: const DecorationImage(image: AssetImage("assets/images/horizontal-bar.png"), fit: BoxFit.cover),
          borderRadius: radius ? const BorderRadius.all(Radius.circular(1000)) : BorderRadius.zero),
    );
  }
}
