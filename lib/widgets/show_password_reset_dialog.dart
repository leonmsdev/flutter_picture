import 'package:flutter/material.dart';
import 'package:learn_dart/widgets/filled_button.dart';
import 'package:learn_dart/widgets/input_text_field.dart';

import '../services/auth/auth_service.dart';

Future showPasswordResetnDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        titlePadding: const EdgeInsets.only(top: 25, bottom: 25),
        contentPadding: const EdgeInsets.symmetric(horizontal: 25),
        actionsPadding: const EdgeInsets.only(bottom: 25),
        actions: const [],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        title: const Center(
          child: Text('Reset your password'),
        ),
        content: const ForgotPassword(),
      );
    },
  );
}

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 311,
      child: Column(
        children: [
          const Text(
              'Enter the email address you used when you joined and we’ll send you instructions to reset your password. \n \nFor security reasons, we do NOT store your password. So rest assured that we will never send your password via email.'),
          InputTextField(lable: "", email: _email),
          const SizedBox(
            height: 20,
          ),
          FilledButton(
            lable: 'Reset password',
            onTap: () async {
              final email = _email.text;
              AuthService.firebase().resetPassword(email: email);
              Navigator.of(context).pop();
            },
            width: 200,
            height: 40,
          ),
        ],
      ),
    );
  }
}
