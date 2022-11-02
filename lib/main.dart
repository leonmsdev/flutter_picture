// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learn_dart/firebase_options.dart';
import 'package:learn_dart/screens/login_screen.dart';
import 'package:learn_dart/screens/register_screen.dart';

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

            return const LoginScreen(title: 'Login');
          //   if (user?.emailVerified ?? false) {
          //     return const Text('Done');
          //   } else {
          //     return VerifyEmailScreen(auth: auth);
          //   }

          default:
            return const Center(child: Text('something went wrong'));
        }
      },
    );
  }
}
