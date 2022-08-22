import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:zbgaming/model/organizermodel.dart';
import 'package:zbgaming/pages/organizer_preview_pane.dart';
import 'package:zbgaming/widgets/favorite_organizer.dart';

class OrganizerAccount extends StatefulWidget {
  const OrganizerAccount({Key? key}) : super(key: key);

  @override
  State<OrganizerAccount> createState() => _OrganizerAccountState();
}

class _OrganizerAccountState extends State<OrganizerAccount> {
  bool isLoading = false;
  String? level;

  void fetchData() async {
    isLoading = true;
    setState(() {});
    await FirebaseFirestore.instance
        .collection("organizer")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) => level = value["amountGiven"] <= 10000 ? "Omega" : "Alpha")
        .catchError((onError) {
      Fluttertoast.showToast(msg: "Some error occurred");
    });
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    void updateImage() async {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        isLoading = true;
        setState(() {});
        await FirebaseStorage.instance
            .ref("zbgaming/organizers/images/${FirebaseAuth.instance.currentUser!.uid}/profile.jpg")
            .putFile(File(image.path))
            .then((p0) async {
          if (p0.state == TaskState.success) {
            String imageurl = await p0.ref.getDownloadURL();
            Fluttertoast.showToast(msg: "Uploaded Successfully");
            await FirebaseFirestore.instance
                .collection("organizer")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({"imageurl": imageurl});
            context.read<OrganizerModel>().setimageurl(imageurl);
          }
          if (p0.state == TaskState.error) {
            Fluttertoast.showToast(msg: "Some error occurred");
          }
        });
      }
      isLoading = false;
      setState(() {});
    }

    // --------------- Return is Here --------------- //
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("My Account"), elevation: 0),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Stack(children: [
                    // image
                    context.watch<OrganizerModel>().imageurl == null
                        ? CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 70,
                            child: FittedBox(
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Icon(
                                      Icons.account_circle,
                                      color: Colors.white,
                                      size: 180,
                                    ),
                              fit: BoxFit.cover,
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 70,
                            backgroundImage: NetworkImage(context.watch<OrganizerModel>().imageurl!),
                            child: isLoading ? const CircularProgressIndicator() : null,
                          ),

                    // edit button
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          // edit the image
                          onTap: () {
                            updateImage();
                          },
                          child: Icon(
                            Icons.edit,
                            color: Colors.blue[800],
                          ),
                        )),
                  ]),
                ),

                const SizedBox(height: 20),

                // Name
                Text(
                  context.watch<OrganizerModel>().username!,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  textScaleFactor: 2,
                ),

                // Level
                Text(
                  "Level: $level",
                  style: const TextStyle(color: Colors.blue),
                ),
                const SizedBox(height: 30),

                // Upload banner
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: const TextSpan(
                        text: "Upload Banner",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                        children: [
                          TextSpan(
                              text: " [width:height = 4:1]",
                              style: TextStyle(color: Colors.blue, fontSize: 15, fontWeight: FontWeight.normal))
                        ]),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                    height: MediaQuery.of(context).size.height / 6,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(border: Border.all(color: Colors.blue, width: 1.5)),
                    alignment: Alignment.center,
                    child:
                        // image widget to come here
                        const ImageWidget()),

                const SizedBox(height: 5),

                // preview button
                Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      child: const Text("Preview"),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const PreviewPane()));
                      },
                    )),

                const SizedBox(height: 20),

                // bank information tile
                GestureDetector(
                  onTap: () {},
                  child: const ListTile(
                    title: Text("Bank Information"),
                    trailing: Icon(Icons.arrow_right),
                  ),
                ),

                const SizedBox(height: 20),

                // Signout widget
                OutlinedButton(
                    onPressed: () async {
                      Fluttertoast.showToast(msg: "Logging out...");
                      await FirebaseAuth.instance.signOut();
                    },
                    child: const Text("Sign Out", style: TextStyle(fontSize: 22, color: Colors.red)),
                    style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.red.withOpacity(0.1)),
                        side: MaterialStateProperty.all(const BorderSide(color: Colors.red)),
                        fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width, 50))))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageWidget extends StatefulWidget {
  const ImageWidget({Key? key}) : super(key: key);

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: InkWell(
        // upload image, update state
        onTap: () async {
          XFile? imageFile = await ImagePicker().pickImage(source: ImageSource.gallery, maxHeight: 500, maxWidth: 2000);
          if (imageFile != null) {
            String _auth = FirebaseAuth.instance.currentUser!.uid;
            isLoading = true;
            setState(() {});
            await FirebaseStorage.instance
                .ref("zbgaming/organizers/images/$_auth/banner.jpg")
                .putFile(File(imageFile.path))
                .then((p0) async {
              if (p0.state == TaskState.success) {
                String link = await p0.ref.getDownloadURL();
                await FirebaseFirestore.instance
                    .collection("organizer")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({"bannerurl": link});
                Fluttertoast.showToast(msg: "Successful");
                context.read<OrganizerModel>().setbannerurl(link);
              }
              if (p0.state == TaskState.error) {
                Fluttertoast.showToast(msg: "Some error occurred");
              }
            });
          }
          isLoading = false;
          setState(() {});
        },
        child: Container(
            height: MediaQuery.of(context).size.height / 6,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 1.5),
                image: (context.read<OrganizerModel>().bannerurl != null
                    ? DecorationImage(image: NetworkImage(context.read<OrganizerModel>().bannerurl!), fit: BoxFit.cover)
                    : null)),
            alignment: Alignment.center,
            child: isLoading
                ? const CircularProgressIndicator(
                    color: Colors.blue,
                  )
                : const Icon(
                    Icons.add,
                    color: Colors.blue,
                  )),
      ),
    );
  }
}
