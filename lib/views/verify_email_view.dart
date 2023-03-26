import 'package:flutter/material.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
      ),
      body: Column(children: [
          const Text("We've sent you an email with a link to verify your account. Please click on the link to verify your account."),
          const Text("If you don't see the email, press the button below to resend the email."),
          TextButton(
            onPressed: () async {
              AuthService.firebase().sendEmailVerification();
            }, child: const Text('Resend email verification')
          ),
          TextButton(
            onPressed:() async {
              await AuthService.firebase().logOut();
              if (!mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
            }, child: const Text('Continue')
          ),
        ]
      ),
    );
  }
}