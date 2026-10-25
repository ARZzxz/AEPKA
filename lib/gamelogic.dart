import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class GameLogicPage extends StatefulWidget {
  @override
  _GameLogicPageState createState() => _GameLogicPageState();
}

class _GameLogicPageState extends State<GameLogicPage> {
  int _correctAnswers = 0;
  int _playingTimeSeconds = 0;

  void _submitAnswers() {
    // Hitung exp berdasarkan jawaban yang benar
    int expFromAnswers = _correctAnswers * 100;

    // Hitung exp berdasarkan waktu bermain
    int expFromPlayingTime = (_playingTimeSeconds / 60).round() * 100;

    // Total exp
    int totalExp = expFromAnswers + expFromPlayingTime;

    // Simpan total exp ke Firebase Realtime Database
    DatabaseReference expRef = FirebaseDatabase.instance.reference().child('users').child('userId').child('exp');
    expRef.set(totalExp);

    // Reset nilai jawaban dan waktu bermain
    setState(() {
      _correctAnswers = 0;
      _playingTimeSeconds = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Logic'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Jawaban Benar: $_correctAnswers'),
            SizedBox(height: 20),
            Text('Waktu Bermain: $_playingTimeSeconds detik'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitAnswers,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
