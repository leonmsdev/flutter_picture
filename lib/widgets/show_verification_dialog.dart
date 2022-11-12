import 'package:flutter/material.dart';
import 'package:learn_dart/services/auth/auth_exceptions.dart';
import 'package:learn_dart/widgets/filled_button.dart';
import 'package:lottie/lottie.dart';
import 'dart:developer' as devtools show log;

import '../services/auth/auth_service.dart';

Future showLVerificationDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        titlePadding: const EdgeInsets.only(top: 25),
        contentPadding: const EdgeInsets.symmetric(horizontal: 25),
        actionsPadding: const EdgeInsets.only(bottom: 25, top: 25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        title: const Center(
          child: Text('Check your email'),
        ),
        content: SizedBox(
          height: 168,
          child: Column(
            children: [
              Lottie.network(
                'https://assets9.lottiefiles.com/packages/lf20_9n1h4nww.json',
                width: 130,
                repeat: false,
              ),
              const Text('We sent a verification link to:'),
              Text(
                AuthService.firebase().email.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          Center(
            child: FilledButton(
              lable: 'Sign in',
              onTap: () async {
                final user = AuthService.firebase().currentUser;
                try {
                  if (user?.isEmailVerified ?? false) {
                    devtools.log('is true');
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  } else {
                    devtools.log("Is not verified");
                  }
                } on GenericAuthException {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to register try again later.'),
                    ),
                  );
                }
              },
              width: 100,
              height: 40,
            ),
          ),
        ],
      );
    },
  );
}
