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

  late FocusNode focusNode;
  bool currentState = false;

  @override
  void initState() {
    focusNode = FocusNode();
    focusNode.addListener(() {
      setState(() {
        currentState = !currentState;
      });
    });
    super.initState();
  }

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
          height: 3,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(23),
            border: Border.all(
              width: 8,
              //TODO add on hover effect.
              color: currentState == true
                  ? Colors.blue.withOpacity(.2)
                  : Colors.white,
            ),
          ),
          child: TextFormField(
            focusNode: focusNode,
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
              fillColor: currentState == true
                  ? Colors.white
                  : Colors.grey.withOpacity(.2),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 2),
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
            // decoration: InputDecoration(
            //   border: OutlineInputBorder(
            //     borderSide: const BorderSide(
            //       color: Colors.blue,
            //     ),
            //     borderRadius: BorderRadius.circular(15.0),
            //   ),
            //   suffixIcon: GestureDetector(
            //     child: obscureIcon,
            //     onTap: () {
            //       changeObscureText();
            //     },
            //   ),
            //   hintText: 'min 8 characters',
            // ),
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
        ),
      ],
    );
  }
}
