import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:zbgaming/model/usermodel.dart';
import 'package:zbgaming/pages/contest_details.dart';
import 'package:zbgaming/pages/history.dart';
import 'package:zbgaming/pages/leaderboards.dart';
import 'package:zbgaming/pages/registered_matches.dart';
import 'package:zbgaming/pages/user_account.dart';
import 'package:zbgaming/services/local_notification_service.dart';
import 'package:zbgaming/widgets/drawer.dart';
import 'package:zbgaming/widgets/exit_pop_up.dart';
import 'package:zbgaming/widgets/favorite_organizer.dart';
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
  Map<int, Widget> showBody = {
    0: const HomePageList(),
    1: const FavoriteOrganizers(),
    2: RegisteredMatches(),
    3: const History(),
    4: const UserAccount()
  }; // mapping for bottom nav bar

  bool isLogged = false;
  int? coin;

  void registerNotification() async {
    // initialize firebase app
    Firebase.initializeApp();

    // initialize firebase messaging
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        if (message.data["route"] != null) {
          Navigator.of(context).pushNamed(message.data["route"]);
        }
      }
    });

    // foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {}
      NotificationService.display(message);
    });

    // When the app is in the background and message is opened
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.data["route"] != null) {
        Navigator.of(context).pushNamed(message.data["route"]);
      } else if (message.data["routename"] == "contest-details" &&
          message.data["matchuid"] != null &&
          message.data["matchtype"] != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ContestDetails(uid: message.data["matchuid"], matchType: message.data["matchtype"])));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    registerNotification();

    // subscribe to userchanges
    FirebaseAuth.instance.authStateChanges().listen((User? event) async {
      if (event?.uid == null) {
        isLogged = false;
        index = 0;
        if (mounted) setState(() {});
        if (mounted) context.read<UserModel>().signout();
      } else if (event?.uid != null) {
        try {
          var data =
              await FirebaseFirestore.instance.collection("userinfo").doc(FirebaseAuth.instance.currentUser!.uid).get();
          context.read<UserModel>().setuid(FirebaseAuth.instance.currentUser!.uid);
          context.read<UserModel>().setusername(data["username"]);
          context.read<UserModel>().setemail(data["email"]);
          context.read<UserModel>().setimageurl(data["imageurl"]);
          coin = data["zcoins"];
          isLogged = true;

          if (mounted) setState(() {});
        } catch (e) {
          isLogged = false;
          if (mounted) setState(() {});
        }
      }
    });
  }

  // --------------- Return is Here --------------- //
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: WillPopScope(
          onWillPop: () => showExitPopup(context),
          child: Scaffold(
            appBar: index == 0
                ? AppBar(
                    title: const Text("Games"),
                    elevation: 0,
                    centerTitle: true,
                    actions: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: ((context) => const Leaderboard())));
                          },
                          icon: const Icon(Icons.leaderboard))
                    ],
                  )
                : null,
            body: showBody[index], // contains list of games
            drawer: isLogged
                ? AfterLoginDrawer(
                    coin: coin,
                  )
                : const BeforeLoginDrawer(),
            bottomNavigationBar: !isLogged
                ? null
                : BottomNavigationBar(
                    type: BottomNavigationBarType.shifting,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    items: const [
                      // games
                      BottomNavigationBarItem(
                          icon: Icon(Icons.gamepad),
                          label: "Games",
                          activeIcon: Icon(
                            Icons.gamepad,
                            size: 30,
                            color: Colors.blue,
                          ),
                          backgroundColor: Colors.black),

                      // favorite organizations
                      BottomNavigationBarItem(
                          icon: Icon(Icons.star),
                          label: "Favorites",
                          activeIcon: Icon(
                            Icons.star,
                            size: 30,
                            color: Colors.blue,
                          )),

                      // registered matches
                      BottomNavigationBarItem(
                          icon: Icon(Icons.flag),
                          label: "Registered",
                          activeIcon: Icon(
                            Icons.flag,
                            size: 30,
                            color: Colors.blue,
                          )),

                      // hisotry
                      BottomNavigationBarItem(
                          icon: Icon(Icons.history),
                          label: "History",
                          activeIcon: Icon(
                            Icons.history,
                            size: 30,
                            color: Colors.blue,
                          )),

                      // account
                      BottomNavigationBarItem(
                          icon: Icon(Icons.account_circle),
                          label: "Account",
                          activeIcon: Icon(
                            Icons.account_circle,
                            size: 30,
                            color: Colors.blue,
                          )),
                    ],
                    currentIndex: index,
                    onTap: (value) {
                      index = value;
                      setState(() {});
                    }),
          ),
        ));
  }
}
