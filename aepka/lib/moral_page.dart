import 'package:flutter/material.dart';
import 'game_moral.dart'; // Impor file game_moral.dart

class MoralPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Simulasi Moral'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selamat datang di Game Simulasi Moral',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman game
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GamePage()), // Navigasi ke GamePage
                );
              },
              child: Text('Mulai Game'),
            ),
          ],
        ),
      ),
    );
  }
}
