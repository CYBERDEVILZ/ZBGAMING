import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:zbgaming/model/usermodel.dart';

class VerifyStatusKYC extends StatefulWidget {
  const VerifyStatusKYC({Key? key}) : super(key: key);

  @override
  State<VerifyStatusKYC> createState() => _VerifyStatusKYCState();
}

class _VerifyStatusKYCState extends State<VerifyStatusKYC> {
  @override
  Widget build(BuildContext context) {
    return const SendDocuments();
  }
}

// ATTACH DOCUMENTS
class SendDocuments extends StatefulWidget {
  const SendDocuments({Key? key}) : super(key: key);

  @override
  State<SendDocuments> createState() => _SendDocumentsState();
}

class _SendDocumentsState extends State<SendDocuments> {
  late List<CameraDescription> cameraList;
  late CameraController cameraController;
  bool isLoading = true;
  bool isCapturing = false;
  bool isUploading = false;
  int? docType;
  final Map<int, String> docTypetoStorageRef = {
    0: "/govt_id_image_front.jpg",
    1: "/govt_id_image_back.jpg",
    2: "/govt_id_image_with_face.jpg"
  };
  final Map<int, String> docTypetoKey = {
    0: "govt_id_image_front",
    1: "govt_id_image_back",
    2: "govt_id_image_with_face"
  };

  // functions
  checkStatusAndInitCamera() async {
    isLoading = true;
    if (mounted) setState(() {});
    // CHECKING WHATS LEFT TO SEND
    await FirebaseFirestore.instance
        .collection("kycPending")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (!value.exists) {
        docType = 0;
      } else {
        try {
          if (value["govt_id_image_front"] != null) {
            try {
              if (value["govt_id_image_back"] != null) {
                try {
                  if (value["govt_id_image_with_face"] != null) {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: ((context) => const VerificationPending())));
                  }
                } catch (e) {
                  docType = 2;
                }
              }
            } catch (e) {
              docType = 1;
            }
          }
        } catch (e) {
          docType = 0;
        }
      }
    }).catchError((onError) {
      Fluttertoast.showToast(msg: "Something went wrong.");
      Navigator.pop(context);
    });
    // INIT CAMERA
    cameraList = await availableCameras();
    cameraController = CameraController(docType == 2 ? cameraList[1] : cameraList.first, ResolutionPreset.high);
    await cameraController.initialize();
    isLoading = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkStatusAndInitCamera();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : isCapturing
                ? const Center(
                    child: Text(
                      "Capturing Image...",
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  )
                : isUploading
                    ? const Center(
                        child: Text(
                          "Uploading Image. Please wait..",
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      )
                    : Stack(children: [
                        // camera preview
                        Positioned.fill(
                            child: Stack(
                          children: [
                            Positioned.fill(child: CameraPreview(cameraController)),
                            Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AspectRatio(
                                aspectRatio: docType == 2 ? 1 / 1 : 1920 / 1080,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white, width: 3),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ))
                          ],
                        )),

                        // APP BAR
                        Positioned(
                          child: SizedBox(
                            height: 70,
                            width: MediaQuery.of(context).size.width,
                            child: ClipRect(
                              child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Row(
                                    children: [
                                      BackButton(
                                        color: Colors.white,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      Expanded(
                                        child: Text(
                                          docType == 0
                                              ? "Govt ID (FRONT SIDE)"
                                              : docType == 1
                                                  ? "Govt ID (BACK SIDE)"
                                                  : docType == 2
                                                      ? "Govt ID and your Face"
                                                      : "null",
                                          style: const TextStyle(
                                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          top: 0,
                          left: 0,
                        ),

                        // CAPTURE BUTTON
                        Positioned(
                            bottom: 10,
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      isCapturing = true;
                                      setState(() {});
                                      final XFile image = await cameraController.takePicture();
                                      isCapturing = false;
                                      setState(() {});
                                      final CroppedFile? croppedImage = await ImageCropper().cropImage(
                                        sourcePath: image.path,
                                        aspectRatio: docType == 0
                                            ? const CropAspectRatio(ratioX: 1920, ratioY: 1080)
                                            : docType == 1
                                                ? const CropAspectRatio(ratioX: 1920, ratioY: 1080)
                                                : const CropAspectRatio(ratioX: 1, ratioY: 1),
                                        compressQuality: 100,
                                        compressFormat: ImageCompressFormat.jpg,
                                        uiSettings: [
                                          AndroidUiSettings(
                                              cropFrameColor: Colors.white,
                                              statusBarColor: Colors.blue,
                                              dimmedLayerColor: Colors.black,
                                              showCropGrid: false,
                                              toolbarTitle: "Submit Image",
                                              hideBottomControls: true)
                                        ],
                                      );
                                      if (croppedImage != null) {
                                        try {
                                          isUploading = true;
                                          setState(() {});
                                          await FirebaseStorage.instance
                                              .ref("zbgaming/users/images/" +
                                                  FirebaseAuth.instance.currentUser!.uid +
                                                  docTypetoStorageRef[docType!]!)
                                              .putFile(File(croppedImage.path))
                                              .then((p0) async {
                                            if (p0.state == TaskState.running) {
                                              Fluttertoast.showToast(msg: "Image getting uploaded");
                                              isUploading = false;
                                              if (mounted) setState(() {});
                                            }
                                            if (p0.state == TaskState.canceled) {
                                              Fluttertoast.showToast(msg: "Image upload canceled");
                                              Fluttertoast.showToast(msg: "Navigate to govt_id_back_side");
                                              isUploading = false;
                                              if (mounted) setState(() {});
                                            }
                                            if (p0.state == TaskState.success) {
                                              final url = await FirebaseStorage.instance
                                                  .ref("zbgaming/users/images/" +
                                                      FirebaseAuth.instance.currentUser!.uid +
                                                      docTypetoStorageRef[docType]!)
                                                  .getDownloadURL();
                                              if (docType == 0) {
                                                await FirebaseFirestore.instance
                                                    .collection("kycPending")
                                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                                    .set({
                                                  "email": context.read<UserModel>().email,
                                                  "username": context.read<UserModel>().username,
                                                  "assigned": null
                                                });
                                              }
                                              await FirebaseFirestore.instance
                                                  .collection("kycPending")
                                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                                  .update({
                                                docTypetoKey[docType]!: url,
                                              });
                                              Fluttertoast.showToast(msg: "Image upload success");
                                              isUploading = false;
                                              if (mounted) setState(() {});
                                              Navigator.pushReplacement(context,
                                                  MaterialPageRoute(builder: (context) => const SendDocuments()));
                                            }
                                            if (p0.state == TaskState.error) {
                                              Fluttertoast.showToast(msg: "Some error occurred");
                                              isUploading = false;
                                              if (mounted) setState(() {});
                                            }
                                          });
                                        } catch (e) {
                                          Fluttertoast.showToast(msg: "Something went wrong :(");
                                          isUploading = false;
                                          if (mounted) setState(() {});
                                        }
                                      } else {
                                        setState(() {});
                                      }
                                    },
                                    child: const Icon(
                                      Icons.camera,
                                      size: 30,
                                    ))))
                      ]),
      ),
    );
  }
}

// VERIFICATION PENDING
class VerificationPending extends StatefulWidget {
  const VerificationPending({Key? key}) : super(key: key);

  @override
  State<VerificationPending> createState() => _VerificationPendingState();
}

class _VerificationPendingState extends State<VerificationPending> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/pending.png"),
            Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Text(
                      "Documents are being verified.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[900],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Your documents have been submitted. Kindly give us 24-72 hours to verify them. Thank you for your patience.",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blue[900]),
                          elevation: MaterialStateProperty.all(0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Go Back",
                        ))
                  ],
                ))
          ],
        ),
      ),
    )));
  }
}
