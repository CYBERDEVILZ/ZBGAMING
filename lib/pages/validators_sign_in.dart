import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:zbgaming/utils/apistring.dart';

class ValidatorSignUp extends StatelessWidget {
  ValidatorSignUp({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();

  // text editing controllers
  final TextEditingController email = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // text fields
    final TextFormField emailField = TextFormField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Email Address"),
        controller: email,
        validator: (value) {
          if (email.text.isEmpty) {
            return "Email Address cannot be empty";
          }
          if (!RegExp("[^@]+[@][^@]+[.][^@]+").hasMatch(email.text)) {
            return "Invalid Email Address";
          }
          return null;
        });

    final TextFormField usernameField = TextFormField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Username"),
        controller: username,
        validator: (value) {
          if (username.text.isEmpty) {
            return "Username cannot be empty";
          }
          return null;
        });

    final TextFormField passwordField = TextFormField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Password"),
        controller: password,
        validator: (value) {
          if (password.text.isEmpty) {
            return "Password cannot be empty";
          }
          if (password.text.length < 6) {
            return "Password must be atleast 6 characters long";
          }
          return null;
        });
    final TextFormField confirmPasswordField = TextFormField(
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      controller: confirmPassword,
      obscureText: true,
      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Confirm Password"),
      validator: (value) {
        if (confirmPassword.text != password.text) {
          return "Passwords don't match";
        }
        return null;
      },
    );

// --------------- Return is Here --------------- //
    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(children: [
            const SizedBox(height: 50),
            const Text("Validators SignUp"),
            const SizedBox(height: 20),
            emailField,
            const SizedBox(height: 20),
            usernameField,
            const SizedBox(height: 20),
            passwordField,
            const SizedBox(height: 20),
            confirmPasswordField,
            const SizedBox(height: 20),
            ElevatedButtonForValidator(formKey: formKey, email: email.text, username: username.text)
          ]),
        ),
      ),
    ));
  }
}

class ElevatedButtonForValidator extends StatefulWidget {
  const ElevatedButtonForValidator({Key? key, required this.formKey, required this.email, required this.username})
      : super(key: key);

  final GlobalKey<FormState> formKey;
  final String email;
  final String username;

  @override
  State<ElevatedButtonForValidator> createState() => _ElevatedButtonForValidatorState();
}

class _ElevatedButtonForValidatorState extends State<ElevatedButtonForValidator> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          isLoading = true;
          setState(() {});
          if (widget.formKey.currentState!.validate() == true) {
            await Fluttertoast.showToast(msg: "Waiting for response from API");
            await get(Uri.parse(ApiEndpoints.baseUrl +
                    ApiEndpoints.verifierSignup +
                    "?" +
                    "username=" +
                    widget.username +
                    "&email=" +
                    widget.email))
                .then((res) async {
              if (res.statusCode == 200) {
                var temp = res.body;
                await Fluttertoast.showToast(msg: temp);
              } else {
                await Fluttertoast.showToast(msg: "Unable to retrieve data at the moment");
              }
            }).catchError((e) {
              Fluttertoast.showToast(msg: "Failed to connect to host");
            });
          }
          isLoading = false;
          setState(() {});
        },
        child: isLoading ? const LinearProgressIndicator(color: Colors.white) : const Text("submit"));
  }
}
