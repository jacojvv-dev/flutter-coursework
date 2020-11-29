import 'package:flutter/cupertino.dart';

import 'answer.dart';
import 'question.dart';

class Quiz extends StatelessWidget {
  final List<Map<String, Object>> _questions;
  final int _questionIndex;
  final Function _answerQuestion;

  Quiz(this._questions, this._questionIndex, this._answerQuestion);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Question(_questions[_questionIndex]["questionText"]),
        ...(_questions[_questionIndex]["answers"] as List<Map<String, Object>>)
            .map((answer) => Answer(
                () => {_answerQuestion(answer["score"])}, answer["text"]))
            .toList()
      ],
    );
  }
}
