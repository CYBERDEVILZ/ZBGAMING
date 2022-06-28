import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zbgaming/pages/create_match.dart';
import 'package:zbgaming/pages/csgo.dart';
import 'package:zbgaming/pages/freefire.dart';
import 'package:zbgaming/pages/login.dart';
import 'package:zbgaming/pages/match_start.dart';
import 'package:zbgaming/pages/organizer.dart';
import 'package:zbgaming/pages/organizer_login.dart';
import 'package:zbgaming/pages/organizer_signup.dart';
import 'package:zbgaming/pages/pubg.dart';
import 'package:zbgaming/pages/show_user_account.dart';
import 'package:zbgaming/pages/signup.dart';
import 'package:zbgaming/pages/user_account.dart';
import 'package:zbgaming/pages/valorant.dart';
import 'package:zbgaming/utils/routes.dart';

import 'package:firebase_core/firebase_core.dart';

import 'model/organizermodel.dart';
import 'model/usermodel.dart';
import 'pages/home_page.dart';

// handling background notifications
Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserModel()),
    ChangeNotifierProvider(create: (_) => OrganizerModel()),
    ChangeNotifierProvider(create: (_) => DetailProvider()),
    ChangeNotifierProvider(create: (_) => StartMatchIndicatorNotifier()),
    ChangeNotifierProvider(create: (_) => ButtonLoader()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final FirebaseMessaging _messaging;

  void registerNotification() async {
    // initialize firebase app
    Firebase.initializeApp();

    // initialize firebase messaging
    _messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // iOS specific
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    // if permissions are granted
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("received a message bruh!");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    registerNotification();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      // home: const OrganizerLogin(),
      debugShowCheckedModeBanner: false,
      title: "ZB-Gaming",
      routes: {
        AppRoutes.csgo: (context) => const CsgoTournaments(),
        AppRoutes.freefire: (context) => const FreeFireTournaments(),
        AppRoutes.valorant: (context) => const ValorantTournaments(),
        AppRoutes.pubg: (context) => const PubgTournaments(),
        AppRoutes.organizer: (context) => const Organizer(),
        AppRoutes.login: (context) => const Login(),
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.signup: (context) => const SignUp(),
        AppRoutes.organizerSignUp: (context) => const OrganizerSignUp(),
      },
    );
  }
}
