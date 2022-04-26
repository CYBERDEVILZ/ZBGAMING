import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LinkGame extends StatefulWidget {
  const LinkGame({Key? key, required this.matchType}) : super(key: key);
  final String matchType;

  @override
  State<LinkGame> createState() => _LinkGameState();
}

class _LinkGameState extends State<LinkGame> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController idController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: const Text("Link your Account"), elevation: 0),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Right now no validation is done. Later I will integrate validation.",
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "In-Game UID", border: OutlineInputBorder()),
                    controller: idController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Field cannot be empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // BUTTON HERE.............. SUBMIT BUTTON HERE...............
                  ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          isLoading = true;
                          setState(() {});
                          await FirebaseFirestore.instance
                              .collection("userinfo")
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .collection("linkedAccounts")
                              .doc(widget.matchType)
                              .set({"id": idController.text});
                        }
                        isLoading = false;
                        setState(() {});
                      },
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text("Submit"))
                ],
              ),
            ),
          )),
    );
  }
}
