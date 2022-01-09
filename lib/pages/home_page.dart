import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zbgaming/widgets/drawer.dart';
import 'package:zbgaming/widgets/home_page_list.dart';

// ignore: unused_import
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0; // index for bottom nav bar
  bool isLogged = false;

  @override
  void initState() {
    super.initState();

    // subscribe to userchanges
    FirebaseAuth.instance.authStateChanges().listen((User? event) {
      if (event?.uid == null) {
        isLogged = false;
        if (mounted) setState(() {});
      } else if (event?.uid != null) {
        isLogged = true;
        if (mounted) setState(() {});
      }
    });
  }

  // --------------- Return is Here --------------- //
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: AppBar(title: const Text("Games"), elevation: 0, centerTitle: true),
          body: const HomePageList(), // contains list of games
          drawer: isLogged ? const MyDrawer() : const MyLoginDrawer(),
          bottomNavigationBar: BottomNavigationBar(
              items: const [
                // games
                BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: "Games"),

                // favorite organizations
                BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favorites")
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
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ));
  }
}
