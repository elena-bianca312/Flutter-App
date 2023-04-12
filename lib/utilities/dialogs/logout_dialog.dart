import 'package:flutter/widgets.dart';
import 'package:myproject/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Log out",
    content: "Are you sure you want to logout?",
    optionsBuilder: () => {
      'Logout': true,
      'Cancel': false,
    },
  ).then((value) => value ?? false); // If the user clicks outside the dialog window, return false
}