import 'package:flutter/material.dart';

class ValorantTournaments extends StatelessWidget {
  const ValorantTournaments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        const SlivAppBar(),
        SliverList(
            delegate: SliverChildListDelegate(<Widget>[
          Container(color: Colors.green, height: 150),
          Container(color: Colors.yellow, height: 150),
          Container(color: Colors.red, height: 150),
          Container(color: Colors.purple, height: 150),
          Container(color: Colors.green, height: 150),
          Container(color: Colors.yellow, height: 150),
          Container(color: Colors.red, height: 150),
          Container(color: Colors.purple, height: 150),
        ]))
      ],
    );
  }
}

class SlivAppBar extends StatelessWidget {
  const SlivAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      expandedHeight: 200, // height of expanded app bar
      title: const Text(
        "Valorant",
      ),
      centerTitle: true,
      // space for image in appbar
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          "assets/images/valo.jpg", // add a different image
          fit: BoxFit.cover,
        ),
      ),
      floating: true, // true, appbar appears when you scroll up
    );
  }
}
