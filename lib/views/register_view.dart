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

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        if (state is AuthStateRegistering) {
          if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email already in use.');
          } else if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak password.');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'This is an invalid email address.');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'An error occurred. Please try again later.');
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
                              'Register',
                              style: kHeading,
                            ),
                          ),
                        )
                      ),
                    ),
                    FadeAnimation(1, Axis.horizontal,
                      TextInput(
                        icon: FontAwesomeIcons.solidEnvelope,
                        hint: 'Email',
                        inputType: TextInputType.emailAddress,
                        inputAction: TextInputAction.next,
                        controller: _emailController,
                        enableSuggestions: false,
                        autocorrect: false,
                      )
                    ),
                    FadeAnimation(1.8, Axis.horizontal,
                      TextInput(
                        icon: FontAwesomeIcons.lock,
                        hint: 'Password',
                        inputAction: TextInputAction.done,
                        controller: _passwordController,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                      )
                    ),
                    // TextInput(
                    //   icon: FontAwesomeIcons.lock,
                    //   hint: 'Re-enter password',
                    //   inputAction: TextInputAction.done,
                    //   controller: _passwordController,
                    //   obscureText: true,
                    //   enableSuggestions: false,
                    //   autocorrect: false,
                    // ),
                    const SizedBox(
                      height: 120,
                    ),
                    Center(
                      child: Column(
                        children: [
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
                                context.read<AuthBloc>().add(AuthEventRegister(email, password));
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 6.0),
                                child: Text(
                                  'Register',
                                  style: kBodyText,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(const AuthEventLogout());
                            },
                            child: const FadeAnimation(1.5, Axis.horizontal,
                              Text(
                                'Already registered? Login here',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
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
