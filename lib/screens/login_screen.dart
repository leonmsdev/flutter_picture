// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learn_dart/firebase_options.dart';
import 'package:learn_dart/widgets/input_text_field.dart';
import 'package:learn_dart/widgets/obscure_input_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});

  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  final _formKey = GlobalKey<FormState>();

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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: FutureBuilder(
            future: Firebase.initializeApp(
                options: DefaultFirebaseOptions.currentPlatform),
            builder: (context, snapshot) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InputTextField(email: _email),
                    const SizedBox(height: 30),
                    ObscureTextFormField(
                      password: _password,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () async {
                        //show data if form is valid
                        if (_formKey.currentState!.validate()) {
                          final email = _email.text;
                          final password = _password.text;

                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  backgroundColor: Colors.greenAccent.shade400,
                                  content: const SizedBox(
                                    height: 18,
                                    child: Center(
                                      child: Text(
                                        'Logged in',
                                      ),
                                    ),
                                  )),
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: SizedBox(
                                      height: 18,
                                      child: Center(
                                          child: Text(
                                              'Your email is not registered.')),
                                    )),
                              );
                            } else if (e.code == 'wrong-password') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: SizedBox(
                                    height: 18,
                                    child:
                                        Center(child: Text('Wrong password.')),
                                  ),
                                ),
                              );
                            } else if (e.code == 'too-many-requests') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.orangeAccent,
                                  content: SizedBox(
                                    height: 18,
                                    child: Center(
                                        child: Text(
                                            'To many request, please try again later.')),
                                  ),
                                ),
                              );
                            } else {
                              String errorMessage = e.code;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: SizedBox(
                                    height: 18,
                                    child: Center(
                                      child: RichText(
                                        text: TextSpan(children: [
                                          const TextSpan(
                                            text: '⚠️',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const TextSpan(
                                              text: ' Something went wrong: '),
                                          TextSpan(
                                            text: errorMessage,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ]),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                        }
                      },
                      child: const Text('Login'),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
