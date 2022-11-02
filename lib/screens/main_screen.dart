import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Logged in'),
        TextButton(
          onPressed: () {
            print('log out');
          },
          child: const Text('Log out'),
        )
      ],
    );
  }
}
