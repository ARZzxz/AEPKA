import 'package:flutter/material.dart';
import 'homepage.dart';
import 'moral_page.dart';
import 'profile.dart'; // Import file profile.dart
import 'login.dart';
import 'package:nes_ui/nes_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AEPKA', 
      theme: flutterNesTheme(), // Atur tema menggunakan flutterNesTheme()
      initialRoute: '/login', // Set initial route to login page
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/moral': (context) => MoralPage(),
      },
    );
  }
}
