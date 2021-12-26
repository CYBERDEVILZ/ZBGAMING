import 'package:flutter/material.dart';

class ValorantTournaments extends StatelessWidget {
  const ValorantTournaments({Key? key}) : super(key: key);

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
