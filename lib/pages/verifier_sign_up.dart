import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:zbgaming/utils/apistring.dart';

class VerifierSignUp extends StatefulWidget {
  const VerifierSignUp({Key? key}) : super(key: key);

  @override
  State<VerifierSignUp> createState() => _VerifierSignUpState();
}

class _VerifierSignUpState extends State<VerifierSignUp> {
  // variables
  bool isLoading = false;

  // declaring form key
  final formKey = GlobalKey<FormState>();

  // functions
  submitFunction() async {
    setState(() {
      isLoading = true;
    });
    if (formKey.currentState!.validate()) {
      await post(Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.verifierSignup), body: {
        "username": usernameController.text,
        "email": emailController.text,
        "password": passwordController.text
      }).then((value) {
        // if server errors out
        if (value.statusCode != 200) {
          Fluttertoast.showToast(msg: "Server Error :(");
          setState(() {
            isLoading = false;
          });
          return null;
        }

        // if backend verification failed
        if (value.body == "Failed") {
          Fluttertoast.showToast(msg: "Could not create account :(");
          setState(() {
            isLoading = false;
          });
          return null;
        }

        // if successful
        if (value.body == "Success") {
          Fluttertoast.showToast(msg: "Account successfully created!");
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
          return null;
        }

        // if wrong return
        else {
          setState(() {
            isLoading = false;
          });
          return null;
        }
      })
          // if error in code
          .catchError((e) {
        Fluttertoast.showToast(msg: "Something went wrong :(");
        setState(() {
          isLoading = false;
        });
        return null;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  // TextEditingControllers
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TextFormField Widgets
    Widget usernameFieldWidget = Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: usernameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Username",
          ),
          validator: ((value) {
            if (value == null || value.isEmpty) {
              return "Field cannot be empty";
            }
            return null;
          }),
        ));
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
          obscureText: true,
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
    Widget confirmPasswordFieldWidget = Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          controller: confirmPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Confirm Password",
          ),
          validator: ((value) {
            if (value != passwordController.text) {
              return "Passwords don't match";
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

    // ------------- RETURN IS HERE -------------
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Verifier Registration"),
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            usernameFieldWidget,
            emailFieldWidget,
            passwordFieldWidget,
            confirmPasswordFieldWidget,
            submitButton,
          ],
        )),
      ),
    );
  }
}
