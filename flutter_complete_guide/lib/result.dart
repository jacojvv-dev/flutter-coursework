import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int _score;
  final Function _reset;

  Result(this._score, this._reset);

  String get resultPhrase {
    String text;
    if (_score <= 8) {
      text = "You are soft!";
    } else if (_score <= 16) {
      text = "You are likeable!";
    } else {
      text = "You are dark!";
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            resultPhrase,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          FlatButton(
            onPressed: _reset,
            child: Text("Restart Quiz!"),
            color: Colors.blue,
            textColor: Colors.white,
          )
        ],
      ),
    );
  }
}
