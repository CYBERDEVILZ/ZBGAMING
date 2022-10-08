import 'package:flutter/material.dart';

class UserCoins extends StatefulWidget {
  const UserCoins({Key? key}) : super(key: key);

  @override
  State<UserCoins> createState() => _UserCoinsState();
}

class _UserCoinsState extends State<UserCoins> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8, right: 16, left: 16),
          constraints: const BoxConstraints(minWidth: 50, minHeight: 50),
          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(500)), color: Colors.white),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Image(
                image: AssetImage("assets/images/zcoin.png"),
                height: 50,
              ),
              Text("200000", style: TextStyle(fontSize: 27))
            ],
          )),
    );
  }
}
