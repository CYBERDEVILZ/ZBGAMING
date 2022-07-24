import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zbgaming/widgets/custom_divider.dart';
import 'package:zbgaming/widgets/tournament_builder.dart';

class PubgTournaments extends StatefulWidget {
  const PubgTournaments({Key? key}) : super(key: key);

  @override
  State<PubgTournaments> createState() => _PubgTournamentsState();
}

class _PubgTournamentsState extends State<PubgTournaments> {
  bool? feequery;
  int? paidquery;
  int? skillquery;
  int? startedquery;
  bool? specialquery;

  bool freeTag = false;
  bool paidTag = false;
  bool rookieTag = false;
  bool veteranTag = false;
  bool eliteTag = false;
  bool registrationsOpenTag = false;
  bool finishedTag = false;
  bool ongoingTag = false;
  bool specialTag = false;

  late Stream<QuerySnapshot> tournamentDetails;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // tag manipulation for FILTERING
    if (freeTag == false && paidTag == false) {
      feequery = null;
    }
    if (freeTag == true && paidTag == false) {
      feequery = false;
    }
    if (freeTag == false && paidTag == true) {
      feequery = true;
    }
    if (rookieTag == false && veteranTag == false && eliteTag == false) {
      skillquery = null;
    }
    if (rookieTag == true && veteranTag == false && eliteTag == false) {
      skillquery = 0;
    }
    if (rookieTag == false && veteranTag == true && eliteTag == false) {
      skillquery = 1;
    }
    if (rookieTag == false && veteranTag == false && eliteTag == true) {
      skillquery = 2;
    }
    if (registrationsOpenTag == false && ongoingTag == false && finishedTag == false) {
      startedquery = null;
    }
    if (registrationsOpenTag == true && ongoingTag == false && finishedTag == false) {
      startedquery = 0;
    }
    if (registrationsOpenTag == false && ongoingTag == true && finishedTag == false) {
      startedquery = 1;
    }
    if (registrationsOpenTag == false && ongoingTag == false && finishedTag == true) {
      startedquery = 2;
    }
    specialTag ? specialquery = true : specialquery = null;
    tournamentDetails = FirebaseFirestore.instance
        .collection("pubg")
        .where("paid", isEqualTo: feequery)
        .where("skill", isEqualTo: skillquery)
        .where("started", isEqualTo: startedquery)
        .where("special", isEqualTo: specialquery)
        .orderBy("date")
        .snapshots();

    return Material(
      color: Colors.grey[200],
      child: CustomScrollView(
        slivers: <Widget>[
          const SlivAppBar(),
          const SliverToBoxAdapter(child: CustomDivider(indent: 0, height: 5, radius: false)),
          SliverToBoxAdapter(
            child: Container(
                padding: const EdgeInsets.all(8),
                child: Wrap(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            child: SearchTags(toggle: freeTag, name: "Free"),
                            onTap: () {
                              if (freeTag == false) {
                                paidTag = false;
                              }
                              freeTag = !freeTag;
                              setState(() {});
                            }),
                        GestureDetector(
                            child: SearchTags(toggle: paidTag, name: "Paid"),
                            onTap: () {
                              if (paidTag == false) {
                                freeTag = false;
                              }
                              paidTag = !paidTag;
                              setState(() {});
                            }),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                            child: SearchTags(toggle: rookieTag, name: "Rookie"),
                            onTap: () {
                              if (rookieTag == false) {
                                veteranTag = false;
                                eliteTag = false;
                              }
                              rookieTag = !rookieTag;
                              setState(() {});
                            }),
                        GestureDetector(
                            child: SearchTags(toggle: veteranTag, name: "Veteran"),
                            onTap: () {
                              if (veteranTag == false) {
                                rookieTag = false;
                                eliteTag = false;
                              }
                              veteranTag = !veteranTag;
                              setState(() {});
                            }),
                        GestureDetector(
                            child: SearchTags(toggle: eliteTag, name: "Elite"),
                            onTap: () {
                              if (eliteTag == false) {
                                rookieTag = false;
                                veteranTag = false;
                              }
                              eliteTag = !eliteTag;
                              setState(() {});
                            }),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                            child: SearchTags(toggle: registrationsOpenTag, name: "Registrations Open"),
                            onTap: () {
                              if (registrationsOpenTag == false) {
                                ongoingTag = false;
                                finishedTag = false;
                              }
                              registrationsOpenTag = !registrationsOpenTag;
                              setState(() {});
                            }),
                        GestureDetector(
                            child: SearchTags(toggle: ongoingTag, name: "Ongoing"),
                            onTap: () {
                              if (ongoingTag == false) {
                                registrationsOpenTag = false;
                                finishedTag = false;
                              }
                              ongoingTag = !ongoingTag;
                              setState(() {});
                            }),
                        GestureDetector(
                            child: SearchTags(toggle: finishedTag, name: "Finished"),
                            onTap: () {
                              if (finishedTag == false) {
                                registrationsOpenTag = false;
                                ongoingTag = false;
                              }
                              finishedTag = !finishedTag;
                              setState(() {});
                            }),
                      ],
                    ),
                    GestureDetector(
                        child: SearchTags(toggle: specialTag, name: "Special"),
                        onTap: () {
                          specialTag = !specialTag;
                          setState(() {});
                        }),
                  ],
                )),
          ),

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
                              matchType: "pubg",
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
        "PUBG: New State",
      ),
      centerTitle: true,
      // space for image in appbar
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          "assets/images/pubg.jpg", // add a different image
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class SearchTags extends StatefulWidget {
  const SearchTags({Key? key, required this.toggle, required this.name}) : super(key: key);
  final bool toggle;
  final String name;

  @override
  State<SearchTags> createState() => _SearchTagsState();
}

class _SearchTagsState extends State<SearchTags> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        height: 30,
        decoration: BoxDecoration(
            color: widget.toggle ? Colors.blue : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(100))),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.name,
              style: TextStyle(color: widget.toggle ? Colors.white : Colors.blue),
            ),
            widget.toggle ? const SizedBox(width: 3) : Container(),
            widget.toggle ? const Icon(Icons.cancel, color: Colors.white) : Container()
          ],
        ),
      ),
    );
  }
}
