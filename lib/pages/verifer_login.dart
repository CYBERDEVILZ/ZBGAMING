import 'package:firebase_auth/firebase_auth.dart';
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

  // TextEditingControllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // functions
  submitFunction() async {
    isLoading = true;
    setState(() {});
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailController.text, password: passwordController.text)
        .catchError((onError) {
      Fluttertoast.showToast(msg: "Something went wrong :(");
      isLoading = false;
      setState(() {});
    });
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // auth state change
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const VerifierHomePage()));
      }
    });

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
            if (!RegExp(r"^[A-Za-z0-9\.]+[@][A-Za-z0-9\.]+$").hasMatch(value)) {
              return "Invalid Email";
            }
            return null;
          }),
        ));
    Widget passwordFieldWidget = Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: passwordController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Password (min 6 chars)",
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
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: const Text('Verifier Sign In'),
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            emailFieldWidget,
            passwordFieldWidget,
            submitButton,
            register,
          ],
        )),
      )),
    );
  }
}
