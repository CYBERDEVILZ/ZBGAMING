import 'package:flutter/material.dart';

class StarBuilder extends StatelessWidget {
  const StarBuilder({Key? key, required this.star, required this.starColor}) : super(key: key);

  final num star;
  final Color starColor;

  @override
  Widget build(BuildContext context) {
    int fullStars = star.floor();
    num halfStars = star.toString()[2] == "0" ? 0 : 1;
    List<Widget> stars = [];
    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: starColor));
    }
    for (int i = 0; i < halfStars; i++) {
      stars.add(Icon(Icons.star_half, color: starColor));
    }

    return stars.isEmpty
        ? Row(mainAxisAlignment: MainAxisAlignment.center, children: const [Text("No Rating", textScaleFactor: 1.5)])
        : Row(mainAxisAlignment: MainAxisAlignment.center, children: [...stars]);
  }
}
