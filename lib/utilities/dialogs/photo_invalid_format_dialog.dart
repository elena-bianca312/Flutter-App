import 'package:flutter/widgets.dart';
import 'package:myproject/utilities/dialogs/generic_dialog.dart';

Future<bool> showPhotoInvalidFormatDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Could not upload photo",
    content: "The image is not invalid. Do you want to save without uploading a reference photo?",
    optionsBuilder: () => {
      'Yes': true,
      'Cancel': false,
    },
  ).then((value) => value ?? false); // If the user clicks outside the dialog window, return false
}