import 'package:flutter/material.dart';
import 'package:myproject/styles/styles.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.buttonText,
  }) : super(key: key);

  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kCustomBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextButton(
        onPressed: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(
            buttonText,
            style: kBodyText,
          ),
        ),
      ),
    );
  }
}