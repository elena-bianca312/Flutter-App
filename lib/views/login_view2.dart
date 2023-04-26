import 'package:flutter/material.dart';
import 'package:myproject/styles/styles.dart';
import 'package:myproject/widgets/text_input.dart';
import 'package:myproject/widgets/rounded_button.dart';
import 'package:myproject/widgets/password_input.dart';
import 'package:myproject/animation/fade_animation.dart';
import 'package:myproject/widgets/background_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: SafeArea(
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
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            TextInput(
                              icon: FontAwesomeIcons.solidEnvelope,
                              hint: 'Email',
                              inputType: TextInputType.emailAddress,
                              inputAction: TextInputAction.next,
                            ),
                            PasswordInput(
                              icon: FontAwesomeIcons.lock,
                              hint: 'Password',
                              inputAction: TextInputAction.done,
                            ),
                            Text(
                              'Forgot Password?',
                              style: kBodyText,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 120,
                            ),
                            const FadeAnimation(1.5, Axis.horizontal, RoundedButton(
                              buttonText: 'Login',
                            )),
                            const SizedBox(
                              height: 40,
                            ),
                            FadeAnimation(1.5, Axis.horizontal,
                              Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                  bottom:
                                      BorderSide(color: Colors.white, width: 1),
                                )),
                                child: const Text(
                                  'CreateNewAccount',
                                  style: kBodyText,
                                ),
                              )
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}