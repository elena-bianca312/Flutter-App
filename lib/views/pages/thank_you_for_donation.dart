import 'package:flutter/material.dart';
import 'package:myproject/styles/styles.dart';
import 'package:myproject/widgets/background_image.dart';

class ThankYouView extends StatelessWidget {
  const ThankYouView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent.withOpacity(0.3),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  const Text(
                    'Thank you for your donation!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Your donation will be used to help those in need.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 300),
                  TextButton(
                    child: const Text('Go Back To Shelters', style: TextStyle(fontSize: 20, color: kCustomBlue, decoration: TextDecoration.underline)),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => Navigator.of(context).canPop() == false);
                    },
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}