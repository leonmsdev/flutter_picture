import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learn_dart/firebase_options.dart';
import 'package:learn_dart/screens/home_screen.dart';
import 'package:learn_dart/screens/sign_in_screen.dart';
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
      home: const MainScreen(),
      routes: {
        '/sign_in/': (context) => const SignInScreen(),
        '/register/': (context) => const RegisterScreen(),
        '/home/': (context) => const HomeScreen(),
      },
    ),
  );
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

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
            /* TODO
            overthink Sign In logic maybe validate 
            email while create account and 
            than later show dialog box in app 
            if email is not validated */
            if (user != null) {
              if (user.emailVerified) {
                return const HomeScreen();
              } else {
                return const SignInScreen();
              }
            } else {
              return const SignInScreen();
            }

          default:
            return const Scaffold(
                body: SizedBox(
                    height: 50, width: 50, child: CircularProgressIndicator()));
        }
      },
    );
  }
}
