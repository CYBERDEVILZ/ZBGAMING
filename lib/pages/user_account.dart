// ------------------- NOTES FOR DEVELOPER ------------------- //

// --> LINK ACCOUNTS LOGIC
//      - games to be linked are stored in "array". <<<<<<< Make it online, much easier!
//      - during init, check the array, create a map
//        "linkedAccounts" with keys == elements of
//        "array" and values initialized to null.
//      - create list tiles based on the elements in array.
//      - fetch data from database and update the values of
//        each key. If value == null, not linked else linked.
//      * IF A NEW GAME NEEDS TO BE ADDED....
//      * Update the "array" with the name.
//      * Automatically, list tile will be created for it.
//      * When user clicks on link, it will add a new value to
//        his database.
//
// --> ACCOUNT DELETE LOGIC
//      - firebase doesn't support user deletion from our side.
//      - reauthenticate user
//      - delete the user
//
// ------------------- NOTES FOR DEVELOPER ------------------- //

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zbgaming/model/usermodel.dart';
import 'package:zbgaming/pages/home_page.dart';
import 'package:provider/provider.dart';

Map<String, Color> colorCodeForHeading = {
  "Unidentified": Colors.blue,
  "Rookie": Colors.blue,
  "Veteran": const Color(0xffB3E3EE),
  "Master Elite": const Color(0xFFFFD700)
};

Map<String, Color> colorCodeForText = {
  "Unidentified": Colors.black,
  "Rookie": Colors.black,
  "Veteran": Colors.white,
  "Master Elite": Colors.white
};

Map<String, Color> colorCodeForButtonTextCumCanvas = {
  "Unidentified": Colors.white,
  "Rookie": Colors.white,
  "Veteran": const Color(0xff00334c),
  "Master Elite": Colors.black
};

Map<String, Color> colorCodeForCanvas = {
  "Unidentified": Colors.white,
  "Rookie": Colors.white,
  "Veteran": const Color(0xff00334c),
  "Master Elite": Colors.black
};

class UserAccount extends StatefulWidget {
  const UserAccount({Key? key}) : super(key: key);

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  String? name;
  String? imageurl;
  String? lvl;
  String? email;
  int? level;
  String levelAttrib = "Unidentified";
  bool? isEmailVerified;
  bool? isKYCVerified;
  bool isVerifying = false;
  bool isLoading = false;
  bool isImageLoad = false;
  bool? bankStatus;
  bool isDeleting = false;

  TextEditingController passValue = TextEditingController();

  // add more games here if any...
  final List<String> array = [
    "Player Unknown Battlegrounds",
    "Counter Strike Global Offensive",
    "Free Fire",
    "Valorant"
  ];

  Map<String, String?> linkedAccounts = {};

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void fetchData() async {
    isLoading = true;
    if (mounted) {
      setState(() {});
    }
    await FirebaseFirestore.instance.collection("userinfo").doc(_auth.currentUser!.uid).get().then((value) {
      name = value["username"];
      imageurl = value["imageurl"];
      email = value["email"];
      try {
        level = value["level"];
        if (level! <= 5000) {
          levelAttrib = "Rookie";
        } else if (level! <= 20000) {
          levelAttrib = "Veteran";
        } else {
          levelAttrib = "Master Elite";
        }
      } catch (e) {
        level = null;
        levelAttrib = "Unidentified";
      }
      try {
        isKYCVerified = value["verified"];
      } catch (e) {
        isKYCVerified = false;
      }
      isEmailVerified = _auth.currentUser!.emailVerified;
    }).catchError((onError) {
      Fluttertoast.showToast(msg: "Error getting data");
    });

    // fetching linked accounts data
    await FirebaseFirestore.instance
        .collection("userinfo")
        .doc(_auth.currentUser!.uid)
        .collection("linkedAccounts")
        .get()
        .then((value) {
      List<QueryDocumentSnapshot> list = value.docs;
      for (int i = 0; i < list.length; i++) {
        linkedAccounts.putIfAbsent(list[i].id, () => list[i]["id"]);
      }
    }).catchError((onError) {
      Fluttertoast.showToast(msg: "An error occurred");
    });
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    _auth.userChanges().listen((event) {
      if (event?.uid == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        if (mounted) setState(() {});
      }
    });

    // initialize the linked accounts with null values
    array.map((e) => linkedAccounts.putIfAbsent(e, () => null));

    // fetch data
    fetchData();
  }

  void imageUpload() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery, maxHeight: 250, maxWidth: 250);
    if (image != null) {
      isImageLoad = true;
      if (mounted) setState(() {});
      await FirebaseStorage.instance
          .ref("zbgaming/users/images/${FirebaseAuth.instance.currentUser?.uid}/profile.jpg")
          .putFile(File(image.path))
          .then((p0) async {
        if (p0.state == TaskState.success) {
          String imageurl = await p0.ref.getDownloadURL();
          context.read<UserModel>().setimageurl(imageurl);
          await FirebaseFirestore.instance
              .collection("userinfo")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({"imageurl": imageurl});
          Fluttertoast.showToast(
              msg: "Image Uploaded Successfully",
              textColor: colorCodeForButtonTextCumCanvas[levelAttrib],
              backgroundColor: colorCodeForHeading[levelAttrib]);
        }
        if (p0.state == TaskState.error) {
          Fluttertoast.showToast(
            msg: "Some error occurred",
            backgroundColor: colorCodeForHeading[levelAttrib],
            textColor: colorCodeForButtonTextCumCanvas[levelAttrib],
          );
        }
      }).catchError((onError) {
        Fluttertoast.showToast(
          msg: "Some error occurred",
          backgroundColor: colorCodeForHeading[levelAttrib],
          textColor: colorCodeForButtonTextCumCanvas[levelAttrib],
        );
      });
    }
    isImageLoad = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Image Widget
    Widget imageWidget = Stack(clipBehavior: Clip.none, children: [
      // blue rectangle in the back
      Container(
        color: colorCodeForHeading[levelAttrib],
        height: 125,
        width: MediaQuery.of(context).size.width,
      ),

      // background circle
      Positioned(
        bottom: -40,
        left: MediaQuery.of(context).size.width / 2 - 55,
        child: Stack(
          children: [
            CircleAvatar(
              backgroundColor: colorCodeForButtonTextCumCanvas[levelAttrib],
              radius: 55,
            ),
            // inside circle
            Positioned(
                left: 5,
                top: 5,
                child: GestureDetector(
                  // image select and upload code
                  onTap: () {
                    imageUpload();
                  },
                  child: CircleAvatar(
                    backgroundColor: colorCodeForHeading[levelAttrib],
                    radius: 50,
                    child: isImageLoad
                        ? CircularProgressIndicator(
                            color: context.watch<UserModel>().imageurl == null
                                ? colorCodeForButtonTextCumCanvas[levelAttrib]
                                : colorCodeForHeading[levelAttrib])
                        : Icon(Icons.add_a_photo_outlined,
                            color: context.watch<UserModel>().imageurl == null
                                ? colorCodeForButtonTextCumCanvas[levelAttrib]
                                : colorCodeForHeading[levelAttrib]),
                    backgroundImage: context.watch<UserModel>().imageurl == null
                        ? null
                        : NetworkImage(context.watch<UserModel>().imageurl!),
                  ),
                )),
          ],
        ),
      ),
    ]);

    // Level Widget
    Widget levelWidget = Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          // if level == null
          level == null
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey),
                  margin: const EdgeInsets.only(top: 5),
                  child: const Text(
                    "Unidentified",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ))

              // if level == rookie
              : level! <= 5000
                  ? Container(
                      margin: const EdgeInsets.only(top: 3),
                      child: const Text(
                        "Rookie",
                        style: TextStyle(
                            fontSize: 15, color: Colors.blue, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                      ))

                  // if level == veteran
                  : level! <= 20000
                      ? Container(
                          margin: const EdgeInsets.only(top: 3),
                          child: Text(
                            "Veteran",
                            style: TextStyle(
                                fontSize: 15,
                                color: colorCodeForHeading[levelAttrib],
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ))

                      // if level == elite
                      : level! > 20000
                          ? Container(
                              margin: const EdgeInsets.only(top: 3),
                              child: const Text(
                                "Master Elite",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0XFFFFD700),
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                              ))

                          // if level == invalid
                          : Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red),
                              margin: const EdgeInsets.only(top: 5),
                              child: const Text(
                                "Invalid",
                                style: TextStyle(fontSize: 15, color: Colors.white),
                              )),
          Container(
            height: 20,
            width: MediaQuery.of(context).size.width / 2 - 63,
            alignment: Alignment.centerRight,
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        "$level",
                        style: TextStyle(fontWeight: FontWeight.w300, color: colorCodeForHeading[levelAttrib]),
                      ),
                    ),
                  ),
                ),
                Text(
                  "pts",
                  style: TextStyle(fontWeight: FontWeight.bold, color: colorCodeForHeading[levelAttrib]),
                )
              ],
            ),
          )
        ]));

    // Name Widget
    Widget nameWidget = Text(name == null ? "null" : name!,
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w500,
          color: colorCodeForHeading[levelAttrib],
        ));

    // Email Widget
    Widget emailWidget = Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 16 - 100,
        ),
        child: Text(
          email == null ? "null" : email!,
          style: TextStyle(color: colorCodeForText[levelAttrib], fontWeight: FontWeight.w300),
        ),
      ),
      const SizedBox(width: 10),
      isEmailVerified == true
          ? Icon(
              Icons.verified_rounded,
              color: colorCodeForHeading[levelAttrib],
              size: 15,
            )
          : GestureDetector(
              // verify email logic here
              onTap: () async {
                isVerifying = true;
                if (mounted) setState(() {});
                await _auth.currentUser?.sendEmailVerification().then((value) async {
                  await Fluttertoast.showToast(
                      msg: "Verify mail and login again", textColor: Colors.white, backgroundColor: Colors.blue);
                  await _auth.signOut();
                }).catchError((onError) {
                  Fluttertoast.showToast(
                      msg: "Something went wrong.", textColor: Colors.white, backgroundColor: Colors.blue);
                });

                isVerifying = false;
                if (mounted) setState(() {});
              },
              child: Container(
                  height: 18,
                  width: 80,
                  alignment: Alignment.center,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(3), border: Border.all(color: Colors.blue)),
                  child: isVerifying
                      ? const SizedBox(width: 18, child: LinearProgressIndicator(color: Colors.blue))
                      : const Text(
                          " verify email ",
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                        )))
    ]);

    // KYCWidget
    Widget kycWidget = Row(
        children: isKYCVerified == null
            ? [
                Text(
                  "Null",
                  style: TextStyle(fontWeight: FontWeight.w300, color: colorCodeForHeading[levelAttrib]),
                ),
              ]
            : isKYCVerified!
                ? [
                    Text(
                      "Verified",
                      style: TextStyle(fontWeight: FontWeight.bold, color: colorCodeForHeading[levelAttrib]),
                    ),
                    Text(
                      "User",
                      style: TextStyle(fontWeight: FontWeight.w300, color: colorCodeForHeading[levelAttrib]),
                    )
                  ]
                : [
                    GestureDetector(
                        // send user to verification page
                        onTap: () async {
                          Fluttertoast.showToast(msg: "Navigate to user verification page");
                        },
                        child: Container(
                            height: 18,
                            width: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(color: colorCodeForHeading[levelAttrib]!)),
                            child: Text(
                              " verify user ",
                              style: TextStyle(color: colorCodeForHeading[levelAttrib], fontSize: 12),
                            )))
                  ]);

    // Link Widget
    Widget linkWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Link",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w100, color: colorCodeForHeading[levelAttrib]),
            ),
            Text(
              "Accounts",
              style: TextStyle(fontSize: 30, color: colorCodeForHeading[levelAttrib], fontWeight: FontWeight.w300),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Link Tiles
        ...array
            .map((element) => Container(
                  margin: const EdgeInsets.all(3),
                  child: ListTile(
                      tileColor: colorCodeForHeading[levelAttrib],
                      leading: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          element,
                          style: TextStyle(color: colorCodeForButtonTextCumCanvas[levelAttrib]),
                        ),
                      ),
                      trailing:
                          // if linked_id == true
                          linkedAccounts[element] != null
                              ? GestureDetector(
                                  // navigate to edit account page
                                  onTap: () {},
                                  child: Icon(
                                    Icons.open_in_new,
                                    color: colorCodeForButtonTextCumCanvas[levelAttrib],
                                  ),
                                )
                              :
                              // if linked_id == false
                              Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                  color: colorCodeForButtonTextCumCanvas[levelAttrib],
                                  child: GestureDetector(
                                    // navigates to link page
                                    onTap: () {
                                      Fluttertoast.showToast(msg: "Navigate the nigga");
                                    },
                                    child: Text(
                                      "Link Now",
                                      style: TextStyle(color: colorCodeForText[levelAttrib]),
                                    ),
                                  ),
                                )),
                ))
            .toList(),
      ],
    );

    // Bank Widget
    Widget bankWidget = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Bank",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w100, color: colorCodeForHeading[levelAttrib]),
            ),
            Text(
              "Information",
              style: TextStyle(fontSize: 30, color: colorCodeForHeading[levelAttrib], fontWeight: FontWeight.w300),
            ),
          ],
        ),
        const SizedBox(height: 10),
        bankStatus == null
            ? Text("Couldn't retreive data",
                style: TextStyle(color: colorCodeForHeading[levelAttrib], fontWeight: FontWeight.w300))
            : bankStatus == true
                ? Container()
                : Container(),
      ],
    );

    // SignOut Widget
    Widget signoutWidget = OutlinedButton(
      // function to signout
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
      },
      child: const Text(
        "Sign Out",
        style: TextStyle(color: Colors.red),
      ),
      style: ButtonStyle(
          fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width, 50)),
          overlayColor: MaterialStateProperty.all(Colors.red.withOpacity(0)),
          side: MaterialStateProperty.all(const BorderSide(color: Colors.red))),
    );

    // Delete Modal
    Widget deleteModal = AbsorbPointer(
        absorbing: isDeleting,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: colorCodeForButtonTextCumCanvas[levelAttrib]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Warning!", style: TextStyle(color: colorCodeForHeading[levelAttrib], fontSize: 25)),
              const SizedBox(height: 10),
              Text("You are about to delete your account. All your information will be deleted from our database.",
                  style: TextStyle(color: colorCodeForText[levelAttrib])),
              Text("This action cannot be reversed once initiated.",
                  style: TextStyle(color: colorCodeForText[levelAttrib])),
              const SizedBox(height: 10),
              Row(
                children: [
                  // delete button
                  ElevatedButton(
                    onPressed: () async {
                      // show alert box asking for reauth
                      await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text(
                                  "Login",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                                content: Column(mainAxisSize: MainAxisSize.min, children: [
                                  // password field
                                  TextField(
                                    controller: passValue,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(label: Text("Password")),
                                    obscureText: true,
                                  ),

                                  // submit button
                                  OutlinedButton(
                                      // reauthenticate user
                                      onPressed: () async {
                                        AuthCredential credential = EmailAuthProvider.credential(
                                            email: Provider.of<UserModel>(context, listen: false).email!,
                                            password: passValue.text);
                                        if (passValue.text.isNotEmpty) {
                                          await FirebaseAuth.instance.currentUser!
                                              .reauthenticateWithCredential(credential)
                                              .then((value) async {
                                            Navigator.pop(context);
                                            isDeleting = true;
                                            setState(() {});
                                            // delete userinfo data
                                            try {
                                              await FirebaseFirestore.instance
                                                  .collection("userinfo")
                                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                                  .delete();
                                            } catch (e) {
                                              return null;
                                            }

                                            try {
                                              // delete storage data
                                              await FirebaseStorage.instance
                                                  .ref(
                                                      "zbgaming/users/images/${FirebaseAuth.instance.currentUser!.uid}/profile.jpg")
                                                  .delete();
                                            } catch (e) {
                                              null;
                                            }

                                            // delete auth data
                                            await FirebaseAuth.instance.currentUser!.delete().catchError((onError) {
                                              Fluttertoast.showToast(msg: onError.toString());
                                            });

                                            isDeleting = false;
                                            setState(() {});
                                          }).catchError((e) {
                                            Fluttertoast.showToast(msg: "Couldn't Reauthenticate");
                                            Navigator.pop(context);
                                          });
                                        } else {
                                          Fluttertoast.showToast(msg: "Password cannot be empty");
                                        }
                                      },
                                      child: const Text("Submit"))
                                ]),
                              ));
                    },
                    child: isDeleting ? const CircularProgressIndicator() : const Text("Delete"),
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        fixedSize: MaterialStateProperty.all(const Size(150, 20))),
                  ),
                  const Spacer(),

                  // cancel button
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(null),
                          foregroundColor: MaterialStateProperty.all(Colors.red),
                          side: MaterialStateProperty.all(const BorderSide(color: Colors.red))))
                ],
              )
            ],
          ),
        ));

    // Delete User Widget
    Widget deleteUserWidget = ElevatedButton(
      onPressed: () {
        // show modal bottom sheet
        showModalBottomSheet(
          context: context,
          builder: (context) => deleteModal,
          isDismissible: false,
          constraints: const BoxConstraints(maxHeight: 300),
        );
      },
      child: const Text(
        "Delete Account",
        style: TextStyle(color: Colors.white),
      ),
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width, 50)),
        backgroundColor: MaterialStateProperty.all(Colors.red),
        elevation: MaterialStateProperty.all(0),
      ),
    );

    // --------------- Return is Here --------------- //
    return Scaffold(
      backgroundColor: colorCodeForButtonTextCumCanvas[levelAttrib],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  imageWidget,
                  levelWidget,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        nameWidget,
                        emailWidget,
                        const SizedBox(height: 5),
                        kycWidget,
                        const SizedBox(height: 30),
                        linkWidget,
                        const SizedBox(height: 20),
                        bankWidget,
                        const SizedBox(height: 50),
                        signoutWidget,
                        const SizedBox(height: 10),
                        deleteUserWidget,
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

//  // Delete Modal
//     Widget deleteModal = AbsorbPointer(
//         absorbing: isDeleting,
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(color: colorCodeForButtonTextCumCanvas[levelAttrib]),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Text("Warning!", style: TextStyle(color: colorCodeForHeading[levelAttrib], fontSize: 25)),
//               const SizedBox(height: 10),
//               Text("You are about to delete your account. All your information will be deleted from our database.",
//                   style: TextStyle(color: colorCodeForText[levelAttrib])),
//               Text("This action cannot be reversed once initiated.",
//                   style: TextStyle(color: colorCodeForText[levelAttrib])),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   ElevatedButton(
//                     onPressed: () async {
//                       isDeleting = true;
//                       setState(() {});

//                       // delete firestore data
//                       await FirebaseFirestore.instance
//                           .collection("userinfo")
//                           .doc(FirebaseAuth.instance.currentUser!.uid)
//                           .delete()
//                           .then((value) async {
//                         // delete storage data
//                         await FirebaseStorage.instance
//                             .ref("zbgaming/users/images/${FirebaseAuth.instance.currentUser!.uid}/profile.jpg")
//                             .delete()
//                             .then((value) async {
//                           // delete auth data

//                           await FirebaseAuth.instance.currentUser!.delete().catchError((onError) {
//                             Fluttertoast.showToast(msg: onError.toString());
//                           });
//                         }).catchError((e) {
//                           Fluttertoast.showToast(msg: "An erro occurred\nerror code: 7UK213");
//                         });
//                       }).catchError((e) {
//                         Fluttertoast.showToast(msg: "An erro occurred\nerror code: 3EF451");
//                       });
//                       isDeleting = false;
//                       setState(() {});
//                     },
//                     child: isDeleting ? const CircularProgressIndicator(color: Colors.white) : const Text("Delete"),
//                     style: ButtonStyle(
//                         elevation: MaterialStateProperty.all(0),
//                         backgroundColor: MaterialStateProperty.all(Colors.red),
//                         fixedSize: MaterialStateProperty.all(const Size(150, 20))),
//                   ),
//                   const Spacer(),
//                   OutlinedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Text("Cancel"),
//                       style: ButtonStyle(
//                           overlayColor: MaterialStateProperty.all(null),
//                           foregroundColor: MaterialStateProperty.all(Colors.red),
//                           side: MaterialStateProperty.all(const BorderSide(color: Colors.red))))
//                 ],
//               )
//             ],
//           ),
//         ));