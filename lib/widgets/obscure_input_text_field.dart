import 'package:flutter/material.dart';
import 'package:learn_dart/style/theme.dart';

class ObscureTextFormField extends StatefulWidget {
  const ObscureTextFormField({
    Key? key,
    required TextEditingController password,
    required this.onChanged,
  })  : _password = password,
        super(key: key);

  final TextEditingController _password;
  final void Function(String)? onChanged;

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
        const Text(
          'Choose a password',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.grey.withOpacity(.2),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: appThemeData().primaryColor,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: appThemeData().primaryColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: GestureDetector(
                child: obscureIcon,
                onTap: () {
                  changeObscureText();
                },
              ),
            ),
            hintText: 'Choose your password',
            hintStyle: const TextStyle(fontSize: 14),
          ),
          style: const TextStyle(fontSize: 14),
          controller: widget._password,
          obscureText: obscureText,
          autocorrect: false,
          onChanged: widget.onChanged,
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
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }
}
