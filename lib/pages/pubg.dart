import 'package:flutter/material.dart';

class PubgTournaments extends StatelessWidget {
  const PubgTournaments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Upcoming Tournaments"),
        ),
      ),
    );
  }
}
