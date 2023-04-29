import 'package:flutter/widgets.dart';
import 'package:myproject/utilities/dialogs/generic_dialog.dart';

Future<bool> showCannotSaveIncompleteShelterInfoDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Cannot save shelter info",
    content: "Please fill in the title and address fields before saving.",
    optionsBuilder: () => {
      'Continue': true,
      'Discard': false,
    },
  ).then((value) => value ?? false); // If the user clicks outside the dialog window, return false
}