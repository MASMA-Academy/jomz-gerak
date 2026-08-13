import 'package:flutter/material.dart';

import 'screen/login_view.dart';
import 'screen/profile_view.dart';
// import 'screen/register_view.dart';

void main() {
  runApp(const JomzGerakApp());
}

class JomzGerakApp extends StatelessWidget {
  const JomzGerakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JomzGerak',

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF031636)),
      ),

      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginScreen(),
        '/profile': (context) => const ProfileScreen(isLoggedIn: false),
      },
    );
  }
}
