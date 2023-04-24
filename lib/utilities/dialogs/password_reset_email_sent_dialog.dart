import 'package:flutter/material.dart';
import 'package:myproject/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetEmailSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Password Reset Email Sent',
    content: 'Please check your email for a link to reset your password.',
    optionsBuilder: () => {
      'OK': null,
    }
  );
}