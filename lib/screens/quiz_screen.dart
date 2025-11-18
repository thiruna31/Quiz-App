import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/api_service.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _loading = true;
  bool _answered = false;
  String _feedback = "";

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final data = await ApiService.fetchQuestions();
    setState(() {
      _questions = data;
      _loading = false;
    });
  }

  void checkAnswer(String selected) {
    final correct = _questions[_currentIndex].correctAnswer;
    setState(() {
      _answered = true;

      if (selected == correct) {
        _score++;
        _feedback = "Correct! Answer: $correct";
      } else {
        _feedback = "Incorrect. Correct Answer: $correct";
      }
    });
  }

  void nextQuestion() {
    setState(() {
      _currentIndex++;
      _answered = false;
      _feedback = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_currentIndex >= _questions.length) {
      return Scaffold(
        body: Center(
          child: Text(
            "Quiz Finished!\nScore: $_score / ${_questions.length}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22),
          ),
        ),
      );
    }

    final q = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Quiz App")),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Question ${_currentIndex + 1}/${_questions.length}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              q.question,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),

            ...q.options.map((opt) {
              return ElevatedButton(
                onPressed: _answered ? null : () => checkAnswer(opt),
                child: Text(opt),
              );
            }),

            SizedBox(height: 20),

            if (_answered)
              Text(
                _feedback,
                style: TextStyle(
                  fontSize: 18,
                  color: _feedback.startsWith("Correct")
                      ? Colors.green
                      : Colors.red,
                ),
              ),

            if (_answered)
              ElevatedButton(
                onPressed: nextQuestion,
                child: Text("Next Question"),
              )
          ],
        ),
      ),
    );
  }
}
