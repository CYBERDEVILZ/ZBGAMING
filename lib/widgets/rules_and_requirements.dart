import 'package:flutter/material.dart';

import 'bullet_text.dart';

class Rules extends StatelessWidget {
  const Rules({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String?> rules = [
      "Log into your account and this is an example of multiline rule to test the resilience of my own bullet text widget heh",
      "Open Game",
      "Enter Code",
      "Begin the Match boii"
    ];

    List<String?> contestDetails = [
      "Tournament is team based",
      "Winner will get all",
      "If there is any discrepancy, ZBunker will look into it dont worry"
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "How To Join",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.3,
        ),

        const SizedBox(height: 10),

        // rules hardcoded for all games
        ...rules
            .map((e) => BulletText(
                  text: e!,
                ))
            .toList(),

        const SizedBox(height: 20),

        const Text(
          "Contest Details",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.3,
        ),

        const SizedBox(height: 10),

        // contest details
        ...contestDetails
            .map((e) => BulletText(
                  text: e!,
                ))
            .toList(),

        const SizedBox(height: 20),

        const Text(
          "Contact Organizer",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.3,
        ),

        const SizedBox(height: 10),

        // contact details
        const Text("Click on the motherfucking organizer card above to contact idiot")
      ],
    );
  }
}

// Requirements
class Requirements extends StatelessWidget {
  const Requirements({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 10),
      SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(children: [
              Column(children: [Expanded(child: Container(color: Colors.lightBlue, width: 5, child: const Text('')))]),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Login Required For Registration",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ]),
          )),
      SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(children: [
              Column(children: [Expanded(child: Container(color: Colors.cyan, width: 5, child: const Text('')))]),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "In Game Unique Id Required",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ]),
          )),
      SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(children: [
              Column(children: [Expanded(child: Container(color: Colors.cyan[100], width: 5, child: const Text('')))]),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "User Must Be Verified",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ]),
          )),
    ]);
  }
}
