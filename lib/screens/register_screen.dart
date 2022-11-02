// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learn_dart/firebase_options.dart';

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
  Color specialCharValid = notvalidColor;
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
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                ),
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                enableSuggestions: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    child: obscureIcon,
                    onTap: () {
                      changeObscureText();
                    },
                  ),
                  hintText: 'Enter your password',
                ),
                controller: _password,
                obscureText: obscureText,
                autocorrect: false,
                enableSuggestions: false,
                onChanged: (value) {
                  setState(() {
                    value.contains(RegExp(r'[a-z]'))
                        ? lowerLetterValid = validColor
                        : lowerLetterValid = Colors.black;
                    value.contains(RegExp(r'[A-Z]'))
                        ? upperLetterValid = validColor
                        : upperLetterValid = Colors.black;
                    value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))
                        ? specialCharValid = validColor
                        : specialCharValid = Colors.black;
                    value.length >= 8
                        ? lengthValid = validColor
                        : lengthValid = Colors.black;
                  });
                },
                validator: (value) {
                  // Lowercase, Uppercase, Special Char, 8+ Characters
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 8) {
                    return 'Your password has to be at least 8 char long';
                  } else if (!value.contains(RegExp(r'[a-z]'))) {
                    return 'Please add a lowercase char to your password';
                  } else if (!value.contains(RegExp(r'[A-Z]'))) {
                    return 'Please add a uppercase char to your password';
                  } else if (!value
                      .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                    return 'Please add a special char to your password';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              PasswordValidationItems(
                  lowerLetterValid: lowerLetterValid,
                  upperLetterValid: upperLetterValid,
                  specialCharValid: specialCharValid,
                  lengthValid: lengthValid),
              TextButton(
                onPressed: () async {
                  //show data if form is valid
                  if (_formKey.currentState!.validate()) {
                    final email = _email.text;
                    final password = _password.text;

                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'email-already-in-use') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'The account already exists for that email.')),
                        );
                      } else {
                        print(e.code);
                      }
                    }
                  }
                },
                child: const Text('Register'),
              ),
              const SizedBox(
                height: 50,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Already registred? Login here!'),
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
    required this.specialCharValid,
    required this.lengthValid,
  }) : super(key: key);

  final Color lowerLetterValid;
  final Color upperLetterValid;
  final Color specialCharValid;
  final Color lengthValid;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              '#',
              style: TextStyle(
                  color: specialCharValid,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Special',
              style: TextStyle(
                color: specialCharValid,
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
