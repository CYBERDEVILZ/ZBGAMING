import 'package:flutter/material.dart';

class Organizer extends StatelessWidget {
  const Organizer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
