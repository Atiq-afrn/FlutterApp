import 'package:flutter/material.dart';
import 'package:myfrstapp/Utilites/dialog/genric_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: 'an error occured ',
    content: text,
    optionBuilder: () => {
      'OK': null,
    },
  );
}
