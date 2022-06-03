import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zbgaming/pages/create_match.dart';
import 'package:zbgaming/pages/csgo.dart';
import 'package:zbgaming/pages/freefire.dart';
import 'package:zbgaming/pages/login.dart';
import 'package:zbgaming/pages/organizer.dart';
import 'package:zbgaming/pages/organizer_login.dart';
import 'package:zbgaming/pages/organizer_signup.dart';
import 'package:zbgaming/pages/pubg.dart';
import 'package:zbgaming/pages/show_user_account.dart';
import 'package:zbgaming/pages/signup.dart';
import 'package:zbgaming/pages/valorant.dart';
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
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
