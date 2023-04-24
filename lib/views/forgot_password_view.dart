import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myproject/services/auth/bloc/auth_bloc.dart';
import 'package:myproject/services/auth/auth_exceptions.dart';
import 'package:myproject/services/auth/bloc/auth_event.dart';
import 'package:myproject/services/auth/bloc/auth_state.dart';
import 'package:myproject/utilities/dialogs/error_dialog.dart';
import 'package:myproject/utilities/dialogs/password_reset_email_sent_dialog.dart';
// ignore_for_file: use_build_context_synchronously


class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {

  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetEmailSentDialog(context);
          }
          if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email.');
          } else if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'No user found for that email.');
          } else if (state.exception != null) {
            await showErrorDialog(context, "We couldn't send you an email. Please try again.");
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text('Enter your email address below to reset your password.'),
                TextField(
                  controller: _controller,
                  autofocus: true,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'Enter your email here'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthEventForgotPassword(email: _controller.text));
                  },
                  child: const Text('Send me password reset link'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogout());
                  },
                  child: const Text('Back to login page'),
                ),
              ],
            ),
          ),
        )
    );
  }
}