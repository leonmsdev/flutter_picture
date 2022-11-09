// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learn_dart/constants/routes.dart';
import 'package:learn_dart/services/auth/auth_service.dart';
import '../enums/menu_action.dart';
import '../widgets/show_sign_out_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final DateTime currentDate = DateTime.now();
final String formattedDate = DateFormat('EEEE, MMMM d, y').format(currentDate);

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          title: const Text('Home Screen'),
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = showLogOutDialog(context);
                    if (await shouldLogout) {
                      await AuthService.firebase().signOut();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(signInRoute, (_) => false);
                    }
                    break;
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text('Sign out'),
                  )
                ];
              },
            )
          ],
        ),
        body: Container(
          color: const Color(0xffF9F9F9),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                formattedDate,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Todo article name',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        'https://cdn.dribbble.com/userupload/3848564/file/original-146d57aa135b7bfc90114b7055639a0f.png?compress=1&resize=752x'),
                  ),
                ),
                width: double.infinity,
                height: 200,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'Tasks:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ));
  }
}
