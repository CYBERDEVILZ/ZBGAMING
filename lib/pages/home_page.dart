import 'package:flutter/material.dart';
import 'package:zbgaming/widgets/home_page_list.dart';

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
          appBar: AppBar(
              title: const Text("Games"), elevation: 0, centerTitle: true),
          body: const HomePageList(),
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
            child: const Icon(Icons.play_arrow),
            elevation: 0,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ));
  }
}
