import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: implementation_imports
import 'package:provider/src/provider.dart';

import 'package:zbgaming/model/usermodel.dart';
import 'package:zbgaming/pages/home_page.dart';
import 'package:zbgaming/utils/routes.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  // text controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwdController = TextEditingController();
  final TextEditingController confirmPasswdController = TextEditingController();

  // form key
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // submit data to firestore
    Future<void> submitData() async {
      await FirebaseFirestore.instance.collection("userinfo").doc(FirebaseAuth.instance.currentUser!.uid).set({
        "username": usernameController.text,
        "email": emailController.text,
        "imageurl": null,
        "organizer": false
      }).then((value) async {
        // add data to usermodel to reduce number of reads to firestore
        context.read<UserModel>().setuid(FirebaseAuth.instance.currentUser!.uid);
        context.read<UserModel>().setusername(usernameController.text);
        context.read<UserModel>().setimageurl(null);
        context.read<UserModel>().setemail(emailController.text);

        // show toast if successful
        await Fluttertoast.showToast(
            msg: "Registration successful!", backgroundColor: Colors.blue[700], textColor: Colors.white);
      });
    }

    // validation
    void validate() async {
      isLoading = true;
      if (mounted) setState(() {});
      if (formKey.currentState!.validate()) {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: emailController.text, password: passwdController.text)
            .then((value) async {
          await submitData();
        }).catchError((onError) => null);

        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
      }
      isLoading = false;
      if (mounted) setState(() {});
    }

    // username
    TextFormField username = TextFormField(
      controller: usernameController,
      textInputAction: TextInputAction.next,
      style: const TextStyle(color: Colors.black),
      validator: (value) {
        if (emailController.text.isEmpty) {
          return "Username field cannot be empty";
        }
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.account_circle),
        label: Text(
          "Username",
        ),
      ),
    );

    // email
    TextFormField email = TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      style: const TextStyle(color: Colors.black),
      validator: (value) {
        if (emailController.text.isEmpty) {
          return "Email field cannot be empty";
        }
        if (!RegExp("^[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+[.][a-zA-Z0-9]+\$").hasMatch(emailController.text)) {
          return "Invalid Email";
        }
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.mail),
        label: Text(
          "Email Address",
        ),
      ),
    );

    // password
    TextFormField password = TextFormField(
      controller: passwdController,
      obscureText: true,
      textInputAction: TextInputAction.next,
      style: const TextStyle(color: Colors.black),
      validator: (value) {
        if (passwdController.text.isEmpty) {
          return "Password field cannot be empty";
        }
        if (passwdController.text.length < 6) {
          return "Minimum 6 characters needed";
        }
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.vpn_key),
        label: Text(
          "Password",
          style: TextStyle(),
        ),
      ),
    );

    // confirm password
    TextFormField confirmPassword = TextFormField(
      controller: confirmPasswdController,
      obscureText: true,
      textInputAction: TextInputAction.done,
      style: const TextStyle(color: Colors.black),
      validator: (value) {
        if (confirmPasswdController.text != passwdController.text) {
          return "Password doesn't match";
        }
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.vpn_key),
        label: Text(
          "Confirm Password",
          style: TextStyle(),
        ),
      ),
    );

    // --------------- Return is Here --------------- //
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Stack(children: [
                // image for signup
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/zbunker-app-banner-upsidedown.png"), fit: BoxFit.cover)),
                ),

                const Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Join The League.",
                        style: TextStyle(color: Colors.blue, fontSize: 30),
                      ),
                    ),
                  ),
                )
              ]),

              Divider(
                color: Colors.blue,
                indent: MediaQuery.of(context).size.width / 2 - 30,
                thickness: 2,
              ),

              const SizedBox(height: 10),

              // username
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), child: username),

              // email
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), child: email),

              // password
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), child: password),

              // confirm password
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), child: confirmPassword),

              const SizedBox(height: 20),

              // submit button
              ElevatedButton(
                onPressed: () {
                  validate();
                },
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text("Sign Up"),
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0), fixedSize: MaterialStateProperty.all(const Size(150, 50))),
              ),

              const SizedBox(height: 20),

              // organizer signup link
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    child: const Text(
                      ">>> Sign Up for Organizers",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.organizerSignUp);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
