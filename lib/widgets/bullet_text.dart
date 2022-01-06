import 'package:flutter/material.dart';

class BulletText extends StatelessWidget {
  const BulletText({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 20),
        Column(
          children: const [
            SizedBox(height: 5),
            Icon(Icons.circle, size: 10),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(text)],
          ),
        )
      ],
    );
  }
}
