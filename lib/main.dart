// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learn_dart/firebase_options.dart';
import 'package:learn_dart/screens/login_screen.dart';
import 'package:learn_dart/screens/register_screen.dart';
import 'package:learn_dart/screens/verify_email_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      routes: {
        '/login/': (context) => const LoginScreen(title: 'login Screen'),
        '/register/': (context) => const RegisterScreen(),
      },
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final FirebaseAuth auth = FirebaseAuth.instance;
            final User? user = auth.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                print('Email is verified');
              } else {
                return VerifyEmailScreen(auth: auth);
              }
            } else {
              return const LoginScreen(title: 'Login');
            }
            //Screen that shows after successful login.
            return Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () async {
                    await auth.signOut();
                  },
                  child: const Text('Log out'),
                ),
              ),
            );

          default:
            return const Scaffold(
                body: Center(child: Text('something went wrong')));
        }
      },
    );
  }
}
