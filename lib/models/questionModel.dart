import 'dart:convert';

//import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class Question {
  String question;
  Map<String, dynamic> answers;
  Question({this.question, this.answers});
  factory Question.fromJson(Map<String, dynamic> json) => Question(
        question: json["question"],
        answers: json["answers"],
      );
}

Future<List<Question>> getQuetions() async {
  /* final response = await http.get(
    Uri.parse('http://192.168.0.167:5555/api/quiz'),
  );
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    List<Question> question = [];
    for (var u in jsonResponse) {
      Question user = Question(question: u['question'], answers: u['answers']);

      question.add(user);
    }
    return question;
  } else {
    throw Exception('Failed to load post');
  } */
  Dio dio = new Dio();
  List<Question> questions = [];

  try {
    await dio
        .get(
          'http://192.168.1.21:5555/api/quiz',
        )
        .then((value) => {
              for (var quiz in value.data)
                {
                  print(quiz),
                  questions.add(
                    new Question(
                        question: quiz['question'], answers: quiz['answers']),
                  )
                }
            });
    return questions;
  } on DioError catch (e) {
    print(e);
  }
  return questions;
}
