import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Zcoin extends StatefulWidget {
  const Zcoin({Key? key}) : super(key: key);

  @override
  State<Zcoin> createState() => _ZcoinState();
}

class _ZcoinState extends State<Zcoin> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Fluttertoast.showToast(msg: "take to coin shop");
      },
      child: Container(
          padding: const EdgeInsets.all(5),
          constraints: const BoxConstraints(minWidth: 50, minHeight: 10),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(500)),
              color: Colors.white,
              border: Border.all(color: Colors.amber[700]!, width: 2)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Image(
                image: AssetImage("assets/images/zcoin.png"),
                height: 18,
              ),
              const Text(" 200000", style: TextStyle(fontSize: 14)),
              Icon(
                Icons.add,
                size: 18,
                color: Colors.amber[700]!,
              )
            ],
          )),
    );
  }
}
