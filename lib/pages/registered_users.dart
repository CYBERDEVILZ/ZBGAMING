import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegisteredUsers extends StatefulWidget {
  const RegisteredUsers(
      {Key? key, required this.matchType, required this.matchuid})
      : super(key: key);

  final String matchType;
  final String matchuid;

  @override
  State<RegisteredUsers> createState() => _RegisteredUsersState();
}

class _RegisteredUsersState extends State<RegisteredUsers> {
  bool isLoading = false;

  late Stream<QuerySnapshot<Map<String, dynamic>>> regUsers;

  void fetchRegUsers() async {
    isLoading = true;
    setState(() {});
    regUsers = FirebaseFirestore.instance
        .collection(widget.matchType)
        .doc(widget.matchuid)
        .collection("registeredUsers")
        .snapshots();
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchRegUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registered Users")),
      body: ListView(children: [
        StreamBuilder(
          stream: regUsers,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("An error occurred");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                  height: 30,
                  child: FittedBox(child: CircularProgressIndicator()));
            }
            return Column(
                children: snapshot.data!.docs.map((e) {
              return Card(
                child: ListTile(
                  title: Text(e["username"]),
                  subtitle: Text(e["IGID"]),
                ),
              );
            }).toList());
          },
        ),
      ]),
    );
  }
}
