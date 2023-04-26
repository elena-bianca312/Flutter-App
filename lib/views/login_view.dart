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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'No user found for that email.');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong credentials.');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error.');
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
                      child: FadeAnimation(2, Axis.vertical,
                        SizedBox(
                          height: 200,
                          child: Center(
                            child: Text(
                              'Find Shelter App',
                              style: kHeading,
                            ),
                          ),
                        )
                      ),
                    ),
                    TextInput(
                      icon: FontAwesomeIcons.solidEnvelope,
                      hint: 'Email',
                      inputType: TextInputType.emailAddress,
                      inputAction: TextInputAction.next,
                      controller: _emailController,
                      enableSuggestions: false,
                      autocorrect: false,
                    ),
                    TextInput(
                      icon: FontAwesomeIcons.lock,
                      hint: 'Password',
                      inputAction: TextInputAction.done,
                      controller: _passwordController,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: kCustomBlue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          final email = _emailController.text;
                          final password = _passwordController.text;
                          context.read<AuthBloc>().add(AuthEventLogin(email, password));
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(
                            'Login',
                            style: kBodyText,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextButton(
                      onPressed: () async {
                        context.read<AuthBloc>().add(const AuthEventForgotPassword());
                      },
                      child: const FadeAnimation(1.5, Axis.horizontal,
                        Text(
                          'Forgot Password?',
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(const AuthEventShouldRegister());
                      },
                      child: const FadeAnimation(1.5, Axis.horizontal,
                        Text(
                          'Not registered yet? Register here',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    )
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
