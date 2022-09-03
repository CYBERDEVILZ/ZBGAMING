import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:zbgaming/model/organizermodel.dart';
import 'package:zbgaming/widgets/custom_divider.dart';
import 'package:zbgaming/widgets/organizer_card.dart';
import 'package:zbgaming/widgets/rules_and_requirements.dart';

class PreviewPane extends StatelessWidget {
  const PreviewPane({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? bannerurl = context.watch<OrganizerModel>().bannerurl;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview"),
        elevation: 0,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 6,
            width: MediaQuery.of(context).size.width,
            child: bannerurl != null
                ? Image.network(
                    bannerurl, // change the image to contest banner
                    fit: BoxFit.cover,
                  )
                : Image.asset("assets/images/csgo.jpg", fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 10),
              const Text("Tournament Name",
                  textAlign: TextAlign.start, textScaleFactor: 2, style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Row(children: [
                // date of tournament
                Text(
                  "dd-mm-yyyy",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
                ),

                const SizedBox(width: 20),

                // teams registered
                Row(
                  children: [
                    Icon(Icons.people_alt, size: 20, color: Colors.black.withOpacity(0.5)),
                    Text(
                      " 30/",
                      textScaleFactor: 1.1,
                      style: TextStyle(color: Colors.black.withOpacity(0.5)),
                    ),
                    Text(
                      "100",
                      textScaleFactor: 1.1,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)),
                    )
                  ],
                )
              ]),
              const Divider(height: 50),
              const Align(child: Text("Match Format", textScaleFactor: 1.5, style: TextStyle(color: Colors.black))),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                child: Container(
                  padding: const EdgeInsets.only(top: 3, left: 3, right: 3, bottom: 3),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(top: 5),
                    child: Column(
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          SizedBox(
                            width: 100,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: const [
                              Icon(Icons.crop_square, size: 25, color: Colors.purple),
                              SizedBox(width: 5),
                              Text("Icon\n",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.purple))
                            ]),
                          ),
                          SizedBox(
                            width: 100,
                            child: Column(children: [
                              Icon(Icons.crop_square, size: 25, color: Colors.blue[800]),
                              const SizedBox(width: 5),
                              Text("Icon\n",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blue[800]))
                            ]),
                          ),
                          SizedBox(
                            width: 100,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: const [
                              Icon(Icons.crop_square, size: 25, color: Colors.teal),
                              SizedBox(width: 5),
                              Text("Icon\n",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.teal))
                            ]),
                          ),
                        ]),
                        const SizedBox(height: 10),
                        Align(
                          child: Column(children: const [
                            Icon(Icons.crop_square, size: 25, color: Colors.red),
                            SizedBox(width: 5),
                            Text("Icon", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red))
                          ]),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 90,
                          padding: const EdgeInsets.all(3),
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(color: Colors.blue),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Winner gets",
                                style: TextStyle(color: Colors.white),
                                textScaleFactor: 1.3,
                              ),
                              Expanded(
                                child: FittedBox(
                                  child: Text(
                                    "\u20b9 xyz or more",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    textScaleFactor: 4,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Text("Organized By:", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
              OrganizerCard(
                ouid: FirebaseAuth.instance.currentUser!.uid,
              ),
              const SizedBox(height: 30),
              const Text("Rules", style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.7),
              Container(
                padding: const EdgeInsets.all(5),
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: const Rules(),
              ),

              const SizedBox(height: 30),

              // requirements
              Container(
                  padding: const EdgeInsets.all(5),
                  color: const Color(0xFF333333),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Requirements",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), textScaleFactor: 1.7),
                        Requirements(paid: false),
                      ])),

              const CustomDivider(indent: 0, height: 10, radius: false),

              Container(
                height: 75,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Container(
                      alignment: Alignment.center,
                      child: const FittedBox(
                        child: Text(
                          "FREE",
                          style: TextStyle(fontSize: 30, color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: ElevatedButton(
                        // register button
                        onPressed: () {},
                        child: const Text("Register", textScaleFactor: 1.3),
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(const Size(150, 50)),
                            elevation: MaterialStateProperty.all(0)),
                      ),
                    )
                  ],
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
