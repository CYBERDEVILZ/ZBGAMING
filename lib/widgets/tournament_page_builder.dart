import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zbgaming/widgets/custom_divider.dart';
import 'package:zbgaming/widgets/tournament_builder.dart';

class TournamentPageBuilder extends StatefulWidget {
  const TournamentPageBuilder({Key? key, required this.matchname, required this.image, required this.databasename})
      : super(key: key);

  final String matchname;
  final String image;
  final String databasename;

  @override
  State<TournamentPageBuilder> createState() => _TournamentPageBuilderState();
}

class _TournamentPageBuilderState extends State<TournamentPageBuilder> {
  late Stream<QuerySnapshot> tournamentDetails;

  @override
  void initState() {
    super.initState();

    // stream for tournament details ordered by date
    tournamentDetails = FirebaseFirestore.instance.collection(widget.databasename).orderBy("date").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[200],
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              pinned: true, // pins the appbar at start of scroll
              elevation: 0,
              expandedHeight: 200, // height of expanded app bar
              title: Text(
                widget.matchname,
              ),
              centerTitle: true,
              // space for image in appbar
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  widget.image, // add a different image
                  fit: BoxFit.cover,
                ),
              )),

          // divider
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
                            date: e["date"].toDate()))
                        .toList()));
              })
        ],
      ),
    );
  }
}
