import 'package:flutter/material.dart';
import 'package:myproject/styles/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myproject/widgets/text_input.dart';
import 'package:myproject/animation/fade_animation.dart';
import 'package:myproject/widgets/background_image.dart';
import 'package:myproject/services/auth/bloc/auth_bloc.dart';
import 'package:myproject/services/auth/auth_exceptions.dart';
import 'package:myproject/services/auth/bloc/auth_event.dart';
import 'package:myproject/services/auth/bloc/auth_state.dart';
import 'package:myproject/utilities/dialogs/error_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      child: Stack(
        children: [
          const BackgroundImage(),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Positioned(
                      child: FadeAnimation(1, Axis.vertical,
                        SizedBox(
                          height: 200,
                          child: Center(
                            child: Text(
                              'Recover Password',
                              style: kHeading,
                            ),
                          ),
                        )
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    FadeAnimation(1, Axis.horizontal,
                      TextInput(
                        icon: FontAwesomeIcons.solidEnvelope,
                        hint: 'Email',
                        inputType: TextInputType.emailAddress,
                        inputAction: TextInputAction.next,
                        controller: _controller,
                        enableSuggestions: false,
                        autocorrect: false,
                      )
                    ),
                    const SizedBox(
                      height: 120,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: kCustomBlue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          context.read<AuthBloc>().add(AuthEventForgotPassword(email: _controller.text));
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(
                            'Send me password reset link',
                            style: kBodyText,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(const AuthEventLogout());
                      },
                      child: const FadeAnimation(1.3, Axis.horizontal,
                        Text(
                          'Back to login page',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}
