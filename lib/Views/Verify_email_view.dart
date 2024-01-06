import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyemailView extends StatefulWidget {
  const VerifyemailView({Key? key}) : super(key: key);

  @override
  State<VerifyemailView> createState() => __VerifyemailViewState();
}

class __VerifyemailViewState extends State<VerifyemailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify email')),
      body: Column(children: [
        const Text('Please verify your email address '),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          },
          child: const Text('Send email verification'),
        ),
      ]),
    );
  }
}
