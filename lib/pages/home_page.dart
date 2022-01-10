import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zbgaming/model/usermodel.dart';
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
    FirebaseAuth.instance.authStateChanges().listen((User? event) async {
      if (event?.uid == null) {
        isLogged = false;
        if (mounted) setState(() {});
        if (mounted) context.read<UserModel>().signout();
      } else if (event?.uid != null) {
        var data =
            await FirebaseFirestore.instance.collection("userinfo").doc(FirebaseAuth.instance.currentUser!.uid).get();
        context.read<UserModel>().setuid(FirebaseAuth.instance.currentUser!.uid);
        context.read<UserModel>().setusername(data["username"]);
        context.read<UserModel>().setemail(data["email"]);
        context.read<UserModel>().setimageurl(data["imageurl"]);
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
          drawer: isLogged ? const AfterLoginDrawer() : const BeforeLoginDrawer(),
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
