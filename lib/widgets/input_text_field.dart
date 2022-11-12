import 'package:flutter/material.dart';
import '../style/theme.dart';

class InputTextField extends StatefulWidget {
  const InputTextField({
    Key? key,
    required TextEditingController email,
    required this.lable,
  })  : _email = email,
        super(key: key);

  final TextEditingController _email;
  final String lable;

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.lable,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: appThemeData().primaryColor, width: 1),
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
