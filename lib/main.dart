import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myfrstapp/Views/Register_View.dart';
import 'package:myfrstapp/Views/login_view.dart';
import 'package:myfrstapp/firebase_options.dart';
import 'dart:developer' as Devtools show log;
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

            if (user != null) {
              if (user.emailVerified) {
                print('My name is Atiq khan');
                return const NotesView();
              } else {
                return const NotesView();
              }
            } else {
              return const LoginView();
            }

          default:
            return const CircularProgressIndicator(); // loading screen when internet connection is not good
        }
      },
    );
  }
}

class VerifyemailView extends StatefulWidget {
  const VerifyemailView({Key? key}) : super(key: key);

  @override
  State<VerifyemailView> createState() => __VerifyemailView();
}

class __VerifyemailView extends State<VerifyemailView> {
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

enum MenuAcion { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          PopupMenuButton<MenuAcion>(
            onSelected: (value) async {
              switch (value) {
                case MenuAcion.logout:
                  final shouldLogout = await showlogOutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login/',
                      (route) => false,
                    );
                  }
                  Devtools.log(shouldLogout.toString());
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAcion>(
                  value: MenuAcion.logout,
                  child: Text('Logout'),
                )
              ];
            },
          )
        ],
      ),
      body: const Text('My name is Atiq khan  and i am a computer engineer'),
    );
  }
}

Future<bool> showlogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sing out'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Logout'),
            )
          ],
        );
      }).then((value) => value ?? false);
}
