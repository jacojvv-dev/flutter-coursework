import "package:flutter/material.dart";
import './quiz.dart';
import 'result.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var _questionIndex = 0;
  var _totalScore = 0;
  static final _questions = const [
    {
      "questionText": "What's your favorite color?",
      "answers": [
        {"text": "Black", "score": 10},
        {"text": "Red", "score": 5},
        {"text": "Green", "score": 3},
        {"text": "White", "score": 1}
      ]
    },
    {
      "questionText": "What's your favorite animal?",
      "answers": [
        {"text": "Rabbit", "score": 1},
        {"text": "Snake", "score": 10},
        {"text": "Lion", "score": 3},
        {"text": "Elephant", "score": 5}
      ]
    },
    {
      "questionText": "What's your favorite letter?",
      "answers": [
        {"text": "X", "score": 10},
        {"text": "Y", "score": 5},
        {"text": "Z", "score": 3},
        {"text": "A", "score": 1}
      ]
    },
  ];

  void _answerQuestion(int score) {
    _totalScore += score;
    setState(() {
      _questionIndex = _questionIndex + 1;
    });
  }

  void _reset() {
    setState(() {
      _questionIndex = 0;
    });
    _totalScore = 0;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("My First App"),
            ),
            body: _questionIndex < _questions.length
                ? Quiz(_questions, _questionIndex, _answerQuestion)
                : Result(_totalScore, _reset)));
  }
}
