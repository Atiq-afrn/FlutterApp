import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfrstapp/Utilites/show_error_dialog.dart';
import 'package:myfrstapp/constants/routes.dart';
//import 'dart:developer' as Devtools show log;
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
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email, password: password);
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                if (context.mounted) {
                  Navigator.of(context).pushNamed(verifyemailRoutes);
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak password') {
                  if (context.mounted) {
                    await showErrorDialog(
                      context,
                      'Weak Password',
                    );
                  }
                } else if (e.code == 'email is already in use') {
                  if (context.mounted) {
                    await showErrorDialog(context, 'email is already in use');
                  }
                } else if (e.code == 'invalid-email') {
                  if (context.mounted) {
                    await showErrorDialog(context, 'invalid email');
                  }
                } else {
                  if (context.mounted) {
                    await showErrorDialog(
                      context,
                      ',${e.code}',
                    );
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
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoutes,
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
