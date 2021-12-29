import 'package:flutter/material.dart';
import 'package:zbgaming/widgets/tournament_builder.dart';

class CsgoTournaments extends StatelessWidget {
  const CsgoTournaments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        const SlivAppBar(),
        SliverList(
            delegate: SliverChildListDelegate(<Widget>[
          // add filters and other necessary things for easier access
          Container(
            height: 40,
            color: Colors.green,
            child: const Placeholder(),
          ),
          const TournamentBuilder(
            special: true,
            name: "Zbunker Catastrophe",
            team: true,
            tournament: true,
            skill: false,
            bounty: true,
            paid: true,
          ),
          const TournamentBuilder(
            special: false,
            name: "Pratheek's Pro League",
            team: false,
            tournament: false,
            skill: true,
            bounty: false,
            paid: false,
          ),
          const TournamentBuilder(
            special: true,
            name: "Zbunker Catastrophe",
            team: true,
            tournament: true,
            skill: false,
            bounty: true,
            paid: true,
          ),
          const TournamentBuilder(
            special: true,
            name: "Zbunker Catastrophe",
            team: true,
            tournament: true,
            skill: false,
            bounty: true,
            paid: true,
          ),
          const TournamentBuilder(
            special: true,
            name: "Zbunker Catastrophe",
            team: true,
            tournament: true,
            skill: false,
            bounty: true,
            paid: true,
          ),
          const TournamentBuilder(
            special: true,
            name: "Zbunker Catastrophe League ALL STAR HOI",
            team: true,
            tournament: true,
            skill: false,
            bounty: true,
            paid: true,
          ),
          const TournamentBuilder(
            special: true,
            name: "Zbunker Catastrophe",
            team: true,
            tournament: true,
            skill: false,
            bounty: true,
            paid: true,
          ),
        ]))
      ],
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
        "Counter Strike: Global Offensive",
      ),
      centerTitle: true,
      // space for image in appbar
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          "assets/images/csgo.jpg", // add a different image
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
