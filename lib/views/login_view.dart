import 'package:flutter/material.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/services/auth/auth_exceptions.dart';
import 'package:myproject/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _emailController,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here'
            ),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here'
            ),
          ),
          TextButton(
            onPressed: () async  {
              final email = _emailController.text;
              final password = _passwordController.text;
              try {
                await AuthService.firebase().logIn(email: email, password: password);
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  // user's email is verified
                  if (!mounted) return;
                  Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                } else {
                  // user's email is not verified
                  if (!mounted) return;
                  Navigator.of(context).pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false);
                }
              } on UserNotFoundAuthException {
                await showErrorDialog(context, 'No user found for that email.');
              } on WrongPasswordAuthException {
                await showErrorDialog(context, 'Wrong credentials.');
              } on GenericAuthException {
                await showErrorDialog(context, 'Authentication error.');
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Not registered yet? Register here'),
          )
        ],
      ),
    );
  }
}
