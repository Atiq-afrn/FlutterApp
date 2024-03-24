import 'package:flutter/material.dart';
import 'package:myfrstapp/Utilites/dialog/genric_dialog.dart';

Future<bool> showlogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
      context: context,
      title: 'Log out',
      content: 'Are you sure you want to logout',
      optionBuilder: () => {
            'Cancel': false,
            'log out': true,
          }).then((value) => value ?? false);
}
