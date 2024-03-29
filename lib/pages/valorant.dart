import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zbgaming/widgets/custom_divider.dart';
import 'package:zbgaming/widgets/tournament_builder.dart';

class ValorantTournaments extends StatefulWidget {
  const ValorantTournaments({Key? key}) : super(key: key);

  @override
  State<ValorantTournaments> createState() => _ValorantTournamentsState();
}

class _ValorantTournamentsState extends State<ValorantTournaments> {
  // stream for tournament details ordered by date
  Stream<QuerySnapshot> tournamentDetails = FirebaseFirestore.instance.collection("valo").orderBy("date").snapshots();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[200],
      child: CustomScrollView(
        slivers: <Widget>[
          const SlivAppBar(),
          const SliverToBoxAdapter(child: CustomDivider(indent: 0, height: 5, radius: false)),

          // matches
          StreamBuilder(
              stream: tournamentDetails,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const SliverToBoxAdapter(child: Text("error occurred"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                      child: SizedBox(height: 30, child: FittedBox(child: CircularProgressIndicator())));
                }
                return SliverList(
                    delegate: SliverChildListDelegate(snapshot.data!.docs
                        .map((DocumentSnapshot e) => TournamentBuilder(
                              special: e["special"],
                              name: e["name"],
                              team: e["solo"],
                              tournament: e["match"],
                              skill: e["skill"],
                              rewards: e["fee"],
                              regTeams: e["reg"],
                              totalTeams: 100,
                              date: e["date"].toDate(),
                              uid: e.id,
                              ouid: e["uid"],
                              matchType: "valo",
                              started: e["started"],
                            ))
                        .toList()));
              })
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
        "Valorant",
      ),
      centerTitle: true,
      // space for image in appbar
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          "assets/images/valo.jpg", // add a different image
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
