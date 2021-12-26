import 'package:flutter/material.dart';
import 'package:zbgaming/pages/csgo.dart';
import 'package:zbgaming/pages/freefire.dart';
import 'package:zbgaming/pages/pubg.dart';
import 'package:zbgaming/pages/valorant.dart';
import 'package:zbgaming/utils/routes.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      },
    );
  }
}
