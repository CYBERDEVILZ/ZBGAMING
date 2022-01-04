import 'package:flutter/material.dart';

class StarBuilder extends StatelessWidget {
  const StarBuilder({Key? key, required this.star}) : super(key: key);

  final num star;

  @override
  Widget build(BuildContext context) {
    int fullStars = star.floor();
    num halfStars = star.toString()[2] == "0" ? 0 : 1;
    List<Widget> stars = [];
    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star));
    }
    for (int i = 0; i < halfStars; i++) {
      stars.add(const Icon(Icons.star_half));
    }

    return stars.isEmpty
        ? Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Text("No Rating", textScaleFactor: 1.5)])
        : Row(mainAxisAlignment: MainAxisAlignment.center, children: [...stars]);
  }
}
