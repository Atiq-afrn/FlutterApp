import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myfrstapp/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart'; // its used for the firebse authentiction of the user login
//import 'package:myfrstapp/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        appBar: AppBar(title: const Text("Login")),
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
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
                      decoration: const InputDecoration(
                          hintText: "enter your password"),
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
                          if (e.code == 'User is not found') {
                            print('User is not found');
                          } else if (e.code == 'Wrong-password') {
                            print('Wrong password');
                          }
                        }
                      },
                      child: const Text("Login"),
                    )
                  ],
                );
              default:
                return const Text(
                    'Loading...'); // loading screen when internet connection is not good
            }
          },
        ));
  }
}
