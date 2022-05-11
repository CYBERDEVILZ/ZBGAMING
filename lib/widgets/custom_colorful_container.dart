import 'package:flutter/material.dart';

class ShadowedContainer extends StatelessWidget {
  const ShadowedContainer(
      {Key? key, required this.textWidget, this.colorBottom, this.colorTop})
      : super(key: key);

  final Text textWidget;
  final Color? colorBottom;
  final Color? colorTop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 27, right: 23),
      child: Column(children: [
        Stack(clipBehavior: Clip.none, children: [
          Container(
            padding: const EdgeInsets.all(8),
            color: colorBottom ?? const Color.fromARGB(255, 36, 234, 248),
            constraints: const BoxConstraints(minHeight: 50),
            width: MediaQuery.of(context).size.width,
            child: textWidget,
          ),
          Positioned(
            bottom: 5,
            right: 5,
            left: -5,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              color: colorTop ?? const Color.fromARGB(255, 7, 133, 155),
              width: MediaQuery.of(context).size.width,
              constraints: const BoxConstraints(minHeight: 50),
              child: textWidget,
            ),
          ),
        ]),
      ]),
    );
  }
}
