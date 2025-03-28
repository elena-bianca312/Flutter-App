import 'package:flutter/material.dart';
import 'package:myproject/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Sharing',
    content: 'Cannot share empty note!',
    optionsBuilder: () => {'OK': null});
}