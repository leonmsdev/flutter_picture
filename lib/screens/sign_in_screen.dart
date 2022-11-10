// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:learn_dart/constants/routes.dart';
import 'package:learn_dart/screens/register_screen.dart';
import 'package:learn_dart/services/auth/auth_exceptions.dart';
import 'package:learn_dart/services/auth/auth_service.dart';
import 'package:learn_dart/widgets/filled_button.dart';
import 'package:learn_dart/widgets/input_text_field.dart';
import 'package:learn_dart/widgets/obscure_input_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
        title: const Text('Sign In'),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
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
                  FilledButton(
                      lable: 'Sign in',
                      onTap: () async {
                        //show data if form is valid
                        if (_formKey.currentState!.validate()) {
                          final email = _email.text;
                          final password = _password.text;

                          try {
                            await AuthService.firebase().signIn(
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
                                ),
                              ),
                            );
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                homeRoute, (_) => false);
                          } on UserNotFoundAuthException {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: SizedBox(
                                    height: 18,
                                    child: Center(
                                        child: Text(
                                            'Your email is not registered!')),
                                  )),
                            );
                          } on WrongPasswordAuthException {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: SizedBox(
                                  height: 18,
                                  child: Center(child: Text('Wrong password.')),
                                ),
                              ),
                            );
                          } on GenericAuthException {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: SizedBox(
                                  height: 18,
                                  child: Center(
                                      child:
                                          Text('Auth Error try again later.')),
                                ),
                              ),
                            );
                          } on ToManyRequestsAuthException {
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
                          }
                        }
                      },
                      width: 100,
                      height: 40),
                  const SizedBox(
                    height: 50,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ));
                    },
                    child: RichText(
                      text: const TextSpan(children: [
                        TextSpan(
                          text: 'Don\'t have an account?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                            text: ' Sign up for free',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ))
                      ]),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
