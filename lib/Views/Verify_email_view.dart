import 'package:flutter/material.dart';
import 'package:myfrstapp/Services/auth/auth_service.dart';
import 'package:myfrstapp/constants/routes.dart';

class VerifyemailView extends StatefulWidget {
  const VerifyemailView({Key? key}) : super(key: key);

  @override
  State<VerifyemailView> createState() => __VerifyemailViewState();
}

class __VerifyemailViewState extends State<VerifyemailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
      ),
      body: Column(children: [
        const Text(
            "We've  already sent email verification link open to verify your account"),
        const Text(
            'If you have not recieve email verifucation yet press below.'),
        TextButton(
          onPressed: () async {
            await AuthService.firebase().sendEmailVerification();
          },
          child: const Text('Send email verification'),
        ),
        TextButton(
          onPressed: () async {
            await AuthService.firebase().logOut();
            if (context.mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoutes,
                (route) => false,
              );
            }
          },
          child: const Text('Restart'),
        )
      ]),
    );
  }
}
