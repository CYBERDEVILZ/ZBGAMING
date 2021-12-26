import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.red,
        elevation: 0,
        child: Column(
          children: [
            DrawerHeader(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [],
                )),
          ],
        ));
  }
}
