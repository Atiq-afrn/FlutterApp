import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myfrstapp/Utilites/show_error_dialog.dart';
//import 'package:myfrstapp/Utilites/show_error_dialog.dart';

//import 'dart:developer' as devtools show log;

import 'package:myfrstapp/constants/routes.dart';

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
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
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
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final user = FirebaseAuth.instance.currentUser;
                if (user?.emailVerified ?? false) {
                  // user's  email is verified
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoutes,
                      (route) => false,
                    );
                  }
                } else {
                  // user's is not verified
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyemailRoutes,
                      (route) => false,
                    );
                  }
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'User is not found') {
                  if (context.mounted) {
                    await showErrorDialog(
                      context,
                      'User not found',
                    );
                  }
                  // print('user not exist');
                } else if (e.code == 'Wrong-password') {
                  if (context.mounted) {
                    await showErrorDialog(
                      context,
                      'Wrong credential',
                    );
                  } else {
                    if (context.mounted) {
                      await showErrorDialog(
                        context,
                        'Error: ${e.code}',
                      );
                    }
                  }
                }
              } catch (e) {
                if (context.mounted) {
                  await showErrorDialog(
                    context,
                    e.toString(),
                  );
                }
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoutes,
                (route) => false,
              );
            },
            child: const Text('Not Registered yet. Register here'),
          ),
        ],
      ),
    );
  }
}
