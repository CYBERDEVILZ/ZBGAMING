import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zbgaming/pages/verify_kyc_main.dart';

class KYCverificationPageForVerifier extends StatefulWidget {
  const KYCverificationPageForVerifier({Key? key}) : super(key: key);

  @override
  State<KYCverificationPageForVerifier> createState() => _KYCverificationPageForVerifierState();
}

class _KYCverificationPageForVerifierState extends State<KYCverificationPageForVerifier> {
  // STREAM
  Stream<QuerySnapshot>? kycpending;

  @override
  void initState() {
    super.initState();

    // STREAM TO RETRIEVE KYCPENDING DATA
    kycpending = FirebaseFirestore.instance.collection("kycPending").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // KYC HEADING
              Container(
                margin: const EdgeInsets.all(8),
                child: const Text(
                  "User KYC Verification",
                  style: TextStyle(fontSize: 22, color: Colors.green, fontWeight: FontWeight.w400),
                ),
              ),

              // STREAM BUILDER
              StreamBuilder(
                  stream: kycpending,
                  builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    // if there is no data
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("Nothing to show"),
                      );
                    }

                    // if there is an error
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Something went wrong"),
                      );
                    }

                    // if eveything goes right
                    return Column(
                        children: snapshot.data!.docs
                            .map((e) => KYCTile(
                                  username: e["username"],
                                  email: e["email"],
                                  assignedId: e["assigned"],
                                  hashedId: e.id,
                                ))
                            .toList());
                  }))
            ],
          ),
        ),
      ),
    );
  }
}

// KYC TILE
class KYCTile extends StatefulWidget {
  const KYCTile({Key? key, this.username, this.email, this.hashedId, this.assignedId}) : super(key: key);

  final String? username;
  final String? email;
  final String? hashedId;
  final String? assignedId;

  @override
  State<KYCTile> createState() => _KYCTileState();
}

class _KYCTileState extends State<KYCTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.assignedId == null
            ? Navigator.of(context).push(MaterialPageRoute(builder: (context) => VerifyKYCMain(uid: widget.hashedId!)))
            : Fluttertoast.showToast(msg: "being verified by: ${widget.assignedId}");
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.username}",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "${widget.email}",
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            const SizedBox(
              height: 5,
            ),
            Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                    "uid: ${widget.hashedId}",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                Positioned(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: widget.assignedId == null ? const Text("verify") : const Text("ongoing"),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                  ),
                  right: 0,
                )
              ],
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              colors: [Colors.green[800]!, Colors.green[600]!],
              begin: Alignment.bottomRight,
              end: Alignment.bottomCenter),
        ),
      ),
    );
  }
}
