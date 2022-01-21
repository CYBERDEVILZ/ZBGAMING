import 'package:flutter/material.dart';

class NotSignedIn extends StatefulWidget {
  const NotSignedIn({Key? key}) : super(key: key);

  @override
  State<NotSignedIn> createState() => _NotSignedInState();
}

class _NotSignedInState extends State<NotSignedIn> {
  bool interval = false;

  void toggler() async {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 250));
      interval = !interval;
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    toggler();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
        interval
            ? const Icon(Icons.accessibility_new_sharp, color: Colors.blue, size: 40)
            : const Icon(Icons.accessibility_outlined, color: Colors.blue, size: 40),
        const SizedBox(height: 10),
        const Text("Who are you? Sign in first!")
      ]),
    );
  }
}
