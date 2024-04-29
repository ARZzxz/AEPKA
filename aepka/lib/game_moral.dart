import 'package:flutter/material.dart';

class GameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tebak-Tebakan Game',
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String question =
      'Saat ibu sedang mengecat tembok rumah, kita sebagai anak harus....';
  String answer = '';
  String correctAnswer = 'A';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tebak-Tebakan Game'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/gamebg/gbg_1.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 40,
            right: 40,
            top: 40,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 55, 55, 55).withOpacity(0.7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    question,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 40,
            right: 40,
            bottom: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildAnswerButton('A', 'Membantu', Colors.black), 
                SizedBox(height: 10),
                buildAnswerButton('B', 'Bermain bersama Teman', Colors.black),
                SizedBox(height: 10),
                buildAnswerButton('C', 'Pura-pura tidak melihat', Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAnswerButton(String choice, String choiceFeedback, Color color) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          answer = choice;
          if (answer == correctAnswer) {
            _showDialog('Jawaban Benar!', Colors.green);
          } else {
            _showDialog('Jawaban Salah!', Colors.red);
          }
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        foregroundColor: MaterialStateProperty.all<Color>(color),
      ),
      child: Column(
        children: [
          Text(
            choice,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 5),
          Text(
            choiceFeedback,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showDialog(String message, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            message,
            style: TextStyle(color: color),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
