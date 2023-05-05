import 'package:flutter/material.dart';
import 'package:myproject/styles/styles.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    Key? key,
    this.hint,
    this.inputAction,
    this.icon,
    this.inputType,
    this.controller,
    this.enableSuggestions,
    this.autocorrect,
    this.obscureText,
    this.autofocus,
    this.keyboardType,
    this.maxLines,
    this.width,
    this.height,
  }) : super(key: key);

  final String? hint;
  final TextInputAction? inputAction;
  final TextInputType? inputType;
  final IconData? icon;
  final TextEditingController? controller;
  final bool? enableSuggestions;
  final bool? autocorrect;
  final bool? obscureText;
  final bool? autofocus;
  final TextInputType? keyboardType;
  final int? maxLines;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        width: width ?? 500,
        decoration: BoxDecoration(
          color: Colors.grey[600]?.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,),
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
          autofocus: autofocus ?? false,
          maxLines: maxLines ?? 1,
        ),
      ),
    );
  }
}