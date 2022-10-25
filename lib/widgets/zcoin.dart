import 'package:flutter/material.dart';

import '../pages/buy_coins.dart';

class Zcoin extends StatefulWidget {
  const Zcoin({Key? key, this.coin}) : super(key: key);
  final int? coin;

  @override
  State<Zcoin> createState() => _ZcoinState();
}

class _ZcoinState extends State<Zcoin> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const BuyCoins()));
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
              Text("${widget.coin}", style: const TextStyle(fontSize: 14)),
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
