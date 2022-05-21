import 'package:flutter/material.dart';
import 'package:zbgaming/widgets/custom_colorful_container.dart';

class ShowUserAccount extends StatelessWidget {
  const ShowUserAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 2, 5, 26),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Image.asset(
              "assets/images/zbunker-app-banner-upsidedown-short.png",
              fit: BoxFit.fitWidth,
            ),
            const CircleAvatar(
              maxRadius: 70,
            ),
            const SizedBox(height: 30),
            const ShadowedContainer(
              anyWidget: Text(
                "CYBERDEVILZ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 40),
            ShadowedContainer(
              anyWidget: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    RichText(
                        text: const TextSpan(
                            text: "Level: ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            children: [
                          TextSpan(
                              text: "VETERAN",
                              style: TextStyle(fontWeight: FontWeight.w300))
                        ])),
                    const SizedBox(height: 20),
                    RichText(
                        text: const TextSpan(
                            text: "Matches Won: ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            children: [
                          TextSpan(
                              text: "32",
                              style: TextStyle(fontWeight: FontWeight.w300))
                        ])),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
