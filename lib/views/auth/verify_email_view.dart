import 'package:flutter/material.dart';
import 'package:myproject/styles/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myproject/styles/glass_box.dart';
import 'package:myproject/animation/fade_animation.dart';
import 'package:myproject/widgets/background_image.dart';
import 'package:myproject/services/auth/bloc/auth_bloc.dart';
import 'package:myproject/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                            'Verify Email',
                            style: kHeading,
                          ),
                        ),
                      )
                    ),
                  ),
                  GlassBox(
                    width: 350,
                    height: 240,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: const [
                          SizedBox(
                            height: 20,
                          ),
                          FadeAnimation(1, Axis.horizontal,
                            Text("We've sent you an email with a link to verify your account. Please click on the link to verify your account.",
                              style: kBodyText,)
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          FadeAnimation(1.3, Axis.horizontal,
                            Text("If you don't see the email, press the button below to resend the email.",
                              style: kBodyText,),
                          ),
                        ]
                      ),
                    ),
                  ),
                  // const FadeAnimation(1, Axis.horizontal,
                  //   Text("We've sent you an email with a link to verify your account. Please click on the link to verify your account.",
                  //     style: kBodyText,)
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // const FadeAnimation(1.3, Axis.horizontal,
                  //   Text("If you don't see the email, press the button below to resend the email.",
                  //     style: kBodyText,),
                  // ),
                  const SizedBox(
                    height: 80,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kCustomBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        context.read<AuthBloc>().add(const AuthEventSendEmailVerification());
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          'Resend email verification',
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
    );
  }
}
