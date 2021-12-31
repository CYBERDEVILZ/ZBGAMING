import 'package:flutter/material.dart';
import 'package:zbgaming/widgets/organizer.dart';

class ContestDetails extends StatelessWidget {
  const ContestDetails(
      {Key? key,
      required this.special,
      required this.name,
      required this.team,
      required this.tournament,
      required this.skill,
      required this.bounty,
      required this.paid,
      required this.regTeams,
      required this.totalTeams})
      : super(key: key);
  final bool special;
  final String name;
  final bool team;
  final bool tournament;
  final bool skill;
  final bool bounty;
  final bool paid;
  final int regTeams;
  final int totalTeams;

  @override
  Widget build(BuildContext context) {
    Widget contestDetails =
        Container(padding: const EdgeInsets.all(10), child: const Text("contest details")); // contest details container

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contest Details"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Scrollbar(
        thickness: 10,
        isAlwaysShown: true,
        interactive: true,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "assets/images/valo.jpg", // change the image to contest banner
                fit: BoxFit.cover,
              ),
            ),

            // contest name
            Container(
              padding: const EdgeInsets.all(5),
              alignment: Alignment.center,
              child: Text(
                name,
                textAlign: TextAlign.start,
                textScaleFactor: 2,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            // scroll view with tabs
            Container(
              margin: const EdgeInsets.all(5),
              color: Colors.grey[200],
              child: Column(
                children: [
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        const TabBar(
                          tabs: [
                            Tab(
                              child: Text("Contest Details", style: TextStyle(color: Colors.black)),
                            ),
                            Tab(
                              child: Text("About Organizer", style: TextStyle(color: Colors.black)),
                            )
                          ],
                        ),
                        SizedBox(
                            height: 500,
                            child: TabBarView(children: [
                              SingleChildScrollView(child: contestDetails), // contest detail
                              const SingleChildScrollView(
                                  child: SizedBox(
                                      child: OrganizerDetails(
                                imageurl: "imageurl",
                                matches: 32,
                                name: "Zbunker Tournaments",
                                prizes: 320000,
                                rating: 4.5,
                              ))) // organizer detail
                            ]))
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 75,
              child: Placeholder(),
            ), // register button and number of teams
          ],
        ),
      ),
    );
  }
}
