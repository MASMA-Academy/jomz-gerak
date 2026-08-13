import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'screen/login_view.dart';
import 'screen/profile_view.dart';
import 'screen/timetable_view.dart';
import 'screen/home_view.dart';
import 'screen/list_station_view.dart';
import 'screen/register_view.dart';
import 'screen/notification_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // ================================================================
  // DATABASE INITIALIZATION
  // ================================================================

  if (kIsWeb) {
    // Flutter Web
    databaseFactory = databaseFactoryFfiWeb;
  } else {
    // Windows / Linux / macOS
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

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

      initialRoute: '/home',

      routes: {
        '/login': (context) => const LoginScreen(),

        '/register': (context) => const RegisterScreen(),

        '/home': (context) => const HomeScreen(),

        '/notifications': (context) => const NotificationScreen(),

        '/profile': (context) => const ProfileScreen(),

        '/timetable': (context) => const TimetableScreen(),

        '/stationlist': (context) => const StationListScreen(),
      },
    );
  }
}
