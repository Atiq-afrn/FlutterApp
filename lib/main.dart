import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myfrstapp/Views/Register_View.dart';
import 'package:myfrstapp/Views/login_view.dart';
import 'package:myfrstapp/firebase_options.dart';
// its used for the firebse authentiction of the user login

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MaterialApp(
      title: "Prototype",
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const HomePage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) if (user.emailVerified) {
              print('Email is verified');
            } else {
              return const _VerifyemailView();
            }
            else {
              return const LoginView();
            }
            return const Text('Done');

            // if (user?.emailVerified ?? false) {
            //   return const Text('Done');
            // } else {
            //   return const _VerifyemailView();
            // }
            return const LoginView();

          default:
            return const CircularProgressIndicator(); // loading screen when internet connection is not good
        }
      },
    );
  }
}
