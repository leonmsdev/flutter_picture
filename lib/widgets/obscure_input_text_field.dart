import 'package:flutter/material.dart';

class ObscureTextFormField extends StatefulWidget {
  const ObscureTextFormField({
    Key? key,
    required TextEditingController password,
  })  : _password = password,
        super(key: key);
  final TextEditingController _password;

  @override
  State<ObscureTextFormField> createState() => _ObscureTextFormFieldState();
}

class _ObscureTextFormFieldState extends State<ObscureTextFormField> {
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Choose a password'),
        TextFormField(
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
              child: obscureIcon,
              onTap: () {
                changeObscureText();
              },
            ),
            hintText: 'min 8 characters',
          ),
          controller: widget._password,
          obscureText: obscureText,
          autocorrect: false,
          enableSuggestions: false,
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
            } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
              return 'Please add a special char to your password';
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }
}
