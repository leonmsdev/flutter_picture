import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key, required this.auth});

  final FirebaseAuth auth;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = widget.auth;
    final User? user = auth.currentUser;

    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  const TextSpan(text: 'Please verify your email address\n\n'),
                  TextSpan(
                      text: user?.email,
                      style: const TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                await user?.sendEmailVerification();
                // TODO: Log off user for relogin after successful email verification.
              },
              child: const Text('Send email verification'),
            )
          ],
        ),
      ),
    );
  }
}
