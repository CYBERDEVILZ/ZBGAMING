import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zbgaming/pages/create_match.dart';
import 'package:zbgaming/pages/csgo.dart';
import 'package:zbgaming/pages/freefire.dart';
import 'package:zbgaming/pages/login.dart';
import 'package:zbgaming/pages/match_start.dart';
import 'package:zbgaming/pages/organizer.dart';
import 'package:zbgaming/pages/organizer_signup.dart';
import 'package:zbgaming/pages/pubg.dart';
import 'package:zbgaming/pages/registered_matches.dart';
import 'package:zbgaming/pages/signup.dart';
import 'package:zbgaming/pages/user_account.dart';
import 'package:zbgaming/pages/valorant.dart';
import 'package:zbgaming/services/local_notification_service.dart';
import 'package:zbgaming/utils/routes.dart';

import 'package:firebase_core/firebase_core.dart';

import 'model/organizermodel.dart';
import 'model/usermodel.dart';
import 'pages/home_page.dart';

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

// when you receive message in background and app is terminated
Future<void> backgroundMessage(RemoteMessage message) async {
  print("received background message!");
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    NotificationService.initialize(context);
    FirebaseMessaging.onBackgroundMessage(backgroundMessage);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
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
        AppRoutes.registeredMatches: (context) => RegisteredMatches()
      },
    );
  }
}
