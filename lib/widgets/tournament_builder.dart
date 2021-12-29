import 'package:flutter/material.dart';

class TournamentBuilder extends StatelessWidget {
  const TournamentBuilder(
      {Key? key,
      required this.special,
      required this.name,
      required this.team,
      required this.tournament,
      required this.skill,
      required this.bounty,
      required this.paid})
      : super(key: key);
  final bool special;
  final String name;
  final bool team;
  final bool tournament;
  final bool skill;
  final bool bounty;
  final bool paid;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[200], // canvas color
      child: Container(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          decoration: BoxDecoration(
            image: special
                ? const DecorationImage(image: AssetImage("assets/images/warningstripe.jpg"), fit: BoxFit.cover)
                : null,
            color: special ? Colors.transparent : Colors.grey, // special then bg image else grey color
            borderRadius: BorderRadius.circular(10),
          ),
          height: 170,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                      height: 170,
                      width: MediaQuery.of(context).size.width - 20,
                      color: Colors.white, // card bg color
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 5, top: 5, bottom: 5),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    name,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    textScaleFactor: 1.5,
                                  ),
                                ),
                                paid
                                    ? const Icon(
                                        Icons.paid_outlined,
                                        color: Colors.red,
                                      )
                                    : const Text("")
                              ],
                            ),
                            Expanded(
                                child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                                    child: Row(
                                      children: team
                                          ? [
                                              const Icon(
                                                Icons.people_alt,
                                                size: 20,
                                                color: Colors.purple,
                                              ),
                                              const SizedBox(width: 5),
                                              const Text("Team based",
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple))
                                            ]
                                          : const [
                                              Icon(Icons.person, size: 20, color: Colors.purple),
                                              SizedBox(width: 5),
                                              Text("Solo based",
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple))
                                            ],
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Row(
                                        children: tournament
                                            ? [
                                                Icon(
                                                  Icons.account_tree_sharp,
                                                  size: 20,
                                                  color: Colors.blue[800],
                                                ),
                                                const SizedBox(width: 5),
                                                Text("Tournament",
                                                    style:
                                                        TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800]))
                                              ]
                                            : [
                                                Icon(Icons.play_arrow, size: 20, color: Colors.blue[800]),
                                                const SizedBox(width: 5),
                                                Text("Single Match",
                                                    style:
                                                        TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800]))
                                              ],
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Row(
                                        children: skill
                                            ? const [
                                                Icon(
                                                  Icons.verified_user,
                                                  size: 20,
                                                  color: Colors.teal,
                                                ),
                                                SizedBox(width: 5),
                                                Text("Min LVL Required",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.teal,
                                                    ))
                                              ]
                                            : const [
                                                Icon(
                                                  Icons.verified_user,
                                                  size: 20,
                                                  color: Colors.teal,
                                                ),
                                                SizedBox(width: 5),
                                                Text("No LVL Required",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.teal,
                                                    ))
                                              ],
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Row(
                                        children: bounty
                                            ? const [
                                                Icon(
                                                  Icons.attach_money_outlined,
                                                  size: 20,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(width: 5),
                                                Text("Rewards available",
                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red))
                                              ]
                                            : const [
                                                Icon(Icons.money_off, size: 20, color: Colors.red),
                                                SizedBox(width: 5),
                                                Text("No Rewards",
                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red))
                                              ],
                                      )),
                                ],
                              ),
                            )),
                            const Divider(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "28, December, 2022",
                                  textScaleFactor: 1.2,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Row(children: const [
                                  Icon(Icons.people_alt),
                                  Text(
                                    " 23/",
                                    textScaleFactor: 1.2,
                                  ), // number of teams registered
                                  Text(
                                    "50",
                                    textScaleFactor: 1.2, // total teams allowed
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ]),
                              ],
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ],
          )),
    );
  }
}
