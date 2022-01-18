import 'package:flutter/material.dart';
import 'package:zbgaming/widgets/tournament_page_builder.dart';

class CsgoTournaments extends StatefulWidget {
  const CsgoTournaments({Key? key}) : super(key: key);

  @override
  State<CsgoTournaments> createState() => _CsgoTournamentsState();
}

class _CsgoTournamentsState extends State<CsgoTournaments> {
  @override
  Widget build(BuildContext context) {
    return const TournamentPageBuilder(
        image: "assets/images/csgo.jpg", matchname: "Counter Strike: Global Offensive", databasename: "csgo");
  }
}
