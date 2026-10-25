import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'quiz_question.dart';
import 'exp_calculator.dart';
import 'dart:math'; // Import for shuffling

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<QuizQuestion> _questions = [];
  final ExpCalculator _expCalculator = ExpCalculator(); // Create an instance of ExpCalculator
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now(); // Initialize start time
    _loadQuestionsFromFirebase();
  }

  void _loadQuestionsFromFirebase() async {
    DatabaseReference questionsRef = FirebaseDatabase.instance.ref('questions');
    DatabaseEvent event = await questionsRef.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      Map<dynamic, dynamic> questionsMap = snapshot.value as Map<dynamic, dynamic>;
      List<QuizQuestion> loadedQuestions = [];

      questionsMap.forEach((key, value) {
        QuizQuestion question = QuizQuestion(
          question: value['question'],
          options: List<String>.from(value['options']),
          correctOptionIndex: value['correctOptionIndex'],
          backgroundImage: value['backgroundImage'],
        );
        loadedQuestions.add(question);
      });

      // Shuffle the list of questions
      loadedQuestions.shuffle(Random());

      setState(() {
        _questions = loadedQuestions;
      });
    }
  }

  void _submitAnswer(int selectedOptionIndex) {
    if (selectedOptionIndex == _questions[_currentQuestionIndex].correctOptionIndex) {
      setState(() {
        _score++;
      });
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    int expGained = _score * 100; // Example calculation for gained EXP

    DateTime endTime = DateTime.now();
    Duration playingTime = endTime.difference(_startTime);
    int playingTimeInSeconds = playingTime.inSeconds;

    try {
      // Save quiz result to Firestore
      await users.doc(userId).collection('quizResults').add({
        'score': _score,
        'totalQuestions': _questions.length,
        'expGained': expGained,
        'playingTime': playingTimeInSeconds,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update EXP and playing time in Realtime Database and Firestore using ExpCalculator
      await _expCalculator.updateUserExp(userId, expGained, playingTimeInSeconds);
      print("Quiz result and EXP successfully updated");

      // Show result dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Quiz Completed'),
          content: Text('Your score is $_score out of ${_questions.length}\nYou gained $expGained EXP.\nPlaying time: $playingTimeInSeconds seconds.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Navigate back to the previous page
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Error updating quiz result or EXP: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error saving quiz result. Please try again."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tebak-Tebakan Game'),
      ),
      body: _questions.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    _questions[_currentQuestionIndex].backgroundImage,
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
                          _questions[_currentQuestionIndex].question,
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
                    children: _questions[_currentQuestionIndex].options
                        .asMap()
                        .entries
                        .map((entry) {
                      int idx = entry.key;
                      String option = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: ElevatedButton(
                          onPressed: () => _submitAnswer(idx),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 201, 90, 36).withOpacity(0.7),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(option),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }
}
