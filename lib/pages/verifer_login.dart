import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zbgaming/pages/verifier_home_page.dart';
import 'package:zbgaming/pages/verifier_sign_up.dart';

class VerifierSignIn extends StatefulWidget {
  const VerifierSignIn({Key? key}) : super(key: key);

  @override
  State<VerifierSignIn> createState() => _VerifierSignInState();
}

class _VerifierSignInState extends State<VerifierSignIn> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool showPass = false;

  // TextEditingControllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // functions
  submitFunction() async {
    isLoading = true;
    setState(() {});
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailController.text, password: passwordController.text)
        .then((value) => null)
        .catchError((onError) {
      Fluttertoast.showToast(msg: "Something went wrong :(");
    });
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    if (mounted) setState(() {});
    if (mounted) {
      FirebaseAuth.instance.authStateChanges().listen((User? event) {
        if (event?.uid != null) {
          if (mounted) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const VerifierHomePage()));
          }
        }
      });
    }
    isLoading = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TextFormField Widgets
    Widget emailFieldWidget = Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Email",
          ),
          validator: ((value) {
            if (value == null || value.isEmpty) {
              return "Field cannot be empty";
            }
            if (!RegExp(r"^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$").hasMatch(value)) {
              return "Invalid Email";
            }
            return null;
          }),
        ));
    Widget passwordFieldWidget = Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: passwordController,
          obscureText: !showPass,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: "Password (min 6 chars)",
            suffixIcon: GestureDetector(
              onTap: () {
                showPass = !showPass;
                setState(() {});
              },
              child: Icon(showPass ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill),
            ),
          ),
          validator: ((value) {
            if (value == null || value.isEmpty) {
              return "Field cannot be empty";
            }
            if (value.length < 6) {
              return "Minimum 6 characters required";
            }
            return null;
          }),
        ));

    // submit button
    Widget submitButton = ElevatedButton(
      onPressed: () {
        submitFunction();
      },
      child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("submit"),
    );

    // register account
    Widget register = TextButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const VerifierSignUp()));
        },
        child: const Text("Create Account"));

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Verifier Sign In'),
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
            children: [
              emailFieldWidget,
              passwordFieldWidget,
              submitButton,
              register,
            ],
          )),
        ),
      ),
    );
  }
}
