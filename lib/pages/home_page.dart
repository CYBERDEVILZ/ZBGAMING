import 'package:flutter/material.dart';
import 'package:zbgaming/widgets/drawer.dart';
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
          drawer: const MyDrawer(),
          bottomNavigationBar: BottomNavigationBar(
              items: const [
                // games
                BottomNavigationBarItem(
                    icon: Icon(Icons.gamepad), label: "Games"),

                // favorite organizations
                BottomNavigationBarItem(
                    icon: Icon(Icons.star), label: "Favorites")
              ],
              currentIndex: index,
              onTap: (value) {
                index = value;
                setState(() {});
              }),
          floatingActionButton: FloatingActionButton(
            onPressed: () {}, // shows registered matches
            child: const Icon(Icons.flag),
            elevation: 0,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ));
  }
}
