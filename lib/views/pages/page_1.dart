import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:myproject/styles/styles.dart';
import 'package:myproject/styles/glass_box.dart';

class Page1 extends StatelessWidget {

  final String text;
  final String animationURL;

  const Page1({
    Key? key,
    required this.text,
    required this.animationURL
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: GlassBox(
          width: 205,
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const SizedBox(height: 100),
              Text(text, style: kPageText, textAlign: TextAlign.center),
              const SizedBox(height: 30),
              Lottie.asset(animationURL, width: 100, height: 100),
            ],
          )
        ),
      ),
    );
  }
}