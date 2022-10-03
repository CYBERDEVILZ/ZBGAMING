import 'package:flutter/material.dart';

class VerifyStatusKYC extends StatefulWidget {
  const VerifyStatusKYC({Key? key, required this.status}) : super(key: key);
  final int status;

  @override
  State<VerifyStatusKYC> createState() => _VerifyStatusKYCState();
}

class _VerifyStatusKYCState extends State<VerifyStatusKYC> {
  @override
  Widget build(BuildContext context) {
    return widget.status == 0 ? const SendDocuments() : const VerificationPending();
  }
}

// SEND DOCUMENTS
class SendDocuments extends StatefulWidget {
  const SendDocuments({Key? key}) : super(key: key);

  @override
  State<SendDocuments> createState() => _SendDocumentsState();
}

class _SendDocumentsState extends State<SendDocuments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attach Documents"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [],
        ),
      )),
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
