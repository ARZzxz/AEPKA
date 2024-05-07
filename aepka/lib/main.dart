import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'moral_page.dart';
import 'profile.dart'; // Import file profile.dart
import 'login.dart';
import 'package:nes_ui/nes_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      appId: "1:702988744727:android:f5ca2e26d9c2e502648452",
      apiKey: "AIzaSyDg8aDZ97HEBbV2XoOQyMgGM0LAJwCBZuM",
      projectId: "paswan-a8f8e",
      messagingSenderId: "702988744727",
      storageBucket: "paswan-a8f8e.appspot.com",
    ),
  );
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
