import 'package:flutter/material.dart';
import 'package:myproject/styles/styles.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    Key? key,
    required this.icon,
    required this.hint,
    required this.inputAction,
    this.inputType,
    this.controller,
    this.enableSuggestions,
    this.autocorrect,
    this.obscureText,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final TextInputAction inputAction;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final bool? enableSuggestions;
  final bool? autocorrect;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[600]?.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            hintStyle: kBodyText,
          ),
          style: kBodyText,
          keyboardType: inputType,
          textInputAction: inputAction,
          controller: controller,
          enableSuggestions: enableSuggestions ?? true,
          autocorrect: autocorrect ?? true,
          obscureText: obscureText ?? false,
        ),
      ),
    );
  }
}