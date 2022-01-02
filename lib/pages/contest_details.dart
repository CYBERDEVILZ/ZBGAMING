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
    // contest details widget
    Widget contestDetails = Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(name, textAlign: TextAlign.start, textScaleFactor: 2),
            const SizedBox(height: 5),
            Row(children: [
              // date of tournament
              Text(
                "28 December, 2022",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
              ),

              const SizedBox(width: 20),

              // teams registered
              Row(
                children: [
                  Icon(Icons.people_alt, size: 20, color: Colors.black.withOpacity(0.5)),
                  Text(
                    " $regTeams/",
                    textScaleFactor: 1.1,
                    style: TextStyle(color: Colors.black.withOpacity(0.5)),
                  ),
                  Text(
                    "$totalTeams",
                    textScaleFactor: 1.1,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
                  )
                ],
              )
            ]),

            const SizedBox(height: 20),

            // match format
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SizedBox(
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: team
                              ? [
                                  const Icon(Icons.people_alt, size: 25, color: Colors.purple),
                                  const SizedBox(width: 5),
                                  const Text("Team based\n",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.purple))
                                ]
                              : const [
                                  Icon(Icons.person, size: 25, color: Colors.purple),
                                  SizedBox(width: 5),
                                  Text("Solo based\n",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.purple))
                                ],
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Column(
                          children: tournament
                              ? [
                                  Icon(Icons.account_tree_sharp, size: 25, color: Colors.blue[800]),
                                  const SizedBox(width: 5),
                                  Text("Tournament\n",
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue[800]))
                                ]
                              : [
                                  Icon(Icons.play_arrow, size: 25, color: Colors.blue[800]),
                                  const SizedBox(width: 5),
                                  Text("Single Match\n",
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue[800]))
                                ],
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: skill
                              ? const [
                                  Icon(Icons.flash_on, size: 25, color: Colors.teal),
                                  SizedBox(width: 5),
                                  Text("Min LVL Required",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.teal))
                                ]
                              : const [
                                  Icon(Icons.flash_off, size: 25, color: Colors.teal),
                                  SizedBox(width: 5),
                                  Text("No LVL Required",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.teal))
                                ],
                        ),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    Align(
                      child: Column(
                        children: bounty
                            ? const [
                                Icon(Icons.attach_money_outlined, size: 25, color: Colors.red),
                                SizedBox(width: 5),
                                Text("Rewards available",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red))
                              ]
                            : const [
                                Icon(Icons.money_off, size: 25, color: Colors.red),
                                SizedBox(width: 5),
                                Text("No Rewards",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red))
                              ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));

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
                                  // organizer details
                                  child: SizedBox(
                                      child: OrganizerDetails(
                                imageurl: "imageurl",
                                matches: 32,
                                name: "Zbunker Tournaments",
                                prizes: 320000,
                                rating: 4.5,
                              )))
                            ]))
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black, blurRadius: 7, blurStyle: BlurStyle.outer)]),
              height: 75,
              child: const Placeholder(),
            ), // register button and number of teams
          ],
        ),
      ),
    );
  }
}
