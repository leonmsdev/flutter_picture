import 'package:flutter/material.dart';
import 'package:learn_dart/widgets/border_button.dart';
import 'package:learn_dart/widgets/filled_button.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out ?'),
        actions: [
          FilledButton(
            lable: 'Close',
            onTap: () {
              Navigator.of(context).pop(false);
            },
            width: 100,
            height: 40,
          ),
          BorderButton(
            lable: 'Sign out',
            onTap: () {
              Navigator.of(context).pop(true);
            },
            width: 100,
            height: 40,
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
