// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:learn_dart/services/auth/auth_exceptions.dart';
import 'dart:developer' as devtools show log;

import 'package:learn_dart/services/auth/auth_service.dart';
import 'package:learn_dart/widgets/filled_button.dart';
import 'package:learn_dart/widgets/input_text_field.dart';
import 'package:learn_dart/widgets/obscure_input_text_field.dart';

import '../widgets/show_verification_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  final _formKey = GlobalKey<FormState>();

  static const validColor = Colors.blue;
  static const notvalidColor = Color(0xff000000);
  Color lowerLetterValid = notvalidColor;
  Color upperLetterValid = notvalidColor;
  Color lengthValid = notvalidColor;

  bool obscureText = true;
  Icon obscureIcon = const Icon(Icons.visibility_outlined);

  void changeObscureText() {
    setState(() {
      if (obscureText == true) {
        obscureText = false;
        obscureIcon = const Icon(Icons.visibility_off_outlined);
      } else {
        obscureText = true;
        obscureIcon = const Icon(Icons.visibility_outlined);
      }
    });
  }

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthService.firebase().initialize();
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Center(
            child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InputTextField(lable: "Email address:", email: _email),
              const SizedBox(height: 30),
              ObscureTextFormField(
                password: _password,
                onChanged: (value) {
                  setState(() {
                    value.contains(RegExp(r'[a-z]'))
                        ? lowerLetterValid = validColor
                        : lowerLetterValid = Colors.black;
                    value.contains(RegExp(r'[A-Z]'))
                        ? upperLetterValid = validColor
                        : upperLetterValid = Colors.black;
                    value.length >= 8
                        ? lengthValid = validColor
                        : lengthValid = Colors.black;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              PasswordValidationItems(
                  lowerLetterValid: lowerLetterValid,
                  upperLetterValid: upperLetterValid,
                  lengthValid: lengthValid),
              const SizedBox(height: 30),
              FilledButton(
                  lable: 'Register',
                  onTap: () async {
                    //show data if form is valid
                    if (_formKey.currentState!.validate()) {
                      final email = _email.text;
                      final password = _password.text;

                      try {
                        await AuthService.firebase().createUser(
                          email: email,
                          password: password,
                        );
                        try {
                          await AuthService.firebase().sendEmailVerification();
                          showLVerificationDialog(context);
                        } on EmailAlreadyInUseAuthException {
                          devtools.log('Email already in use');
                        }
                      } on EmailAlreadyInUseAuthException {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'The account already exists for that email.'),
                          ),
                        );
                      } on InvalidEmailAuthException {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Your email is not valid.'),
                          ),
                        );
                      } on GenericAuthException {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Failed to register try again later.'),
                          ),
                        );
                      }
                    }
                  },
                  width: 100,
                  height: 40),
              const SizedBox(height: 50),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Already registred? Sign in here!'),
              )
            ],
          ),
        )),
      ),
    );
  }
}

class PasswordValidationItems extends StatelessWidget {
  const PasswordValidationItems({
    Key? key,
    required this.lowerLetterValid,
    required this.upperLetterValid,
    required this.lengthValid,
  }) : super(key: key);

  final Color lowerLetterValid;
  final Color upperLetterValid;

  final Color lengthValid;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(
              'a',
              style: TextStyle(
                  color: lowerLetterValid,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Lowercase',
              style: TextStyle(
                color: lowerLetterValid,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              'A',
              style: TextStyle(
                  color: upperLetterValid,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Uppercase',
              style: TextStyle(
                color: upperLetterValid,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              '8+',
              style: TextStyle(
                  color: lengthValid,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Characters',
              style: TextStyle(
                color: lengthValid,
              ),
            ),
          ],
        )
      ],
    );
  }
}

Future<bool> showEmailResentDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Send email verification'),
        content: const Text('Please resend email verification'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Resent email verification'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
