import 'package:flutter/material.dart';

class ShowUserAccount extends StatelessWidget {
  const ShowUserAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Image.asset(
            "assets/images/zbunker-app-banner-upsidedown-short.png",
            fit: BoxFit.fitWidth,
          ),
          const CircleAvatar(
            maxRadius: 70,
          )
        ],
      )),
    );
  }
}
