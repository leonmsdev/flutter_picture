import 'package:flutter/material.dart';
import 'package:learn_dart/constants/routes.dart';
import 'package:learn_dart/screens/verify_screen.dart';
import 'package:learn_dart/services/auth/auth_service.dart';
import 'package:learn_dart/screens/home_screen.dart';
import 'package:learn_dart/screens/sign_in_screen.dart';
import 'package:learn_dart/screens/register_screen.dart';
import 'package:learn_dart/style/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: appThemeData(),
      home: const MainScreen(),
      routes: {
        signInRoute: (context) => const SignInScreen(),
        registerRoute: (context) => const RegisterScreen(),
        homeRoute: (context) => const HomeScreen(),
        verifyRoute: (context) => const VerifyScreen(),
      },
    ),
  );
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
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
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ));
        }
      },
    );
  }
}
