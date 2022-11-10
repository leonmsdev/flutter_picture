import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class InputTextField extends StatefulWidget {
  const InputTextField({
    Key? key,
    required TextEditingController email,
  })  : _email = email,
        super(key: key);

  final TextEditingController _email;

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text(
            'Email address:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 3,
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
              borderSide: const BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(15),
            ),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(right: 5.0),
              child: Icon(Icons.email_outlined),
            ),
            hintText: 'test.user@gmail.com',
            hintStyle: const TextStyle(
              fontSize: 14,
            ),
          ),
          style: const TextStyle(fontSize: 14),
          controller: widget._email,
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
      ],
    );
  }
}
