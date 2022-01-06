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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "How To Join",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.4,
        ),

        const SizedBox(height: 10),

        // rules hardcoded for all games
        ...rules
            .map((e) => BulletText(
                  text: e!,
                ))
            .toList()
      ],
    );
  }
}
