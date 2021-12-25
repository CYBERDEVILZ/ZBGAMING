import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0; // index for bottom nav bar
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: AppBar(title: Text("Games"), elevation: 0, centerTitle: true),
          body: Container(),
          drawer: Container(),
          bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.ac_unit_outlined), label: "icon1"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.ac_unit_outlined), label: "icon2")
              ],
              currentIndex: index,
              onTap: (value) {
                index = value;
                setState(() {}); // updates the index
              }),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.play_arrow),
            elevation: 0,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ));
  }
}
