import 'package:flutter/material.dart';
import 'package:myfrstapp/Services/auth/auth_service.dart';
import 'package:myfrstapp/Views/register_view.dart';
import 'package:myfrstapp/Views/login_view.dart';
import 'package:myfrstapp/Views/notes_view.dart';
import 'package:myfrstapp/constants/routes.dart';
import 'package:myfrstapp/Views/Verify_email_view.dart';

// its used for the firebse authentiction of the user login

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: "Prototype",
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const HomePage(),
      routes: {
        loginRoutes: (context) => const LoginView(),
        registerRoutes: (context) => const RegisterView(),
        notesRoutes: (context) => const NotesView(),
        verifyemailRoutes: (context) => const VerifyemailView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuhtService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuhtService.firebase().currentUser;

            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyemailView();
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
