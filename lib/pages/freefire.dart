import 'package:flutter/material.dart';
import 'package:zbgaming/widgets/custom_divider.dart';
import 'package:zbgaming/widgets/tournament_builder.dart';

class FreeFireTournaments extends StatefulWidget {
  const FreeFireTournaments({Key? key}) : super(key: key);

  @override
  State<FreeFireTournaments> createState() => _FreeFireTournamentsState();
}

class _FreeFireTournamentsState extends State<FreeFireTournaments> {
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
                  const TournamentBuilder(
                    special: true,
                    name: "Zbunker Catastrophe",
                    team: true,
                    tournament: true,
                    skill: false,
                    bounty: true,
                    paid: true,
                    regTeams: 34,
                    totalTeams: 50,
                  ),
                  const TournamentBuilder(
                      special: false,
                      name: "Pratheek's Pro League",
                      team: false,
                      tournament: false,
                      skill: true,
                      bounty: false,
                      paid: false,
                      regTeams: 20,
                      totalTeams: 50),
                  const TournamentBuilder(
                      special: true,
                      name: "Zbunker Catastrophe",
                      team: true,
                      tournament: true,
                      skill: false,
                      bounty: true,
                      paid: true,
                      regTeams: 34,
                      totalTeams: 50),
                  const TournamentBuilder(
                      special: true,
                      name: "Zbunker Catastrophe",
                      team: true,
                      tournament: true,
                      skill: false,
                      bounty: true,
                      paid: true,
                      regTeams: 34,
                      totalTeams: 50),
                  const TournamentBuilder(
                      special: true,
                      name: "Zbunker Catastrophe",
                      team: true,
                      tournament: true,
                      skill: false,
                      bounty: true,
                      paid: true,
                      regTeams: 34,
                      totalTeams: 50),
                  const TournamentBuilder(
                      special: true,
                      name: "Zbunker Catastrophe League ALL STAR HOI",
                      team: true,
                      tournament: true,
                      skill: false,
                      bounty: true,
                      paid: true,
                      regTeams: 34,
                      totalTeams: 50),
                  const TournamentBuilder(
                      special: true,
                      name: "Zbunker Catastrophe",
                      team: true,
                      tournament: true,
                      skill: false,
                      bounty: true,
                      paid: true,
                      regTeams: 34,
                      totalTeams: 50),
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
        "Garena Free Fire",
      ),
      centerTitle: true,
      // space for image in appbar
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          "assets/images/freefire.png", // add a different image
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
