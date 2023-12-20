import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Column(
        children: [
          TextField(
            enableSuggestions: true,
            autocorrect: true,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Please enter your email",
            ),
            controller: _email,
          ),
          TextField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: "enter your password"),
            controller: _password,
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: password);
                print(userCredential);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak password') {
                  print('weak password');
                } else if (e.code ==
                    'The email address is already in use by another account') {
                  print('this email is all ready is in used ');
                } else if (e.code == 'invalid-email') {
                  print('this email is not in acceptble formate ');
                }
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login/',
                (route) => false,
              );
            },
            child: const Text('Already Register Login herer'),
          ),
        ],
      ),
    );
  }
}
