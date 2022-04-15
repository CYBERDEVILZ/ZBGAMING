import 'package:flutter/material.dart';
import 'package:zbgaming/utils/routes.dart';

class HomePageList extends StatelessWidget {
  const HomePageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // array containing multiple tiles
    final List<Widget> list = [
      Tile(
          disabled: true,
          img: "assets/images/csgo.jpg",
          title: "Counter Strike: Global Offensive",
          ontap: () {
            Navigator.pushNamed(context, AppRoutes.csgo);
          }),
      Tile(
          disabled: true,
          img: "assets/images/freefire.jpg",
          title: "Garena Free Fire",
          ontap: () {
            Navigator.pushNamed(context, AppRoutes.freefire);
          }),
      Tile(
          img: "assets/images/pubg.jpg",
          title: "PUBG New State",
          ontap: () {
            Navigator.pushNamed(context, AppRoutes.pubg);
          }),
      Tile(
          disabled: true,
          img: "assets/images/valo.jpg",
          title: "Valorant",
          ontap: () {
            Navigator.pushNamed(context, AppRoutes.valorant);
          }),
    ];

    return ListView.builder(
      itemBuilder: (context, index) => list[index],
      itemCount: list.length,
      physics: const BouncingScrollPhysics(),
    );
  }
}

// tile blueprint
class Tile extends StatelessWidget {
  const Tile({Key? key, required this.img, required this.title, required this.ontap, this.disabled = false})
      : super(key: key);
  final String img;
  final String title;
  final VoidCallback ontap;

  final bool disabled;

  @override
  Widget build(BuildContext context) {
    Widget dropIcon = Icon(
      Icons.keyboard_arrow_right,
      color: disabled ? Colors.black.withOpacity(0.3) : null,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 5, right: 5),
      child: InkWell(
        onTap: disabled ? null : ontap,
        child: SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: ClipRRect(
                  child: Image.asset(
                    img,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 150,
                height: 100,
                margin: const EdgeInsets.only(right: 15),
              ),
              Expanded(
                  child: Text(disabled ? "Coming Soon" : title,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: disabled ? Colors.black.withOpacity(0.3) : null),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      textAlign: TextAlign.start)),
              Container(
                child: dropIcon,
                margin: const EdgeInsets.all(5),
              )
            ],
          ),
          height: 100,
        ),
      ),
    );
  }
}
