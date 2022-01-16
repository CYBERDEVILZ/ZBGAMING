import 'package:flutter/material.dart';
import 'package:zbgaming/widgets/custom_divider.dart';
import 'package:zbgaming/widgets/tournament_builder.dart';

class PubgTournaments extends StatefulWidget {
  const PubgTournaments({Key? key}) : super(key: key);

  @override
  State<PubgTournaments> createState() => _PubgTournamentsState();
}

class _PubgTournamentsState extends State<PubgTournaments> {
  bool isLoading = true;

  // fetch value from database and pass this to tournamentBuilder
  List tournamentDetails = [];

  @override
  void initState() {
    super.initState();

    // define a function to fetch data automatically from database
    Future<void> functionToInitialize() async {
      await Future.delayed(const Duration(seconds: 1));
      isLoading = false;
      setState(() {});
    }

    functionToInitialize();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: CustomScrollView(
        slivers: isLoading
            ? <Widget>[
                const SlivAppBar(),
                SliverList(
                    delegate: SliverChildListDelegate(<Widget>[
                  Container(
                    child: const FittedBox(child: CircularProgressIndicator()),
                    color: Colors.white,
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(10),
                  )
                ]))
              ]
            : <Widget>[
                const SlivAppBar(),
                SliverList(
                    delegate: SliverChildListDelegate(<Widget>[
                  const CustomDivider(indent: 0, height: 5, radius: false),
                  TournamentBuilder(
                    date: DateTime.now(),
                    special: true,
                    name: "Zbunker Catastrophe",
                    team: true,
                    tournament: true,
                    skill: 0,
                    rewards: 4,
                    regTeams: 34,
                    totalTeams: 50,
                  ),
                  TournamentBuilder(
                    date: DateTime.now(),
                    special: false,
                    name: "Pratheek's Pro League",
                    team: true,
                    tournament: true,
                    skill: 1,
                    rewards: 3,
                    regTeams: 34,
                    totalTeams: 50,
                  ),
                ]))
              ],
      ),
    );
  }
}

class SlivAppBar extends StatelessWidget {
  const SlivAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true, // pins the appbar at start of scroll
      elevation: 0,
      expandedHeight: 200, // height of expanded app bar
      title: const Text(
        "PUBG New State",
      ),
      centerTitle: true,
      // space for image in appbar
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          "assets/images/pubg.png", // add a different image
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
