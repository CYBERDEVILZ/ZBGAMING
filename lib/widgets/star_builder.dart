import 'package:flutter/material.dart';

class StarBuilder extends StatelessWidget {
  const StarBuilder(
      {Key? key, required this.star, required this.starColor, required this.size, required this.rowAlignment})
      : super(key: key);

  final num star;
  final Color starColor;
  final double size;
  final MainAxisAlignment rowAlignment;

  @override
  Widget build(BuildContext context) {
    int fullStars = star.floor();
    num halfStars = star.toString()[2] == "0" ? 0 : 1;
    List<Widget> stars = [];
    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(
        Icons.star,
        color: starColor,
        size: size,
      ));
    }
    for (int i = 0; i < halfStars; i++) {
      stars.add(Icon(
        Icons.star_half,
        color: starColor,
        size: size,
      ));
    }

    return stars.isEmpty
        ? Row(mainAxisAlignment: rowAlignment, children: [Text("No Rating", style: TextStyle(color: starColor))])
        : Row(mainAxisAlignment: rowAlignment, children: [...stars]);
  }
}
