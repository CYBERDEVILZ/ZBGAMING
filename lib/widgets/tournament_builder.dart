import 'package:flutter/material.dart';

class TournamentBuilder extends StatelessWidget {
  const TournamentBuilder({Key? key, required this.special, required this.name}) : super(key: key);
  final bool special;
  final String name;

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Material(
      child: Container(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            // blue if special else grey
            color: special ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 150,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                      alignment: Alignment.topCenter,
                      height: 150,
                      width: MediaQuery.of(context).size.width - 30,
                      color: Colors.amber, // give nice color bruh
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            Text(
                              name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              textScaleFactor: 1.3,
                            ),
                            const Expanded(
                                child: Placeholder()), // info about tournament like lvl required, team or solo, etc
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("28, December, 2022"),
                                Row(children: const [
                                  Icon(Icons.people_alt),
                                  Text(" 23/"), // number of teams registered
                                  Text(
                                    "50", // total teams allowed
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
