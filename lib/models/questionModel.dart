//import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:elite_quiz/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Question {
  String question;
  Map<String, dynamic> answers;
  Question({this.question, this.answers});
  factory Question.fromJson(Map<String, dynamic> json) => Question(
        question: json["question"],
        answers: json["answers"],
      );
}

Future<List<Question>> getQuestions(id) async {
  Dio dio = new Dio();
  List<Question> questions = [];
  final prefs = await SharedPreferences.getInstance();
  try {
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer ${prefs.getString("token")}";
    await dio
        .get(
          '${url}quiz/questions?idCategory=${id}',
        )
        .then((value) => {
              for (var quiz in value.data)
                {
                  print(quiz),
                  questions.add(
                    new Question(
                      question: quiz['question'],
                      answers: quiz['answers'],
                    ),
                  )
                }
            });
    return questions;
  } on DioError catch (e) {
    print(e);
  }
  return questions;
}
