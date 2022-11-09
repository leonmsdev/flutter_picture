import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:learn_dart/constants/routes.dart';
import 'package:learn_dart/services/auth/auth_service.dart';
import 'package:learn_dart/services/auth/auth_user.dart';
import 'package:learn_dart/widgets/border_button.dart';
import 'package:learn_dart/widgets/filled_button.dart';

class VerifyScreen extends StatelessWidget {
  const VerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Check you email'),
            const SizedBox(
              height: 5,
            ),
            const Text('We sent a verification link to'),
            const SizedBox(
              height: 25,
            ),
            Text(
              AuthService.firebase().email.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 25,
            ),
            BorderButton(
                lable: 'Resent verification',
                onTap: () async {
                  await AuthService.firebase().sendEmailVerification();
                },
                width: 200,
                height: 40),
            const SizedBox(
              height: 25,
            ),
            FilledButton(
                lable: 'Start sign in',
                onTap: () async {
                  await AuthService.firebase().signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(signInRoute, (route) => false);
                },
                width: 200,
                height: 40),
          ],
        ),
      ),
    );
  }
}
